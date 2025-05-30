import SwiftUI
import SafariServices

struct SafariSheet: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url)
        vc.preferredControlTintColor = .label      
        vc.dismissButtonStyle = .close
        return vc
    }
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}
