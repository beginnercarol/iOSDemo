//
//  HelloJS.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/25.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class HelloJS: UIWebView {

}

extension HelloJS: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let url = request.url
        if url?.scheme == "callNativeHello" {
            nativeHello()
            return false
        } else if url?.scheme == "changelabeltext:我是改变后的文字" {
            nativeHello()
            return false
        }
        return true
    }
    
    func nativeHello() {
        NSLog("Clicked")
        let alert = UIAlertController(title: "Hello", message: "hello", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            NSLog("OK")
        }))
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let title = self.stringByEvaluatingJavaScript(from: "document.title")
        
        NSLog("Finish Loading: \(title)")
    }
    
    // Now work in master larer conflict may happen
    
    // again work in experiment to push to master
}
