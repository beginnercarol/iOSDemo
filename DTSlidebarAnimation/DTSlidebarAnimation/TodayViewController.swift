//
//  TodayViewController.swift
//  DailyTasks
//
//  Created by Carol on 2019/5/27.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import SnapKit
import CoreMedia

let utility = Utility()
//Utility(viewRect: UIScreen.main.bounds)

class TodayViewController: DTViewController {
    //    var infoTopView: UIView!
    var infoBtn: UIButton!
    var addTaskBtn: UIButton!
    var searchBar: UISearchBar!
    var model = DailyTaskModel()
    var allTasks: [AllTasks] = []
    
    var navigationVC: UINavigationController!
    
    var taskCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        allTasks = model.allTasks
        setupView()
        // Do any additional setup after loading the view.
    }
    
    var timer: Timer!
    var displayLink: CADisplayLink?
    // Task 是 struct, 不是引用类型,因此不能通过 selectedTask 直接获取到
    var selectedTask: Task? {
        if let section = selectedIndex?.section, let row = selectedIndex?.row {
            return self.model.allTasks[section].lists[row]
        }
        return nil
    }
    
    var selectedIndex: IndexPath?
    
    
    func setupView() {
        
        setupCollectionView()
        setupAnimation()
    }
    
    override func setupInfoTopView() {
        super.setupInfoTopView()
        
        infoBtn = UIButton(frame: CGRect(x: 0, y: 0, width: infoBtnWidth, height: 50))
        infoBtn.setImage(UIImage(named: "information"), for: .normal)
        //        infoBtn.setContentCompressionResistancePriority(UILayoutPriority(750), for: .horizontal)
        topStackView.addArrangedSubview(infoBtn)
        infoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(80)
        }
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: searchBarWidth, height: 50))
        searchBar.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        searchBar.placeholder = "search"
        //        topStackView.addArrangedSubview(searchBar)
        
        addTaskBtn = UIButton(frame: CGRect(x: 0, y: 0, width: settingBtnWidth, height: 50))
        addTaskBtn.setImage(UIImage(named: "add"), for: .normal)
        topStackView.addArrangedSubview(addTaskBtn)
        addTaskBtn.snp.makeConstraints { (make) in
            make.width.equalTo(80)
        }
        addTaskBtn.setContentCompressionResistancePriority(UILayoutPriority(250), for: .horizontal)
        addTaskBtn.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = collectionViewItemSize
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = collectionViewHeaderSize
        taskCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        taskCollectionView.allowsMultipleSelection = false
        self.contentView.addSubview(taskCollectionView)
        taskCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView.snp.leading)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.top.equalTo(self.contentView.snp.top)
            make.bottom.equalTo(self.contentView.snp.bottom)
            //            make.height.equalTo(self.contentView.frame.height)
        }
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        taskCollectionView.backgroundColor = UIColor.white
        taskCollectionView.register(TaskView.self, forCellWithReuseIdentifier: Utility.TaskViewCellIdentifier)
        taskCollectionView.register(TaskHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Utility.TaskViewHeaderIdentifier)
    }
    
    var congratulationImgView: UIImageView!
    var startTime: CFTimeInterval?
    var endTime: CFTimeInterval?
    var animationDuration: CFTimeInterval!
    
    func setupAnimation() {
        congratulationImgView = UIImageView(image: UIImage(named: "firework"))
        congratulationImgView.contentMode = .center
        self.view.addSubview(congratulationImgView)
        congratulationImgView.center = CGPoint(x: self.view.center.x, y: self.view.frame.height + congratulationImgView.frame.height/2)
        congratulationImgView.isHidden = true
    }
    
    func showCongratulationAnimation() {
        let height = self.view.frame.height + congratulationImgView.frame.height
        congratulationImgView.center = CGPoint(x: self.view.center.x, y: self.view.frame.height + congratulationImgView.frame.height/2)
        congratulationImgView.isHidden = false
        startTime = CACurrentMediaTime()
        endTime = animationDuration + startTime!
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.add(to: RunLoop.main, forMode: .common)
    }
    
    @objc func updateAnimation() {
        guard let endTime = endTime, let startTime = startTime else {
            return
        }
        let now = CACurrentMediaTime()
        if now >= endTime {
            displayLink?.isPaused = true
            displayLink?.invalidate()
            congratulationImgView.isHidden = true
        }
        let height = self.view.frame.height
        let imgViewHeight = congratulationImgView.frame.height
        let percentage = (now - startTime) / animationDuration
        //        let y = height - (height + imgViewHeight)*percentage + imgViewHeight/2
        let x = CGFloat.random(in: -0.5...0.5)
        
        //        congratulationImgView.center = CGPoint(x: congratulationImgView.center.x + x, y: y)
    }
}

extension TodayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        selectedIndex = indexPath
        
        let cell = collectionView.cellForItem(at: indexPath) as! TaskView
        switch cell.state {
        case .Finished:
            return
        case .OnGoing:
            cell.state = .Paused
            timer.invalidate()
        case .Paused:
            timer = Timer(timeInterval: 1, target: self, selector: #selector(setTimer(_:)), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .common)
            cell.state = .OnGoing
        }
    }
    
    @objc func setTimer(_ sender: Timer) {
        NSLog("Fire date: \(sender.fireDate.description)")
        let section = selectedIndex!.section
        let row = selectedIndex!.row
        let task = self.model.allTasks[section].lists[row]
        let duration = Float(CMTimeGetSeconds(task.duration))
        var current = Float(CMTimeGetSeconds(task.current))
        current -= 1
        if current == 0 {
            showCongratulationAnimation()
            timer.invalidate()
        }
        self.model.allTasks[section].lists[row].current = CMTimeMakeWithSeconds(Float64(current), preferredTimescale: 600)
        NSLog("Fire date: \(sender.fireDate.description)")
        NSLog("Current: \(task.current)")
        DispatchQueue.main.async {
            if let index = self.selectedIndex {
                self.taskCollectionView.reloadItems(at: [index])
            }
        }
        
    }
}

extension TodayViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.model.allTasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.allTasks[section].lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.TaskViewCellIdentifier, for: indexPath) as! TaskView
        
        let section = indexPath.section
        cell.task = self.model.allTasks[section].lists[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Utility.TaskViewHeaderIdentifier, for: indexPath) as! TaskHeaderView
        let section = indexPath.section
        header.text = allTasks[section].category
        return header
    }
}

extension TodayViewController {
    struct SizeRatio {
        static let infoViewHeightRatio:CGFloat = 0.10
        static let infoBtnWidthRatio: CGFloat = 0.20
        static let searchBarWidthRatio: CGFloat = 0.60
        static let settingBtnWidthRatio: CGFloat = 0.20
    }
    
    //    private var statusBarHeight: CGFloat {
    //        return UIApplication.shared.statusBarFrame.height
    //    }
    
    private var infoViewHeight: CGFloat {
        let navigationVC = UINavigationController(rootViewController: self)
        let height = navigationVC.navigationBar.frame.height
        return height
    }
    private var infoBtnWidth: CGFloat {
        return self.infoTopView.frame.width * SizeRatio.infoBtnWidthRatio
    }
    private var searchBarWidth: CGFloat {
        return self.infoTopView.frame.width * SizeRatio.searchBarWidthRatio
    }
    private var settingBtnWidth: CGFloat {
        return self.infoTopView.frame.width * SizeRatio.settingBtnWidthRatio
    }
    
    private var contentViewRect: CGRect {
        let tabbarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        
        
        return CGRect(x: 0, y: infoViewHeight, width: self.view.frame.width, height: self.view.frame.height-infoViewHeight-tabbarHeight)
    }
    
    private var collectionViewItemSize: CGSize {
        let width = self.view.frame.width / 5
        return CGSize(width: width, height: width)
    }
    
    private var collectionViewHeaderSize: CGSize {
        let width = self.view.frame.width
        let height: CGFloat = 60.0
        return CGSize(width: width, height: height)
    }
}

