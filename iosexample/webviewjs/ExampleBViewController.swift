//
//  ExampleBViewController.swift
//  webviewjs
//
//  Created by zick on 2022/2/7.
//

import UIKit
import SnapKit
import SKJavaScriptBridge

class ExampleBViewController: UIViewController {

    private let urlString = "https://zickc.github.io/indexB.html"
    private let kToAppBridge = "appBridge"
    private let kFromAppBridge = "appBridge"

    private var webView: SimpleWebView!
    private var jsBridge: WebViewJavascriptBridge!
    private var label = UILabel()

    deinit {
        print("ExampleBViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        jsBridge.removeHandler(kToAppBridge)
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
        let jsEnabled = true

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

        jsBridge = WebViewJavascriptBridge(for: webView, showJSconsole: true, enableLogging: true)
        jsBridge.registerHandler(kToAppBridge) { [weak self] data, callback in
            if let dict = data as? [String: String] {
                print("**** data from FrontEnd: \(dict)")
            }

            let responseDict = [
                "handlerCalled": self?.kToAppBridge ?? "--",
                "timestamp": self?.currentTimeString() ?? "--"
            ]
            callback(responseDict)
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
        let dict = ["action": "init",
                    "timestamp": currentTimeString()
        ]
        jsBridge.callHandler(kFromAppBridge, data: dict) { response in
            if let dict = response as? [String: String] {
                print("**** response: \(dict)")
            } else {
                print("**** response, received")
            }
        }
    }

    private func currentTimeString() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss.sss"
        dateformat.timeZone = TimeZone(abbreviation: "UTC")
        return dateformat.string(from: Date())
    }
}
