//
//  ExampleAViewController.swift
//  webviewjs
//
//  Created by zick on 2022/2/7.
//

import UIKit
import SnapKit
import WebKit

class ExampleAViewController: UIViewController {

    private let urlString = "https://zickc.github.io/indexA.html"

    private var webView: SimpleWebView!
    private var label = UILabel()

    deinit {
        print("ExampleAViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        webView.configuration.userContentController.removeScriptMessageHandler(forName: "appBridge")
    }

    private func setupUI() {
        view.backgroundColor = UIColor.lightGray

        let button = UIButton(type: .custom)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top).offset(88)
            make.centerX.equalToSuperview()
        }
        button.setTitle("send message", for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(44)
            make.centerX.equalToSuperview()
        }
        label.text = "    "

        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        let jsEnabled = true

        contentController.add(self, name: "appBridge")
        configuration.userContentController = contentController

        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = jsEnabled
        } else {
            configuration.preferences.javaScriptEnabled = jsEnabled
        }

        // https://github.com/marcuswestin/WebViewJavascriptBridge/issues/383
        if #available(iOS 13.0, *) {
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        }

        webView = SimpleWebView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), configuration: configuration)
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(44)
            make.bottom.equalTo(view.safeArea.bottom)
            make.left.right.equalToSuperview()
        }

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)

            webView.evaluateJavaScript("navigator.userAgent") { [weak self] result, error in
                guard let self = self else { return }

                if let result = result {
                    let strings = [result as? String, Bundle.main.bundleIdentifier, UIDevice.current.model]
                    let custom = strings.compactMap({ $0 }).joined(separator: " ")
                    self.webView.customUserAgent = custom
                }
                if let error = error {
                    print("error: \(error.localizedDescription)")
                }

                self.webView.load(request)
            }
        }
    }

    @objc private func sendMessage() {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateformat.string(from: Date())

        let dict = ["action": "init",
                    "message": dateString
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            if let string = String(data: jsonData, encoding: .utf8) {
                let composed = "appBridge('" + string + "')"
                webView.evaluateJavaScript(composed) { [weak self] result, error in
                    let status = "result: \(result ?? "-- no result --")    error: \(error?.localizedDescription ?? "-- no error --")"
                    self?.label.text = status
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ExampleAViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let alertController = UIAlertController(title: nil,
                                                message: "didReceive    name: \(message.name)    \(message.body)",
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ -> Void in }
        alertController.addAction(action)

        self.present(alertController, animated: true)
    }
}
