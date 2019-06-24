//
//  AddTaskViewController.swift
//  DailyTasks
//
//  Created by Carol on 2019/6/5.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class AddTaskViewController: DTViewController {
    var contentStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupStackView()
        // Do any additional setup after loading the view.
    }
    
    
    func setupView() {
        let scrollView =  UIScrollView(frame: CGRect.zero)

            //UIScrollView(frame: self.contentView.bounds)
        scrollView.contentSize = self.contentView.bounds.size
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        contentStackView = UIStackView(frame: self.view.frame)
        scrollView.addSubview(contentStackView)
        scrollView.backgroundColor = UIColor.red
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillProportionally
    }
    
    var nameInputView: UIView!
    
    func setupStackView() {
        nameInputView = UIView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 120))
        nameInputView.backgroundColor = UIColor.gray
        nameInputView.layer.cornerRadius = 5
        nameInputView.clipsToBounds = true
        contentStackView.addArrangedSubview(nameInputView)

        let inputLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        resizeLabelToFitText(inputLabel, withText: "给习惯命名:")
        nameInputView.addSubview(inputLabel)
        inputLabel.backgroundColor = UIColor.gray
        
        let inputTextFiled = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        nameInputView.addSubview(inputTextFiled)
        inputTextFiled.placeholder = "e.g. Running Swimming etc."
        
        inputLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameInputView.snp.leading)
            make.top.equalTo(nameInputView.snp.top)
//            make.width.equalTo(nameInputView.snp.width/3)
            make.height.equalTo(40)
        }
        
        inputTextFiled.snp.makeConstraints { (make) in
            make.leading.equalTo(nameInputView.snp.leading)
            make.top.equalTo(inputLabel.snp.bottom).offset(10)
            make.width.equalTo(250)
            make.height.equalTo(60)
        }
        
    }

    func resizeLabelToFitText(_ label: UILabel, withText text: String) -> CGSize {
        //        let label = UILabel(frame: CGRect.zero)
        let font = UIFont.preferredFont(forTextStyle: .body)
        let fontMatrics = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let nsattributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: fontMatrics, NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle()])
        label.attributedText = nsattributedString
        label.sizeToFit()
        let size = CGSize(width: label.frame.width, height: label.font.lineHeight)
        
        label.frame = CGRect(x: label.frame.minX, y: label.frame.minY, width: size.width, height: size.height).inset(by: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5))
        
        return size
    }
    

}
