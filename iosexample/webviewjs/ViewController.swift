//
//  ViewController.swift
//  webviewjs
//
//  Created by zick on 2022/1/28.
//

import UIKit
import SnapKit
import WebKit

class ViewController: UIViewController {

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        URLCache.shared.removeAllCachedResponses()

        let types = Set([WKWebsiteDataTypeFetchCache,
                     WKWebsiteDataTypeDiskCache,
                     WKWebsiteDataTypeMemoryCache
        ])
        WKWebsiteDataStore.default().removeData(ofTypes: types,
                                                modifiedSince: Date(timeIntervalSince1970: 0),
                                                completionHandler: {}
        )

        setupUI()
    }

    private func setupUI() {
        title = "Testbed"

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.bottom.equalTo(view.safeArea.bottom)
            make.left.right.equalToSuperview()
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!

        var text = ""
        switch indexPath.row {
        case 0: text = "A"
        case 1: text = "B"
        default: break
        }
        cell.textLabel?.text = text

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController?
        switch indexPath.row {
        case 0: vc = ExampleAViewController()
        case 1: vc = ExampleBViewController()
        default: break
        }

        if let vc = vc {
            navigationController?.pushViewController(vc, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
