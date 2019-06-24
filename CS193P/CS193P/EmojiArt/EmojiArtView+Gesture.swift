//
//  EmojiArtView+Gesture.swift
//  CS193P
//
//  Created by Carol on 2019/2/14.
//  Copyright © 2019年 Carol. All rights reserved.
//
import Foundation
import UIKit

// Gesture Recognition Extension to EmojiArtView
extension EmojiArtView
{
    // attach gesture recognizer to UILabel
    func addEmojiArtGestureRecognizers(to view: UIView) {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectSubview(_:))))
    }
    
    var selectedSubview: UIView? {
        set {
            subviews.forEach { $0.layer.borderWidth = 0 }
            newValue?.layer.borderWidth = 1
            if let subview = newValue {
                enableGestureRecognizer()
            } else {
                disableGestureRecognizer()
            }
        }
        get {
            return subviews.filter { $0.layer.borderWidth > 0 }.first
        }
    }
    
    @objc func selectSubview(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            selectedSubview = sender.view
        }
    }
    
    @objc func selectAndMoveSubview(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if selectedSubview != nil, sender.view != nil {
                selectedSubview = sender.view
            }
        case .changed, .ended:
            selectedSubview?.center = selectedSubview!.center.offset(by: sender.translation(in: self))
            sender.setTranslation(CGPoint.zero, in: self)
        default:
            break
        }
    }
    
    func enableGestureRecognizer() {
        if let scrollView = superview as? UIScrollView {
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.pinchGestureRecognizer?.isEnabled = false
        }
        if gestureRecognizers == nil || gestureRecognizers?.count == 0 {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deselectSubview(_:))))
            addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(resizeSelectedSubview(_:))))
        } else {
            gestureRecognizers?.forEach { $0.isEnabled = true }
        }
    }
    
    func disableGestureRecognizer() {
        if let scrollView = superview as? UIScrollView {
            scrollView.panGestureRecognizer.isEnabled = true
            scrollView.pinchGestureRecognizer?.isEnabled = true
        }
        gestureRecognizers?.forEach { $0.isEnabled = false }
    }
    
    @objc func deselectSubview(_ sender: UITapGestureRecognizer) {
        selectedSubview = nil
    }
    
    @objc func resizeSelectedSubview(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .changed, .ended:
            if let label = selectedSubview as? UILabel {
                label.transform = label.transform.scaledBy(x: sender.scale, y: sender.scale)
                sender.scale = 1.0
            }
        default:
            break
        }
    }
}
