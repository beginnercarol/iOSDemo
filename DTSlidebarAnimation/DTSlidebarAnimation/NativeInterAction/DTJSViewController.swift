//
//  DTJSViewController.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/25.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class DTJSViewController: UIViewController {
    var webView: WKWebView?
    
    var jsCtx: JSContext = JSContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.bounds)
        let script: WKUserScript = WKUserScript(source: "document.getElementsByTagName('p')[0].innerText = 'iOS'", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webView?.configuration.userContentController.addUserScript(script)
        let request = URLRequest(url: URL(string: "https://www.baidu.com")!)
        let url = Bundle.main.url(forResource: "Hello", withExtension: "html")
        let htmlStr = (try? String(data: Data(contentsOf: url!), encoding: .utf8)) ?? ""
        webView?.loadHTMLString(htmlStr, baseURL: URL(string: ""))
//        webView?.load(request)
        webView?.navigationDelegate = self
        self.view.addSubview(webView!)
    }
    
    
    
    func testForRuntime() {
        var count: UInt32 = 0
        var person = Person(firstName: "Carol", lastName: "Pang")
        let propertyList = class_getProperty(objc_getClass(person), &count)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DTJSViewController: WKNavigationDelegate  {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url!
        NSLog("WebView \(#function) and url: \(url.scheme)")
        if url.scheme == "https://www.callnative.com" {
            NSLog("Call Native Hello")
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow);
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("\(#function)")
    }
    
    // 3) 接受到网页 response 后, 可以根据 statusCode 决定是否 继续加载。allow or cancel, 必须执行回调 decisionHandler 。逃逸闭包的属性
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("\(#function)")
        guard let httpResponse = navigationResponse.response as? HTTPURLResponse else {
            decisionHandler(.allow)
            return
        }
        
        let policy : WKNavigationResponsePolicy = httpResponse.statusCode == 200 ? .allow : .cancel
        decisionHandler(policy)
    }
    
    // 4) 网页加载成功 与网页内的 js 相比较 是哪一个先加载???
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Success\(#function)")
        jsCtx.evaluateScript("var number = 10")
        jsCtx.evaluateScript("var names = ['Grace', 'Joe', 'Mike']")
        
        jsCtx.evaluateScript("function triple(value) { callNative(); return value*4 }")
//        jsCtx.evaluateScript("var triple = func(value) { return value*4 }")
        
        var tripleNumber: JSValue = jsCtx.evaluateScript("triple(number)")
        
        let tripleFunc: JSValue = jsCtx.objectForKeyedSubscript("triple")
        
        let tripleResult = tripleFunc.call(withArguments: [3])
        
        NSLog("triple number: \(tripleNumber) and tripleFuncResult: \(tripleResult)")
        
        var ocnames: JSValue = jsCtx.objectForKeyedSubscript("names")
        var len = ocnames.objectForKeyedSubscript("length")//JSValue 遵从 js
        NSLog("ocname: \(ocnames) and len: \(len)")
        ocnames.setObject("Emily", atIndexedSubscript: 8)
        len = ocnames.objectForKeyedSubscript("length")
        NSLog("ocname: \(ocnames) and len: \(len)")
        jsCtx.exceptionHandler = { (context, exception) in
            NSLog("JS ERROR: \(exception)")
        }
        
        var mother: Person = Person(firstName: "Lily", lastName: "Swan")
        jsCtx.setObject(mother, forKeyedSubscript: "mother" as NSCopying & NSObjectProtocol)
        
        var p: JSValue = jsCtx.objectForKeyedSubscript("mother")
        let first: JSValue = p.objectForKeyedSubscript("firstName")
        let last: JSValue = p.objectForKeyedSubscript("lastName")
        let birthYear: JSValue = p.objectForKeyedSubscript("birthYear")
        NSLog("p.first: \(first), p.last: \(last)")
        
        // 无法获取到 网页中的 JS 方法
//        var callNativeFunc: JSValue = jsCtx.objectForKeyedSubscript("forExp")
//        let callNativeResult: JSValue = callNativeFunc.call(withArguments: [3])
//        NSLog("Call Native: \(callNativeResult)")
        
//        jsCtx.evaluateScript("forExp(5)")
        
        webView.evaluateJavaScript("forExp(5)", completionHandler: { (success, error) in
                if let err = error {
                    NSLog("Failed: \(err)")
                } else {
                    NSLog("Success: \(success)")
                }
            })
        webView.evaluateJavaScript("document.getElementById('p2').innerText= 'p2'", completionHandler: nil)
        
        webView.configuration.userContentController.add(self, name: "forExp")
    }
    
    // 4) 加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("\(#function)")
        print(error.localizedDescription)
    }
    
}

extension DTJSViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Notice", message: "Attention plz", preferredStyle: .actionSheet)
        let actionConfirm = UIAlertAction(title: "OK", style: .default) { (action) in
            NSLog("Alert Confirmed")
            completionHandler()
        }
        alert.addAction(actionConfirm)
        self.present(alert, animated: true, completion: nil)
    }
}

extension DTJSViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        NSLog("message name: \(message.name)")
        NSLog("message body: \(message.body)")
    }
    
    
}
