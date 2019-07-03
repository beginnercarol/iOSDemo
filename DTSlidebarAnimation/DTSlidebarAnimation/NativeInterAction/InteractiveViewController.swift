//
//  InteractiveViewController.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/25.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class InteractiveViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = HelloJS(frame: view.bounds)
        let url = Bundle.main.url(forResource: "Hello", withExtension: "html")
        let string = (try? String(data: Data(contentsOf: url!), encoding: .utf8)) ?? ""
        webView.loadHTMLString(string, baseURL: URL(string: "Hello"))
        webView.stringByEvaluatingJavaScript(from: string)
        self.view.addSubview(webView)
    }
}
