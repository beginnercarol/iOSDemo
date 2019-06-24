//
//  EmojiArtViewController.swift
//  CS193P
//
//  Created by Carol on 2019/1/19.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit
import SnapKit

class EmojiArtViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource {
    var emojis = "🍿🍷🎾🤽‍♀️🍢🍘🍭🍫⛵️⚓️💺🛀🍳🐶🐱🐭🐒🦅🐛🌽🧀🥐🍯🍱🍛🎂🍻🍺🥛🍪🍩".map { String($0) }
    
    var addEmoji = false
    
    var imageFetcher: ImageFetcher!
    var imageURL: URL?

    lazy var dropView: EmojiArtView! = {
        let dropView = EmojiArtView(frame: view.frame)
            view.addSubview(dropView)
        dropView.backgroundColor = UIColor.white
        dropView.translatesAutoresizingMaskIntoConstraints = false
        dropView.leadingAnchor.constraint(equalTo: sideTableVC.tableView.trailingAnchor).isActive = true
        dropView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        dropView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor).isActive = true
        dropView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        dropView.addInteraction(UIDropInteraction(delegate: self))
//        dropView.delegate = self
        return dropView
    }()
    
    var scrollView: UIScrollView {
        get {
            return dropView.emojiScrollView
        }
        set {
            dropView.emojiScrollView = newValue
        }
    }
    
    private var _emojiArtBackgroundImageURL: URL?
    
    var emojiArtBackgroudImage: (url: URL?, image: UIImage?) {
        get {
            return (_emojiArtBackgroundImageURL, dropView.backgroundImage)
        }
        set {
            _emojiArtBackgroundImageURL = newValue.url
            scrollView.zoomScale = 1.0 // currently scaled
            dropView.backgroundImage = newValue.image
            let size = newValue.image?.size ?? CGSize.zero
            dropView.frame = CGRect(origin: dropView.frame.origin, size: size)
            scrollView.contentSize = size
            if size.width>0, size.height>0 {
                scrollView.zoomScale = max(dropView.bounds.width / size.width, dropView.bounds.height / size.height)
            }
        }
    }
    
    @objc func toggleTableView( ) {
        switch self.sideTableState {
        case .show:
            UIView.animate(withDuration: 2) {
                self.sideTableLeadingConstrait.constant = -self.tableViewWidth
                self.sideTableState = .hidden
            }
        case .hidden:
            UIView.animate(withDuration: 2) {
                self.sideTableLeadingConstrait.constant = 0
                self.sideTableState = .show
            }
        }
    }
    
    var sideTableLeadingConstrait: NSLayoutConstraint!
    
    lazy var sideTableVC: EmojiArtDocumentTableViewController! = {
        let sideTableVC = EmojiArtDocumentTableViewController()
        self.addChild(sideTableVC)
        self.view.addSubview(sideTableVC.tableView)
        sideTableLeadingConstrait = sideTableVC.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0)
        sideTableVC.tableView.translatesAutoresizingMaskIntoConstraints = false
        sideTableLeadingConstrait.isActive = true
        sideTableVC.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        sideTableVC.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        sideTableVC.tableView.widthAnchor.constraint(equalToConstant: tableViewWidth).isActive = true
        return sideTableVC
    }()
    
    enum SideViewState {
        case show
        case hidden
    }
    
    private var sideTableState = SideViewState.show
    
    
    lazy var emojiCollectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = collectionItemSize
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: sideTableVC.tableView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        return collectionView
    }()
    
    private var documentObserver: NSObjectProtocol?
    
    func addObservers() {
        documentObserver = NotificationCenter.default.addObserver(
            forName: UIDocument.stateChangedNotification,
            object: document,
            queue: OperationQueue.main,
            using: { notification in
                print("document state changed to \(self.document!.documentState)")
            }
        )
    }
    
    func removeObservers() {
        if let observer = documentObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: CollectionViewCellIdentifier)
        emojiCollectionView.register(EmojiHeaderCell.self, forCellWithReuseIdentifier: CollectionAddCellIdentifier)
        emojiCollectionView.register(PlaceholderCell.self, forCellWithReuseIdentifier: CollectionViewPlaceholderIdentifier)
        emojiCollectionView.register(TextFieldCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewTextFieldIdentifier)
        self.addChild(sideTableVC)
        self.view.addSubview(sideTableVC.tableView)
        view.addSubview(dropView)
        let sideShowTableSwipe = UISwipeGestureRecognizer(target: self, action: #selector(toggleTableView))
        sideShowTableSwipe.numberOfTouchesRequired = 2
        sideShowTableSwipe.direction = .right
        let sideHiddenTableSwipe = UISwipeGestureRecognizer(target: self, action: #selector(toggleTableView))
        sideHiddenTableSwipe.numberOfTouchesRequired = 2
        sideHiddenTableSwipe.direction = .left
        view.addGestureRecognizer(sideShowTableSwipe)
        view.addGestureRecognizer(sideHiddenTableSwipe)
        let saveButton = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(save(_:)))
        let closeButton = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(close(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.leftBarButtonItem = closeButton
        setupDocument()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    func setupDocument() {
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("untitled.json") {
            document = EmojiArtDocument(fileURL: url)
        }
    }
    
    var document: EmojiArtDocument? 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
        document?.open { success in
            if success {
                self.title = self.document?.localizedName
                self.emojiArt = self.document?.emojiArt
            }
        }
    }

    @objc func save(_ sender: UIBarButtonItem) {
        document?.emojiArt = emojiArt
        if document?.emojiArt != nil {
            document?.updateChangeCount(.done)
        }
    }
    
    func documentChanged() {
        document?.emojiArt = emojiArt
        if document?.emojiArt != nil {
            document?.updateChangeCount(.done)
        }
    }
    
    @objc func close(_ sender: UIBarButtonItem) {
        save(sender) // if saving is automatically tracked no need to call save()
        dismiss(animated: true) {
            self.document?.close() { success in
                if let observer = self.documentObserver {
                    NotificationCenter.default.removeObserver(observer)
                }
            }
        }
        
    }
    
    // MARK: - Model
    var emojiArt: EmojiArt? {
        get {
            if let url = emojiArtBackgroudImage.url {
                let emojis = dropView.subviews.compactMap { $0 as? UILabel }.compactMap { EmojiArt.EmojiInfo(label: $0) }
                return EmojiArt(url: url, emojis: emojis)
            }
            return nil
        }
        set {
            emojiArtBackgroudImage = (nil, nil)
            dropView.subviews.flatMap { $0 as? UILabel}.forEach { $0.removeFromSuperview() }
            if let url = newValue?.url {
                 ImageFetcher(url: url) { (url, image) in
                    DispatchQueue.main.async {
                        self.emojiArtBackgroudImage = (url, image)
                        newValue?.emojis.forEach {
                            let fontSize = UIFont.preferredFont(forTextStyle: .body).withSize(CGFloat($0.size))
                            let attributedText = NSAttributedString(string: $0.text, attributes: [NSAttributedString.Key.font: fontSize])
                            self.dropView.addLabel(with: attributedText, centerdAt: CGPoint(x: $0.x, y: $0.y))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - button action
    @objc func addMoreEmoji(_ sender: UIButton) {
        addEmoji = !addEmoji
        emojiCollectionView.reloadSections([0])
        becomeFirstResponder()
    }

    // MARK: - CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("emojis.count: \(emojis.count)")
        switch section {
            case 0:
                return 1
            case 1:
                return emojis.count
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier, for: indexPath) as! EmojiCell
            let font = UIFont.preferredFont(forTextStyle: .body).withSize(emojiFontSize)
            let fontMetric = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            cell.emojiLabel.attributedText = NSAttributedString(string: emojis[indexPath.row], attributes: [NSAttributedString.Key.font: fontMetric, .paragraphStyle: paragraphStyle])
            print("emojis[\(indexPath.row)]: \(emojis[indexPath.row])")
            return cell
        } else if addEmoji {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewTextFieldIdentifier, for: indexPath) as! TextFieldCollectionViewCell
            cell.resignationHandler = { [weak self, unowned cell] in
                if let text =  cell.textField.text {
                    self?.emojis = (text.map { String($0) } + self!.emojis)
                }
                self?.addEmoji = false
                self?.emojiCollectionView.reloadData()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionAddCellIdentifier, for: indexPath) as! EmojiHeaderCell
            cell.addButton.addTarget(self, action: #selector(addMoreEmoji(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    // MARK: - TableView datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier, for: indexPath) as! EmojiTableCell
        cell.textLabel?.text = "hhh"
        cell.accessoryType = .checkmark
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print(#function)
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "default"
    }
}

// MARK: - dropView's dropInteractionDelegate
extension EmojiArtViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return (session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)) || session.canLoadObjects(ofClass: NSString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print(#function)
        imageFetcher = ImageFetcher() { (url, img) in
            DispatchQueue.main.async {
                self.emojiArtBackgroudImage = (url, img)
            }
        }
        session.loadObjects(ofClass: NSURL.self, completion: { nsurls in
            if let url = nsurls.first as? URL {
                self.imageURL = url
                self.imageFetcher.fetch(withURl: url)
            }
        })
        session.loadObjects(ofClass: UIImage.self, completion: { images in
                if let image = images.first as? UIImage {
                    self.imageFetcher.backup = image
                    self.emojiArtBackgroudImage = (self.imageURL, image)
                }
        })
    }
}

extension EmojiArtViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? EmojiTableCell {
            cell.setEditing(!cell.isEditing, animated: true)
            cell.isEditing = !cell.isEditing
        }
        
    }
}


// MARK: - UICollectionView drag delegate
extension EmojiArtViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = emojiCollectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if addEmoji || indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let emojiString = (emojiCollectionView.cellForItem(at: indexPath) as? EmojiCell)?.emojiLabel.attributedText {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: emojiString))
            dragItem.localObject = emojiString
            return [dragItem]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
}


// MARK: - UICollectionView Drop Delegate
extension EmojiArtViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == emojiCollectionView
        return UICollectionViewDropProposal.init(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // update model and collectionView
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 1)
        if destinationIndexPath.section == 0 {
            return
        }
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath { // 如果有 sourceIndexPath 则说明来自自身
                if let attributedString = item.dragItem.localObject as? NSAttributedString {
                    collectionView.performBatchUpdates({
                        emojis.remove(at: sourceIndexPath.item)
                        emojis.insert(attributedString.string, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    }, completion: nil)
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: CollectionViewPlaceholderIdentifier))
                
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) { (provider, error) in
                    
                    DispatchQueue.main.async {
                        if let attributedString = provider as? NSAttributedString {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.emojis.insert(attributedString.string, at: insertionIndexPath.item)
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                        
                    }
                }
            }
        }
    }
}

extension EmojiArtViewController: UICollectionViewDelegate {
    
}

extension EmojiArtViewController {
    private struct SizeRatio {
        static let collectionViewHeightToHeight: CGFloat = 0.15
        static let tableViewWidthToWidth: CGFloat = 0.25
        
    }
    
    private var CollectionViewCellIdentifier: String {
        return "emoji.collection.cell"
    }
    private var CollectionAddCellIdentifier: String {
        return "emoji.collection.cell.add"
    }
    private var CollectionViewPlaceholderIdentifier: String {
        return "emoji.collection.placeholder"
    }
    
    private var CollectionViewTextFieldIdentifier: String {
        return "emoji.collection.textField"
    }

    private var TableViewCellIdentifier: String {
        return "emoji.table.cell"
    }
    

    private var collectionViewHeight: CGFloat {
        return self.view.bounds.height * SizeRatio.collectionViewHeightToHeight + 10
    }
    
    private var collectionItemSize: CGSize {
        return CGSize(width: collectionViewHeight-10, height: collectionViewHeight-10)
    }
    
    private var tableViewWidth: CGFloat {
        return self.view.bounds.width * SizeRatio.tableViewWidthToWidth
    }
    
    private var emojiFontSize: CGFloat {
        return collectionItemSize.height * 0.80
    }
}

extension EmojiArtViewController: EmojiArtViewDelegate {
    func emojiArtViewDidChange(_ sender: EmojiArtView) {
        documentChanged()
    }
}


extension EmojiArt.EmojiInfo {
    init?(label: UILabel) {
        if let attributedText = label.attributedText {
            x = Int(label.center.x)
            y = Int(label.center.y)
            text = attributedText.string
            size = Int(attributedText.size().height)
        } else {
            return nil
        }
    }
}
