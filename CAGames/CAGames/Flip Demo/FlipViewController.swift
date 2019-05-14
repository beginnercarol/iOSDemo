//
//  FlipViewController.swift
//  CAGames
//
//  Created by Carol on 2019/5/7.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class FlipViewController: UIViewController {
    var squareView: UIView!
    
    var imgView = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
    override func viewDidLoad() {
        super.viewDidLoad()
        squareView = UIView(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
//        self.view.addSubview(squareView)
        self.view.addSubview(imgView)
        let imgDraw = UIImage(named: "draw")
        imgView.image = imgDraw
        imgView.contentMode = .scaleAspectFit
        squareView.backgroundColor = UIColor.red

        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rotate(_:))))
        self.view.backgroundColor = UIColor.white
    }
    
    @objc func rotate(_ sender: UITapGestureRecognizer) {
        addRotationAnimation(toView: imgView)
    }
    
    func addRotationAnimation(toView view: UIView) {
        var flipTransform3D = CATransform3DIdentity
        flipTransform3D.m34 = -1.0/2000.0
        flipTransform3D = CATransform3DRotate(flipTransform3D, CGFloat(Double.pi/2), 0, 1, 0)
        view.layer.isDoubleSided = true
        view.layer.cornerRadius = 5
        var twoStepFlip = CATransform3DIdentity
        twoStepFlip.m34 = -1.0/2000.0
        twoStepFlip = CATransform3DRotate(twoStepFlip, CGFloat(Double.pi), 0, 1, 0)
        UIView.animate(withDuration: 2, animations: {
            view.layer.transform = flipTransform3D
        }) { (success) in
            (view as? UIImageView)?.image = nil
            
            UIView.animate(withDuration: 2) {
                view.backgroundColor = UIColor.orange
                view.layer.transform = twoStepFlip
            }
        }
    }
    
    func addBasicAnimation(toView view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 2
        animation.toValue = NSValue(cgPoint: CGPoint(x: 400, y: 400))
        animation.repeatCount = MAXFLOAT
        animation.beginTime = CACurrentMediaTime() + 1
        
        view.layer.add(animation, forKey: nil)
    }
    
    
    func addFlipCardFrameAnimation(toView view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 5
        var oneStepFlip = CATransform3DIdentity
        oneStepFlip.m34 = -1.0/2000.0
        oneStepFlip = CATransform3DRotate(oneStepFlip, CGFloat(Double.pi/2), 0, 1, 0)
        var twoStepFlip = CATransform3DIdentity
        twoStepFlip.m34 = -1.0/2000.0
        twoStepFlip = CATransform3DRotate(twoStepFlip, CGFloat(Double.pi), 0, 1, 0)
        view.layer.isDoubleSided = true
        animation.values = [oneStepFlip, twoStepFlip]
        animation.keyTimes = [NSNumber(value: 0), NSNumber(value: 0.25), NSNumber(value: 0.50), NSNumber(value: 0.75), NSNumber(value: 1.0)]
    }
    
    
    func addFrameAnimation(toView view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 5
        animation.path = UIBezierPath(ovalIn: CGRect(x: 100, y: 100, width: 300, height: 300)).cgPath
        animation.keyTimes = [NSNumber(value: 0), NSNumber(value: 0.25), NSNumber(value: 0.50), NSNumber(value: 0.75), NSNumber(value: 1.0)]
        animation.rotationMode = .rotateAuto
//        animation.toValue = NSValue(cgPoint: CGPoint(x: 400, y: 400))
        animation.repeatCount = MAXFLOAT
//        animation.beginTime = CACurrentMediaTime() + 1
        view.layer.add(animation, forKey: nil)
    }
    
    
    func addTransitionAnimation(toView view: UIView) {
        let animation = CATransition()
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 5
        animation.type = .init(rawValue: "rippleEffect")
//        animation.subtype =
        view.layer.add(animation, forKey: nil)
        (view as? UIImageView)?.image = UIImage(named: "sandwich")
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
