import Foundation

final class InvoiceNumberFormatter {
    private let formatter: DateFormatter

    init() {
        formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
    }

    func generate(for date: Date = Date(), sequence: Int = Int.random(in: 1...999)) -> String {
        let day = formatter.string(from: date)
        return String(format: "INV-%@-%03d", day, sequence)
    }
}
