//
//  StackViewController.swift
//  CS193P
//
//  Created by Carol on 2019/3/21.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
class StackViewController: UIViewController {
    lazy private var stackView: UIStackView = {
        let stack = UIStackView(frame: self.view.bounds)
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()
    
    var flowerLabel: UILabel = UILabel()
    var flowerImageView: UIImageView = UIImageView()
    var editButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let edgeInset = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5)
        view.directionalLayoutMargins = edgeInset
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.yellow
        stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        flowerImageView.contentMode = .scaleAspectFill
        flowerImageView.image = UIImage(named: "flower")
        flowerLabel.text = "White Rose"
        flowerLabel.textAlignment = .center
        editButton.setTitle("Click", for: .normal)
        stackView.addArrangedSubview(flowerLabel)
        stackView.addArrangedSubview(flowerImageView)
        stackView.addArrangedSubview(editButton)
        
        flowerImageView.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        flowerImageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 750), for: .horizontal)
        flowerImageView.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        flowerImageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .vertical)
        
        
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
