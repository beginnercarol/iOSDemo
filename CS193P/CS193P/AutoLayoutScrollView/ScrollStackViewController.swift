//
//  ScrollStackViewController.swift
//  CS193P
//
//  Created by Carol on 2019/3/22.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class ScrollStackViewController: UIViewController {
    var addButton = UIButton(type: UIButton.ButtonType.custom)
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.contentSize = CGSize(width: view.bounds.width - 100, height: view.bounds.height)
//        scrollView.contentSize = CGSize(width: view.frame.width-(view.directionalLayoutMargins.leading+view.directionalLayoutMargins.trailing), height: view.frame.height-(view.directionalLayoutMargins.top+view.directionalLayoutMargins.bottom))
        scrollView.isScrollEnabled = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.zoomScale = 1.0
        scrollView.panGestureRecognizer.isEnabled = false
        return scrollView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: view.bounds)
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        let edgeInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 20, trailing: 10)
//        view.directionalLayoutMargins = edgeInsets
        let inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        
        for _ in 0..<22 {
            let entry = createEntry()
            stackView.addArrangedSubview(entry)
        }
        
        stackView.addArrangedSubview(addButton)
        
        addButton.setTitle("Add Entry", for: .normal)
        addButton.setTitleColor(UIColor.blue, for: .normal)
        addButton.addTarget(self, action: #selector(addEntry(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func addEntry(_ sender: AnyObject) {
        let stack = stackView
        let scroll = scrollView
        // zero??
        let index = stack.arrangedSubviews.count - 1
        let addView = stack.arrangedSubviews[index]
        let offset = CGPoint(x: scroll.contentOffset.x, y: scroll.contentOffset.y + addView.frame.size.height)
        
        let entry = createEntry()
        entry.isHidden = true
        stack.insertArrangedSubview(entry, at: index)
        
        UIView.animate(withDuration: 0.25) {
            entry.isHidden = false
            scroll.contentOffset = offset
        }
    }
    
    @objc func deleteEntry(_ sender: UIButton) {
        if let view = sender.superview {
            UIView.animate(withDuration: 0.25, animations: {
                view.isHidden = true
            }) { (success) in
                if success {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    func createEntry() -> UIView {
        let date = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
        let number = "\(randomHexQuad())-\(randomHexQuad())-\(randomHexQuad())-\(randomHexQuad())"
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        stack.spacing = 8
        
        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        let numberLabel = UILabel()
        numberLabel.text = number
        numberLabel.font = UIFont.preferredFont(forTextStyle: .body)
        numberLabel.textAlignment = .left
        
        let deleteButton = UIButton(type: .roundedRect)
        deleteButton.setTitle("delete", for: .normal)
        deleteButton.setTitleColor(UIColor.blue, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteEntry(_:)), for: .touchUpInside)
        
        deleteButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 750), for: .horizontal)
        numberLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 750), for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(numberLabel)
        stack.addArrangedSubview(deleteButton)
        
        return stack
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func randomHexQuad() -> String {
        return String(format: "%X%X%X%X", arc4random() % 16, arc4random() % 16, arc4random() % 16, arc4random() % 16)
    }

}

extension CGRect {
    func offsetByMarginInset(marginInset inset: NSDirectionalEdgeInsets) -> CGRect{
        return CGRect(x: minX+inset.leading, y: minY+inset.top, width: width-inset.leading-inset.trailing, height: height-inset.top-inset.bottom)
    }
}
