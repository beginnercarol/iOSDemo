//
//  DocumentViewController.swift
//  CS193P
//
//  Created by Carol on 2019/2/12.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class DocumentViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsDocumentCreation = true
        allowsPickingMultipleItems = true
        browserUserInterfaceStyle = .dark
        view.tintColor = .white
        // Do any additional setup after loading the view.
//        setup()
    }
    
//    func setup() {
//        let emojiVC = EmojiArtViewController()
//        self.addChild(emojiVC)
//        self.view.addSubview(emojiVC.view)
//    }
//    
//    func presentDocument(at url: URL) {
//        let emojiVC = EmojiArtViewController()
//    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UIDocumentBrowserViewControllerDelegate
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let url: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("emojiArt")
        importHandler(url, .copy)
    }

}
