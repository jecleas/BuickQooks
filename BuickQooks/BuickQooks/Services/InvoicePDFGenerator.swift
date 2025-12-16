import Foundation
import PDFKit
import SwiftUI
import UIKit

final class InvoicePDFGenerator {
    private let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter

    func generate(invoice: Invoice, template: TemplateSettings) -> URL? {
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: UIGraphicsPDFRendererFormat())
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Invoice-\(invoice.invoiceNumber).pdf")

        do {
            let data = try renderer.pdfData { context in
                context.beginPage()
                drawHeader(invoice: invoice, template: template)
                drawBillTo(invoice: invoice)
                drawLineItems(invoice: invoice)
                drawTotals(invoice: invoice)
                drawFooter(template: template)
            }
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            print("PDF generation failed: \(error)")
            return nil
        }
    }

    private func drawHeader(invoice: Invoice, template: TemplateSettings) {
        let logoFrame = CGRect(x: 32, y: 32, width: 120, height: 60)
        if let logoData = template.logoImageData, let image = UIImage(data: logoData) {
            image.draw(in: logoFrame)
        } else if let placeholder = UIImage(named: "app") {
            placeholder.draw(in: logoFrame)
        }

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 28, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.secondaryLabel
        ]

        let title = "Invoice \(invoice.invoiceNumber)"
        title.draw(in: CGRect(x: pageRect.maxX - 250, y: 32, width: 220, height: 34), withAttributes: titleAttributes)

        let companyStack = [
            template.companyName,
            template.companyEmail,
            template.companyAddress
        ].compactMap { $0 }.joined(separator: "\n")
        companyStack.draw(in: CGRect(x: pageRect.maxX - 250, y: 70, width: 220, height: 80), withAttributes: subtitleAttributes)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let meta = "Issue: \(dateFormatter.string(from: invoice.issueDate))\nDue: \(dateFormatter.string(from: invoice.dueDate))"
        meta.draw(in: CGRect(x: pageRect.maxX - 250, y: 150, width: 220, height: 50), withAttributes: subtitleAttributes)
    }

    private func drawBillTo(invoice: Invoice) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.label
        ]
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.label
        ]
        "Bill To".draw(in: CGRect(x: 32, y: 120, width: 200, height: 24), withAttributes: attributes)
        let details = [invoice.billTo.name, invoice.billTo.email, invoice.billTo.phone, invoice.billTo.address]
            .compactMap { $0 }
            .joined(separator: "\n")
        details.draw(in: CGRect(x: 32, y: 148, width: 250, height: 80), withAttributes: bodyAttributes)
    }

    private func drawLineItems(invoice: Invoice) {
        let startY: CGFloat = 230
        let columnX = [32, 280, 400, 500]
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular)
        ]
        let headers = ["Description", "Unit", "Qty", "Total"]
        for (index, header) in headers.enumerated() {
            header.draw(at: CGPoint(x: CGFloat(columnX[index]), y: startY), withAttributes: headerAttributes)
        }

        var currentY = startY + 24
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency

        for line in invoice.lineItems {
            let unit = currencyFormatter.string(from: line.unitPrice as NSNumber) ?? "-"
            let total = currencyFormatter.string(from: line.lineTotal as NSNumber) ?? "-"
            line.itemName.draw(at: CGPoint(x: CGFloat(columnX[0]), y: currentY), withAttributes: bodyAttributes)
            unit.draw(at: CGPoint(x: CGFloat(columnX[1]), y: currentY), withAttributes: bodyAttributes)
            "\(line.quantity)".draw(at: CGPoint(x: CGFloat(columnX[2]), y: currentY), withAttributes: bodyAttributes)
            total.draw(at: CGPoint(x: CGFloat(columnX[3]), y: currentY), withAttributes: bodyAttributes)
            currentY += 20
        }
    }

    private func drawTotals(invoice: Invoice) {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency

        let labels = ["Subtotal", "Tax", "Total"]
        let values: [Decimal] = [invoice.subtotal, invoice.taxTotal, invoice.total]
        let startY: CGFloat = 500
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        for (index, label) in labels.enumerated() {
            let y = startY + CGFloat(index * 24)
            label.draw(in: CGRect(x: 360, y: y, width: 120, height: 20), withAttributes: labelAttributes)
            let formatted = currencyFormatter.string(from: values[index] as NSNumber) ?? "-"
            formatted.draw(in: CGRect(x: 480, y: y, width: 100, height: 20), withAttributes: valueAttributes)
        }
    }

    private func drawFooter(template: TemplateSettings) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let footerRect = CGRect(x: 32, y: pageRect.maxY - 60, width: pageRect.width - 64, height: 40)
        template.footerText.draw(in: footerRect, withAttributes: attributes)
    }
}
