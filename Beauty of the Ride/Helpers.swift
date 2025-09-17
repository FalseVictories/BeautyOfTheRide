import UIKit

@MainActor
func openSettings() {
    if let url = URL.init(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
