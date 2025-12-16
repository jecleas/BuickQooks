import Foundation
import SwiftUI

struct TemplateSettings: Equatable {
    var logoImageData: Data?
    var footerText: String
    var primaryColor: Color = Color(red: 0/255, green: 120/255, blue: 72/255)
    var companyName: String
    var companyEmail: String?
    var companyAddress: String?
}
