import Foundation

extension String {
    
    var removedHTMLCode: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
