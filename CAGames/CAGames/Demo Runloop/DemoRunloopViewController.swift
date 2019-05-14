//
//  DemoRunloopViewController.swift
//  CAGames
//
//  Created by Carol on 2019/5/8.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class DemoRunloopViewController: UIViewController {
    var runloop = RunLoop.current
    var textField: UITextField!
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField = UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.layer.borderWidth = 5.0
        textField.layer.cornerRadius = 10.0
//        view.addSubview(textField)
        view.backgroundColor = UIColor.white
        imageView = UIImageView(image: UIImage(named: "draw"))
        scrollView = UIScrollView(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
        scrollView.contentSize = imageView.frame.size
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
    }
    
    // 当滚动 scrollView时, timer 被暂停了
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let timer = Timer(timeInterval: 2.0, target: self, selector: #selector(show(_:)), userInfo: nil, repeats: true)
        // 默认模式
//        RunLoop.current.add(timer, forMode: .default)
        // 修改模式为 common mode, 此时 timer 不会被暂停
        RunLoop.current.add(timer, forMode: .common)
        
    }
    
    @objc func show(_ sender: AnyClass?){
        NSLog("---------")
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
