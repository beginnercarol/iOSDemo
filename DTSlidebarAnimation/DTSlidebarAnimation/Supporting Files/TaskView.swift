//
//  TaskView.swift
//  DailyTasks
//
//  Created by Carol on 2019/5/27.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import CoreMedia

enum TaskState {
    case Finished
    case OnGoing
    case Paused
}

class TaskView: UICollectionViewCell {
    var task: Task! {
        didSet {
            self.backgroundColor = task.color
            self.imgView.image = UIImage(named: task.img)
            if CMTimeGetSeconds(task.current) != 0 {
                switch self.state {
                case .Finished:
                    return
                case .OnGoing:
                    self.timeLabel.attributedText = getCurrentTime(withTime: task.current)
                //                    self.indicatorImageView.image = UIImage(named: "pause")
                case .Paused:
                    self.timeLabel.attributedText = getCurrentTime(withTime: task!.current)
                    //                    self.indicatorImageView.image = UIImage(named: "start")
                }
            }
        }
    }
    
    
    var imgView: UIImageView!
    
    var tapToUseTimer: (() -> Void)!
    
    var indicatorImageView: UIImageView!
    
    var timeLabel: UILabel!
    
    var state: TaskState = .Paused
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.width*0.5
        imgView = UIImageView(frame: self.bounds)
        imgView.layer.cornerRadius = self.frame.width*0.5
        indicatorImageView = UIImageView(frame: self.bounds)
        indicatorImageView.layer.cornerRadius = self.frame.width*0.5
        
        self.addSubview(imgView)
        self.addSubview(indicatorImageView)
        
        timeLabel = UILabel(frame: self.bounds)
        timeLabel.backgroundColor = UIColor.clear
        timeLabel.textAlignment = .center
        timeLabel.tintColor = UIColor.white
        self.addSubview(timeLabel)
        timeLabel.isHidden = false
        timeLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.backgroundColor = UIColor.lightGray
    }
    
    func getCurrentTime(withTime time: CMTime) -> NSAttributedString {
        let minutes = Int(floor(CMTimeGetSeconds(time)/60))
        let seconds = Int(CMTimeGetSeconds(time) - Double(minutes*60))
        let str = String(format: "%02d : %02d", minutes, seconds)
        let font = UIFont.preferredFont(forTextStyle: .body)
        let fontMatrics = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let nsattributedString = NSAttributedString(string: str, attributes: [NSAttributedString.Key.font: fontMatrics, NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle(), NSAttributedString.Key.foregroundColor: UIColor.white])
        return nsattributedString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class TaskHeaderView: UICollectionReusableView {
    var label: UILabel!
    var text: String? {
        set {
            //            label.text = newValue
            resizeLabelToFitText(label, withText: newValue as! String)
        }
        get {
            return label.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(frame: self.bounds)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        //        self.addSubview(stackView)
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: self.frame.height))
        label.layer.cornerRadius = 10
        label.backgroundColor = UIColor.gray
        label.clipsToBounds = true
        
        self.addSubview(label)
        //        stackView.addArrangedSubview(label)
        //        stackView.layoutMargins = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        //        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resizeLabelToFitText(_ label: UILabel, withText text: String) -> CGSize {
        //        let label = UILabel(frame: CGRect.zero)
        let font = UIFont.preferredFont(forTextStyle: .body)
        let fontMatrics = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let nsattributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: fontMatrics, NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle()])
        label.attributedText = nsattributedString
        label.sizeToFit()
        let size = CGSize(width: label.frame.width, height: label.font.lineHeight)
        
        label.frame = CGRect(x: label.frame.minX, y: label.frame.minY, width: size.width+50, height: size.height+20).inset(by: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5))
        label.textAlignment = .center
        return size
    }
    
}
