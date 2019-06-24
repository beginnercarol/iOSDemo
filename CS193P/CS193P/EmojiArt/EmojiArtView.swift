//
//  EmojiArtView.swift
//  CS193P
//
//  Created by Carol on 2019/1/19.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

protocol EmojiArtViewDelegate: class { //  restricted to only by classes
    func emojiArtViewDidChange(_ sender: EmojiArtView)
}


class EmojiArtView: UIView, UIScrollViewDelegate, UIDropInteractionDelegate {
    weak var delegate: EmojiArtViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        emojiScrollView.addInteraction(UIDropInteraction(delegate: self))
    }
    
    var backgroundImage: UIImage? {
        didSet {
            imageView.image = backgroundImage
            setNeedsDisplay()
            imageView.sizeToFit()
            imageView.contentMode = .scaleAspectFill
            imageView.frame = CGRect(origin: emojiScrollView.frame.origin, size: backgroundImage?.size ?? CGSize.zero)
            emojiScrollView.contentSize = backgroundImage?.size ?? CGSize.zero
        }
    }
    
    var imageView: UIImageView = UIImageView()

    lazy var emojiScrollView: UIScrollView! = {
        let scrollView = UIScrollView(frame: self.bounds)
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollView.contentMode = .center
        scrollView.contentSize = backgroundImage?.size ?? CGSize.zero
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        return scrollView
    }()
    private var labelObservations = [UIView: NSKeyValueObservation]()
    func addLabel(with attributedString: NSAttributedString, centerdAt point: CGPoint) {
        let label = UILabel()//EmojiArtResizableLabel()
        label.backgroundColor = .clear
        label.attributedText = attributedString
        label.sizeToFit()
        label.center = point
        addEmojiArtGestureRecognizers(to: label)
        imageView.addSubview(label)
        labelObservations[label] = label.observe(\.center, changeHandler: { (label, change) in
            self.delegate?.emojiArtViewDidChange(self)
            NotificationCenter.default.post(name: .EmojiArtViewDidChange, object: self)
        })
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        if labelObservations[subview] != nil {
            labelObservations[subview] = nil
        }
    }
    
    // MARK: - drop delegate
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSAttributedString.self) { providers in
            let position = session.location(in: self)
            for attributedString in providers as? [NSAttributedString] ?? [] {
                self.addLabel(with: attributedString, centerdAt: position)
                self.delegate?.emojiArtViewDidChange(self) // 所有的 delgate 中 的方法 不是由你自己调用的 
                NotificationCenter.default.post(name: .EmojiArtViewDidChange, object: self)
            }
        }
    }
}
