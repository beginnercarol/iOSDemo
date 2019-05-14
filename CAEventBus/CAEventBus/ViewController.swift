//
//  ViewController.swift
//  CAEventBus
//
//  Created by Carol on 2019/4/23.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("viewDidLoad")
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        addNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotifications()
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    // 通过 notificationcenter 添加通知
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveNotifications(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func onDidReceiveNotifications(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Int] {
            for (name, score) in data {
                print("\(name) score \(score) points")
            }
        }
        switch notification.name {
        case UIDevice.orientationDidChangeNotification:
            NSLog("Orientation did Change")
            let device = UIDevice.current
            NSLog("Device orientation: \(device.orientation)")
        default:
            break
        }
    }
    
}

