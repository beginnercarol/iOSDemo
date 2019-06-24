//
//  DailyTasksView.swift
//  DailyTasks
//
//  Created by Carol on 2019/5/27.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

let labelHeight: CGFloat = 50

//class DailyTasksView: UIView {
//    var label: UILabel!
//    var collectionView: UICollectionView!
////    var tasks: [Task] = [
////        Task(name: nil, category: .Random, img: "add", color: 0)
////    ]
//    var text: String? {
//        set {
//            self.label.text = newValue
//        }
//        get {
//            return self.label.text ?? nil
//        }
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.backgroundColor = utility.theme.backgroundColor
//        let frame = self.frame
//        label = CategoryLabelView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: labelHeight))
//        self.addSubview(label)
//        label.text = "上午"
//        label.sizeToFit()
//        
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: self.frame.width/6, height: self.frame.width/6)
//        layout.scrollDirection = .vertical
//        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        self.addSubview(collectionView)
//        collectionView.snp.makeConstraints { (make) in
//            make.leading.equalTo(self.snp.leading)
//            make.trailing.equalTo(self.snp.trailing)
//            make.top.equalTo(self.label.snp.bottom)
//            make.bottom.equalTo(self.snp.bottom)
//        }
//
//        collectionView.register(TaskView.self, forCellWithReuseIdentifier: Utility.TaskViewCellIdentifier)
//    }
//}
//
//
//extension DailyTasksView: UICollectionViewDelegate {
//    
//}
//
//extension DailyTasksView: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return tasks.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.TaskViewCellIdentifier, for: indexPath) as! TaskView
//        
//        let index = indexPath.row
//        if index < self.tasks.count {
//            cell.task = self.tasks[index]
//        }
//        return cell
//    }
//}
