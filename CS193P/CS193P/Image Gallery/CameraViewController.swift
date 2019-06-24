//
//  CameraViewController.swift
//  CS193P
//
//  Created by Carol on 2019/3/9.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    var session: AVCaptureSession = AVCaptureSession()
    var device: AVCaptureDevice!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setupCaptureSession() {
        
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
