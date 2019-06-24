//
//  EmojiCollectionViewCollectionViewController.swift
//  CS193P
//
//  Created by Carol on 2019/1/21.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class EmojiCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

}


