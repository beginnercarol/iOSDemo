//
//  NestedStackViewController.swift
//  CS193P
//
//  Created by Carol on 2019/3/21.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class NestedStackViewController: UIViewController {
    var stackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    var nestedStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    lazy var labelNestedStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.addArrangedSubview(createNestedLabelStackView(withTitle: "First"))
        stack.addArrangedSubview(createNestedLabelStackView(withTitle: "Middle"))
        stack.addArrangedSubview(createNestedLabelStackView(withTitle: "Last"))
        return stack
    }()
    
    var flowerImageView = UIImageView()
    
    var textView = UITextView()
    
    var selfie: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "selfie")
        return imgView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.yellow
        stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        nestedStackView.addArrangedSubview(selfie)
        selfie.translatesAutoresizingMaskIntoConstraints = false
        selfie.widthAnchor.constraint(equalTo: selfie.heightAnchor, multiplier: 1).isActive = true
        nestedStackView.addArrangedSubview(labelNestedStackView)
        
        selfie.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        selfie.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        selfie.setContentHuggingPriority(UILayoutPriority(rawValue: 48), for: .vertical)
        selfie.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .vertical)
        
        labelNestedStackView.setContentHuggingPriority(UILayoutPriority(rawValue: 48), for: .horizontal)
        labelNestedStackView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 48), for: .horizontal)
        
        labelNestedStackView.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
        labelNestedStackView.setContentCompressionResistancePriority(UILayoutPriority(249), for: .vertical)
        stackView.addArrangedSubview(nestedStackView)
        stackView.addArrangedSubview(flowerImageView)
        stackView.addArrangedSubview(textView)
        flowerImageView.image = UIImage(named: "flower")
        flowerImageView.contentMode = .scaleAspectFill
        flowerImageView.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
        flowerImageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .vertical)
        nestedStackView.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
        nestedStackView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .vertical)
        
    }
    
    
    func createNestedLabelStackView(withTitle title: String) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(22)
        let fontMetrix = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let label = UILabel()
        label.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font:fontMetrix, .paragraphStyle: paragraphStyle])
        label.setContentCompressionResistancePriority(UILayoutPriority(250), for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter " + title + " Name"
        inputTextField.setContentCompressionResistancePriority(UILayoutPriority(249), for: .horizontal)
        inputTextField.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(inputTextField)
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

}

