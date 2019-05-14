//
//  LastCircleAnimator.swift
//  CAGames
//
//  Created by Carol on 2019/5/5.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class FillScreenAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        if let fromView = fromViewController?.view, let toView = toViewController?.view {
            containerView.addSubview(toView)
        }
    }
}

