//
//  LastCircleStartViewController.swift
//  CAGames
//
//  Created by Carol on 2019/5/5.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class LastCircleStartViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var lastCircleStartView: LastCircleStartView!
    var gameViewController: LastCircleViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        gameViewController = LastCircleViewController()
        gameViewController.transitioningDelegate = self
        lastCircleStartView = LastCircleStartView(frame: self.view.frame)
        self.view.addSubview(lastCircleStartView)
        lastCircleStartView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    lastCircleStartView.gameStart.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gameStartAction(_:))))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 2, delay: 0.0, options: [.allowUserInteraction, .autoreverse, .repeat], animations: {
            self.lastCircleStartView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (success) in
            self.lastCircleStartView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    // presenting in this way, the root vc is not changed, so the responder chain
    // remains as before, the presented vc is not included ?
    @objc func gameStartAction(_ sender: UITapGestureRecognizer) {
        gameViewController.modalPresentationStyle = .fullScreen
        if let circleView = sender.view as? CircleView {
            UIView.animate(withDuration: 0.5, animations: {
                circleView.transform = CGAffineTransform(scaleX: 5, y: 5)
            }) { (success) in
                UIView.animate(withDuration: 0.25, animations: {
                    circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
                }, completion: { (success) in
                    self.present(self.gameViewController, animated: true, completion: nil)
                })
            }
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FillScreenAnimator()
    }
    


}

