//
//  DocumentBrowserViewController.swift
//  eee
//
//  Created by Carol on 2019/2/14.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        template = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("untitled.json")
        if template != nil {
            allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
        }
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var template: URL?
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        presentDocument(at: sourceURL)
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {

    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        let emojiVC = EmojiArtViewController()
        
        let navigationVC = UINavigationController(rootViewController: emojiVC)
        emojiVC.document = EmojiArtDocument(fileURL: documentURL)
        
        present(navigationVC, animated: true, completion: nil)
        
    }
}

