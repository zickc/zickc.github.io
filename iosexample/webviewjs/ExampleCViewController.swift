//
//  ExampleCViewController.swift
//  webviewjs
//
//  Created by zick on 2022/2/7.
//

import UIKit
import WebKit


class ExampleCViewController: UIViewController {

    private let urlString = "https://www.youtube.com/watch?v=pb_wN2GUFR0"

    private var webView: WKWebView!

    deinit {
        print("ExampleCViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.bottom.equalTo(view.safeArea.bottom)
            make.left.right.equalToSuperview()
        }
        webView.navigationDelegate = self

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
}

extension ExampleCViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let policy = WKNavigationActionPolicy.allow

        if let url = navigationAction.request.url {
            print("navigationAction: \(url)")
        }

        decisionHandler(policy)
    }
}
