import Foundation

extension Date {
    func stringWithFormat(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
