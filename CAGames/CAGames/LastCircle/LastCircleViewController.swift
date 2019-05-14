//
//  LastCircleViewController.swift
//  CAGames
//
//  Created by Carol on 2019/5/4.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class LastCircleViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var gameModel: LastCircleGameModel!
    var circleViews = [UIView]()
    var lastCircle: UIView? {
        return circleViews.last
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameModel = LastCircleGameModel(height: Int(self.view.frame.height), width: Int(self.view.frame.width))
        self.view.backgroundColor = UIColor.white
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickToIdentifyCircle(_:))))
        startNewGame()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func startNewGame() {
        gameModel.clearAll()
        showPreCircles()
        createTheLastCircle()
    }
    
    func showPreCircles() {
        for circle in gameModel.circles {
            createCircleView(circle, animated: false)
        }
    }
    
    func createTheLastCircle() {
        gameModel.createNewCircle()
        if let newCircle = gameModel.circles.last {
            createCircleView(newCircle, animated: true)
        }
    }
    
    func updateGame() {
        showPreCircles()
        createTheLastCircle()
    }
    
    @objc func clickToIdentifyCircle(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let position = sender.location(in: self.view)
            if let lastCir = lastCircle {
                if lastCir.bounds.contains(position) {
                    NSLog("success!")
                    updateGame()
                } else {
                    NSLog("Failed!")
                    self.startNewGame()
                }
            }
        }
    }
    
    func updateScore() {
        
    }
    

    func createCircleView(_ circle: CACircle, animated: Bool = false) -> UIView {
        let cir = UIView(frame: CGRect(x: 0, y: 0, width: circle.radius, height: circle.radius))
        cir.backgroundColor = circle.color
        cir.layer.cornerRadius = CGFloat(circle.radius)
        cir.clipsToBounds = true
        cir.isUserInteractionEnabled = true
        cir.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickToIdentifyCircle(_:))))
        self.view.addSubview(cir)
        circleViews.append(cir)
        cir.snp.makeConstraints { (make) in
            make.height.equalTo(2*circle.radius)
            make.width.equalTo(2*circle.radius)
            make.center.equalTo(circle.position)
        }
        if animated {
            cir.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            UIView.animate(withDuration: 0.25) {
                cir.transform = .identity
            }
        }
        return cir
    }
    
   

}
