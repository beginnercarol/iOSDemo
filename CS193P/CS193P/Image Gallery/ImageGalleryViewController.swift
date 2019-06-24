//
//  ImageGalleryViewController.swift
//  CS193P
//
//  Created by Carol on 2019/3/9.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit
import SnapKit

class ImageGalleryViewController: UIViewController {
    var emojis = "🍿🍷🎾🤽‍♀️🍢🍘🍭🍫⛵️⚓️💺🛀🍳🐶🐱🐭🐒🦅🐛🌽🧀🥐🍯🍱🍛🎂🍻🍺🥛🍪🍩".map { String($0) }
    
    var imageGalleryDocument: ImageGalleryDocument?
    var imageGallery: ImageGalleryDoc? {
        set {
            if let url = newValue?.url {
                ImageGalleryFetcher(url: url) { (url, img) in
                    DispatchQueue.main.async {
                        self.imageGalleryBackgroundImage = (img, url)
                        newValue?.labels.forEach({
                            self.imageDropView.addLabel(withAttributedString: Utility.attributedString(from: $0.text, size: $0.size.height), at: $0.center)
                        })
                    }
                }
            }
        }
        get {
            if let url = imageGalleryBackgroundImage.url {
                let labels = imageDropView.subviews.compactMap { $0 as? UILabel}.compactMap({ ImageGalleryLabel(withLabel: $0) })
                return ImageGalleryDoc(withLabels: labels, url: url)
            } else {
                return nil
            }
        }
    }
    var imageGalleryFetcher: ImageGalleryFetcher!
    lazy var sideTable: SideTableViewController = {
        let table = SideTableViewController()
        table.imgDocument = ["1","2","3"]
        return table
    }()
    
    
    private var isAdding = false
    
    lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CollectionViewItemSize
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(ImageGalleryCollectionViewCell.self, forCellWithReuseIdentifier: Utility.Identifier.CollectionViewCellIdentifier)
        collectionView.register(ImageAddCollectionViewCell.self, forCellWithReuseIdentifier: Utility.Identifier.CollectionViewAddIdentifier)
        collectionView.register(ImageInputCollectionViewCell.self, forCellWithReuseIdentifier: Utility.Identifier.CollectionViewInputIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    var imageDropView: ImageGalleryDropView = ImageGalleryDropView()
    private var _imageGalleryBackgroudImageURL: URL?
    var imageGalleryBackgroundImage: (img: UIImage, url: URL?) {
        set {
            imageDropView.backgroundImage = newValue.img
            _imageGalleryBackgroudImageURL = newValue.url
        }
        get {
            return (imageDropView.backgroundImage! ,_imageGalleryBackgroudImageURL)
        }
    }
    
    private var sideTableView: UIView {
        get {
            return sideTable.tableView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(sideTable)
        view.addSubview(sideTableView)
        sideTable.addNewFileHandler = {[weak self] (fileName) in
            if self?.imageGalleryDocument != nil {
                self?.saveFile()
                if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(fileName) {
                    self?.imageGalleryDocument = ImageGalleryDocument(fileURL: url)
                    self?.sideTable.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
            }
        }
        view.addSubview(emojiCollectionView)
        view.addSubview(imageDropView)
//        let hideSideTableGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(toggleSideTable(_:)))
//        hideSideTableGestureRecognizer.numberOfTouchesRequired = 2
//        hideSideTableGestureRecognizer.direction = .left
//        view.addGestureRecognizer(hideSideTableGestureRecognizer)
//        let showSideTableGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(toggleSideTable(_:)))
//        showSideTableGestureRecognizer.numberOfTouchesRequired = 2
//        showSideTableGestureRecognizer.direction = .right
//        view.addGestureRecognizer(showSideTableGestureRecognizer)
        setupView()
    }
    
    func setupView() {
        sideTableView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        sideTableView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp.leading)
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.width.equalTo(TableWidth)
        }
        emojiCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalTo(sideTableView.snp.trailing)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(CollectionViewHeight)
        }
        imageDropView.snp.makeConstraints { (make) in
            make.top.equalTo(self.emojiCollectionView.snp.bottom)
            make.leading.equalTo(sideTableView.snp.trailing)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
    @objc func toggleSideTable(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            sideTableView.snp.makeConstraints { (make) in
                make.trailing.equalTo(self.view.snp.leading).priority(1000)
            }
        case .right:
            sideTableView.snp.makeConstraints { (make) in
                make.leading.equalTo(self.view.snp.leading).priority(1000)
            }
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    func setupDocument() {
//        if imageGalleryDocument == nil {
//            if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
//                imageGalleryDocument = ImageGalleryDocument(fileURL: url)
//            }
//        }
//    }
    
    
    func saveFile() {
//        imageGalleryDocument
        imageGalleryDocument?.imageGallery = imageGallery
        if imageGalleryDocument?.imageGallery != nil {
            imageGalleryDocument?.updateChangeCount(.done)
        }
    }
    
    func initNewImageGallery() {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageGalleryDocument?.open(completionHandler: { [weak self](success) in
            if success {
                self?.imageGallery = self?.imageGalleryDocument?.imageGallery
            }
        })
    }
}

extension ImageGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return emojis.count
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let inputCell = cell as? ImageInputCollectionViewCell {
                inputCell.emojiTextField.becomeFirstResponder()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if isAdding {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.Identifier.CollectionViewInputIdentifier, for: indexPath) as! ImageInputCollectionViewCell
                cell.resignationHandler = { [weak self, unowned cell] in
                    if let text = cell.emojiTextField.text {
                        self?.emojis = text.map { String($0) } + (self?.emojis ?? [])
                    }
                    collectionView.reloadData()
                    self?.isAdding = false
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.Identifier.CollectionViewAddIdentifier, for: indexPath) as! ImageAddCollectionViewCell
                cell.resignationHandler = {[weak self] in
                    self?.isAdding = true
                    collectionView.reloadSections(IndexSet(integer: 0))
                }
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.Identifier.CollectionViewCellIdentifier, for: indexPath) as! ImageGalleryCollectionViewCell
            cell.image = emojis[indexPath.row]
            return cell
        }
    }
}

extension ImageGalleryViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) || session.canLoadObjects(ofClass: UIImage.self)
    }
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        imageGalleryFetcher = ImageGalleryFetcher(handler: {(url, img) in
            DispatchQueue.main.async {
                self.imageGalleryBackgroundImage = (img, url)
            }
        })
        session.loadObjects(ofClass: NSURL.self) {[weak self] (nsurls) in
            if let url = nsurls.first as? URL {
                self?._imageGalleryBackgroudImageURL = url
                self?.imageGalleryFetcher.fetch(withURL: url)
            }
        }
        session.loadObjects(ofClass: UIImage.self) { (imgs) in
            if let img = imgs.first as? UIImage {
                self.imageGalleryFetcher.backupImage = img
                self.imageGalleryBackgroundImage = (img, self._imageGalleryBackgroudImageURL)
            }
        }
    }
}

extension ImageGalleryViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = emojiCollectionView
        return dragItem(at: indexPath)
    }
    
    private func dragItem(at indexPath: IndexPath) -> [UIDragItem] {
        if let imgString = (emojiCollectionView.cellForItem(at: indexPath) as? ImageGalleryCollectionViewCell)?.imageLabel.attributedText {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: imgString))
            dragItem.localObject = imgString
            return [dragItem]
        } else {
            return []
        }
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if isAdding || indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
}

extension ImageGalleryViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == emojiCollectionView
        if isSelf {
            return UICollectionViewDropProposal(operation: .move)
        } else {
            return UICollectionViewDropProposal(operation: .copy)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndex = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndex = item.sourceIndexPath {
                if let attributedString = item.dragItem.localObject as? NSAttributedString {
                    collectionView.performBatchUpdates({
                        emojis.remove(at: sourceIndex.row)
                        emojis.insert(attributedString.string, at: destinationIndex.row)
                        collectionView.deleteItems(at: [sourceIndex])
                        collectionView.insertItems(at: [destinationIndex])
                    }, completion: nil)
                }
            } else {
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let attributedString = provider as? NSAttributedString {
                            collectionView.performBatchUpdates({
                                self.emojis.insert(attributedString.string, at: destinationIndex.row)
                                collectionView.insertItems(at: [destinationIndex])
                            }, completion: nil)
                        }
                    }
                }
            }
        }
    }
}

extension ImageGalleryViewController {
    struct SizeRatio {
        static let TableWidthToView: CGFloat = 0.30
        static let CollectionViewHeight: CGFloat = 0.20
        
    }
    
    private var TableWidth: CGFloat {
        return view.bounds.width * SizeRatio.TableWidthToView
    }
    private var CollectionViewHeight: CGFloat {
        return view.bounds.height * SizeRatio.CollectionViewHeight
    }
    
    private var CollectionViewItemSize: CGSize {
        return CGSize(width: CollectionViewHeight, height: CollectionViewHeight)
    }

}


