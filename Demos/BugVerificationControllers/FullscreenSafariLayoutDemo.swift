import UIKit
import SafariServices
import FittedSheets

final class FullscreenSafariLayoutDemo: UIViewController, Demoable {
    static var name: String { "Sheet layout after closing Safari" }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let instructions = UILabel()
        instructions.text = "Open Safari, then tap Done to return. Repeat and rotate the device. The sheet should keep its width and its bottom button should remain visible."
        instructions.numberOfLines = 0
        instructions.font = .preferredFont(forTextStyle: .body)
        instructions.adjustsFontForContentSizeCategory = true
        instructions.textColor = .black

        let openButton = UIButton(type: .system)
        openButton.setTitle("Open Safari", for: .normal)
        openButton.addTarget(self, action: #selector(openSafari), for: .touchUpInside)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close sheet", for: .normal)
        closeButton.addTarget(self, action: #selector(closeSheet), for: .touchUpInside)

        for subview in [instructions, openButton, closeButton] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            instructions.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 24),
            instructions.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            instructions.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            openButton.topAnchor.constraint(equalTo: instructions.bottomAnchor, constant: 24),
            openButton.leadingAnchor.constraint(equalTo: instructions.leadingAnchor),
            openButton.trailingAnchor.constraint(equalTo: instructions.trailingAnchor),
            openButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            closeButton.topAnchor.constraint(greaterThanOrEqualTo: openButton.bottomAnchor, constant: 24),
            closeButton.leadingAnchor.constraint(equalTo: instructions.leadingAnchor),
            closeButton.trailingAnchor.constraint(equalTo: instructions.trailingAnchor),
            closeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -24),
            closeButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }

    @objc private func openSafari() {
        guard let url = URL(string: "https://example.com") else { return }
        let browser = SFSafariViewController(url: url)
        // Full-screen is intentional: it removes the sheet view from its container.
        // Using overFullScreen would hide the regression this demo exercises.
        browser.modalPresentationStyle = .fullScreen
        present(browser, animated: true)
    }

    @objc private func closeSheet() {
        dismiss(animated: true)
    }

    static func openDemo(from parent: UIViewController, in view: UIView?) {
        let options = SheetOptions(useFullScreenMode: false, shrinkPresentingViewController: false)
        let sheet = SheetViewController(controller: FullscreenSafariLayoutDemo(),
                                        sizes: [.marginFromTop(80)], options: options)
        sheet.allowPullingPastMaxHeight = false
        parent.present(sheet, animated: true)
    }
}
