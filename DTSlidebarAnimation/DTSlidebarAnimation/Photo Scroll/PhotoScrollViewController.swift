//
//  PhotoScrollViewController.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/15.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class PhotoScrollViewController: UIViewController {
    var imageName: [String] = ["photo1", "photo2", "photo3", "photo4", "photo5"]
    
    lazy var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()
    
    var detailVC = PhotoDetailViewController()
    
    var descriptionVC = PhotoDescriptionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.directionalLayoutMargins.leading)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(view.directionalLayoutMargins.trailing)
            make.height.equalTo(100)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoScrollCollectionViewCell.self, forCellWithReuseIdentifier: "photoscroll.collectionview.cell")
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

extension PhotoScrollViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let img = UIImage(named: imageName[row])
//        detailVC.setupImage(withImage: img!)
        descriptionVC.setupImage(withImage: img!)
            self.navigationController?.pushViewController(descriptionVC, animated: false)
    }
}

extension PhotoScrollViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoscroll.collectionview.cell", for: indexPath) as! PhotoScrollCollectionViewCell
        let row = indexPath.row
        cell.imageView.image = UIImage(named: imageName[row])
        return cell
    }
}
