//
//  TransformViewController.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/14.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class TransformViewController: UIViewController {
    var rec: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        rec = UIView(frame: .zero)
        self.view.addSubview(rec)
        rec.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.center.equalTo(self.view.snp.center)
        }
        
        addDice()
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(updateRecWithPangesture(_:)))
        rec.addGestureRecognizer(panGesture)
    }
    
    @objc func updateRecWithPangesture(_ sender: UIPanGestureRecognizer) {
        var matrix = CATransform3DIdentity
        matrix.m34 = -1.0 / 1000
        
        var angle = CGPoint(x: 0, y: 0)
        
        let position = sender.translation(in: rec)
        let angleX = angle.x + position.x / 60
        let angleY = angle.y - position.y / 60
        
        matrix = CATransform3DRotate(matrix, angleX, 1, 0, 0)
        matrix = CATransform3DRotate(matrix, angleY, 0, 1, 0)
        rec.layer.sublayerTransform = matrix
        if sender.state == .ended {
            angle.x = angleX
            angle.y = angleY
        }
    }
    
    func updateRec() {
        var matrix = CATransform3DIdentity
        matrix.m34 = -1.0 / 1000
        let rotation = CATransform3DRotate(matrix, CGFloat(45), 0, 1, 0)
        rec.layer.transform = rotation
    }
    
    func addDice() {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0/1000
        
        let dice1 = UIImageView(frame: .zero)
        dice1.image = UIImage(named: "dice1")
        rec.addSubview(dice1)
        dice1.backgroundColor = UIColor.blue
        dice1.snp.makeConstraints { (make) in
            make.edges.equalTo(rec)
        }
        dice1.layer.transform = CATransform3DTranslate(identity, 0, 0, 100)
        
        let dice2 = UIImageView(image: UIImage(named: "dice2"))
        rec.addSubview(dice2)
        dice2.snp.makeConstraints { (make) in
            make.edges.equalTo(rec)
        }
        var transform2 = CATransform3DRotate(identity, CGFloat.pi/2, 1, 0, 0)

        // 因为旋转后 坐标系也跟着一起旋转了!
        dice2.layer.transform = CATransform3DTranslate(transform2, 0, 0, 100)
        
        let dice3 = UIImageView(image: UIImage(named: "dice3"))
        rec.addSubview(dice3)
        dice3.snp.makeConstraints { (make) in
            make.edges.equalTo(rec)
        }
        var transform3 = CATransform3DRotate(identity, -CGFloat.pi/2, 0, 1, 0)
        
        dice3.layer.transform = CATransform3DTranslate(transform3, 0, 0, 100)
        
        let dice4 = UIImageView(image: UIImage(named: "dice4"))
        rec.addSubview(dice4)
        dice4.snp.makeConstraints { (make) in
            make.edges.equalTo(rec)
        }
        var tansform4 = CATransform3DRotate(identity, -CGFloat.pi/2, 0, 1, 0)
        
        dice4.layer.transform = CATransform3DTranslate(tansform4, 0, 0, -100)
        
        
        let dice5 = UIImageView(image: UIImage(named: "dice4"))
        rec.addSubview(dice5)
        dice5.snp.makeConstraints { (make) in
            make.edges.equalTo(rec)
        }
        
        var tansform5 = CATransform3DRotate(identity, CGFloat.pi/2, 1, 0, 0)
        
        dice5.layer.transform = CATransform3DTranslate(tansform5, 0, 0, -100)
        
        let dice6 = UIImageView(image: UIImage(named: "dice6"))
        rec.addSubview(dice6)
        dice6.snp.makeConstraints { (make) in
            make.edges.equalTo(rec)
        }
        var tansform6 = CATransform3DTranslate(identity, 0, 0, -100)
        dice6.layer.transform = tansform6
        
        
        
        
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
