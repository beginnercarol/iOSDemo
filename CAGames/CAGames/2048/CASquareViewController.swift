//
//  CASquareViewController.swift
//  CAGames
//
//  Created by Carol on 2019/4/26.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import SnapKit

class CASquareViewController: UIViewController {
    var dimension: Int = 4
    
    private var controllerView: UIView!
    
    private var tilesView: UIStackView!
    
    private var stackviews: [UIStackView] = []
    
    private var foreGroundTiles: [Int: ForeGroundTileView] = [:]
    
    private var tilesMatrix: [TileView] = []
    
    private var needsToBeRemoved: [ForeGroundTileView] = []
    
    private var gameModel: GameModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        gameModel = GameModel(dimension: dimension)
//        setupGame(withModel: gameModel)
        gameStart()
    }
    
    func setupView() {
        controllerView = UIView(frame: self.view.frame)
        self.view.addSubview(controllerView)
        controllerView.translatesAutoresizingMaskIntoConstraints = false
        controllerView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        controllerView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        controllerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        controllerView.heightAnchor.constraint(equalToConstant: controllerViewHeight).isActive = true
        
        tilesView = UIStackView()
        tilesView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tilesView)
        tilesView.alignment = .center
        tilesView.distribution = .fillEqually
        tilesView.axis = .vertical
        tilesView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading).inset(-viewLayoutMargin.left)
            make.trailing.equalTo(view.snp.trailing).inset(-viewLayoutMargin.right)
            make.height.equalTo(tilesView.snp.width)
            make.top.equalTo(self.controllerView.snp.bottom)
        }
    
        setupStackViews()
        
        let recognizers = createGestureRecognizer(withDirections: [.up, .down, .left, .right])
        for cog in recognizers {
            tilesView.addGestureRecognizer(cog)
        }
    }
    
    func createGestureRecognizer(withDirections direction: [UISwipeGestureRecognizer.Direction]) -> [UIGestureRecognizer] {
        var recognizers: [UIGestureRecognizer] = []
        for dir in direction {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeTiles(_:)))
            swipeGesture.numberOfTouchesRequired = 1
            swipeGesture.direction = dir
            recognizers.append(swipeGesture)
        }
        return recognizers
    }
    
    func setupStackViews() {
        for row in 0 ..< dimension {
            let stackview = UIStackView()
            tilesView.addArrangedSubview(stackview)
            stackview.snp.makeConstraints { (make) in
                make.leading.equalTo(self.tilesView.snp.leading)
                make.trailing.equalTo(self.tilesView.snp.trailing)
            }
            stackview.axis = .horizontal
            stackview.distribution = .fillEqually
            stackview.alignment = .center
            stackview.spacing = tilesSpacing
            for col in 0 ..< dimension {
                let tile = TileView()
                stackview.addArrangedSubview(tile)
                tilesMatrix.append(tile)
                tile.snp.makeConstraints { (make) in
                    make.height.equalTo(tile.snp.width)
                }
                tile.backgroundColor = UIColor.yellow
            }
            stackviews.append(stackview)
        }
    }
    
    func updateTilesValue(withMatrix matrix: Matrix) {
        for row in 0 ..< matrix.getDimension() {
            let stackview = stackviews[row]
            let arrangedSubview = stackview.arrangedSubviews
            for col in 0 ..< matrix.getDimension() {
//                (arrangedSubview[col] as? TileView)?.valueForTile = matrix[(row, col)]
            }
        }
    }
    
    func setupGame(withModel model: GameModel) {
        model.clearAll()
        updateTilesValue(withMatrix: model.matrix)
    }
    
    func gameStart() {
        gameModel.clearAll()
        addNewRandomTile(animated: true)
        addNewRandomTile(animated: true)
//        updateTilesValue(withMatrix: gameModel.matrix)
    }
    
    @objc func swipeTiles(_ sender: UISwipeGestureRecognizer) {
        var actions: [MoveAction] = []
        switch sender.direction {
        case .up:
            let command = UpMoveCommand()
            actions = gameModel.perform(move: command)
        case .down:
            let command = DownMoveCommand()
            actions = gameModel.perform(move: command)
        case .left:
            let command = LeftMoveCommand()
            actions = gameModel.perform(move: command)
        case .right:
            let command = RightMoveCommand()
            actions = gameModel.perform(move: command)
        default:
            fatalError()
            break
        }
        self.move(withActions: actions)
    }
    
    func performMoveActions(withActions actions: [MoveAction]) {
        updateTilesValue(withMatrix: gameModel.matrix)
        let maxVal = gameModel.matrix.max
        
        var newTileValue = Int.random(in: 1...2)
        
        gameModel.insertTileRandomly(with: newTileValue*2)
        updateTilesValue(withMatrix: gameModel.matrix)
    }
    
    func move(withActions actions: [MoveAction]) {
        if actions.count == 0 {
            if gameModel.isUserLose() {
                
            }
            return
        }
        // <0 仅仅是移动
        actions.filter({ $0.val < 0 }).forEach({ moveTile(from: gameModel.coordinateToIndex($0.src), to: gameModel.coordinateToIndex($0.target))})
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        actions.filter({ $0.val > 0 }).forEach({ addNewTile(at: gameModel.coordinateToIndex($0.target), withVal: $0.val) })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.20) {
            self.removeViewsNeededToBeRemoved()
            self.addNewRandomTile(animated: true)
        }
    }
    
    func moveTile(from idx1: Int, to idx2: Int) {
        guard let tileFrom = foreGroundTiles[idx1] else {
            assertionFailure()
            return
        }
        
        let trgTilePath = tilesMatrix[idx2]
        
        tileFrom.snp.remakeConstraints { (make) in
            make.edges.equalTo(trgTilePath)
        }
        
        foreGroundTiles[idx1] = nil
        if let oldView = foreGroundTiles[idx2] {
            needsToBeRemoved.append(oldView)
        }
        
        foreGroundTiles[idx2] = tileFrom
    }
    
    func addNewTile(at idx: Int, withVal val: Int) {
        let tile = createNewTile(withVal: val)
        tile.valueForTile = val
        
        if let oldView = foreGroundTiles[idx] {
            needsToBeRemoved.append(oldView)
        }
        
        // 新生成的格子要加入到 foreGroundTiles 中
        foreGroundTiles[idx] = tile
//        self.view.addSubview(tile)
        let trgTilePath = tilesMatrix[idx]
        
        // 移动格子
        tile.snp.makeConstraints { (make) in
            make.edges.equalTo(trgTilePath)
        }

        
        UIView.animate(withDuration: 0.1, delay: 0.05, animations: {
            // 先d放大 1.2
            tile.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            // 再变回原来大小
            UIView.animate(withDuration: 0.05, animations: {
                tile.transform = .identity
            })
        }
    }
    
    func addNewRandomTile(animated: Bool = false) {
        let val = gameModel.getValueForInsert()
        let pos = gameModel.insertTileRandomly(with: val)
        let tile = createNewTile(withVal: val)
        if pos<0 {
            return
        }
        foreGroundTiles[pos] = tile
        let placeholder = tilesMatrix[pos]
        tile.snp.makeConstraints { (make) in
            make.edges.equalTo(placeholder)
        }
        
        if animated {
            // 初始是 0.2 倍大小, 通过动画恢复原来大小
            tile.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            UIView.animate(withDuration: 0.25) {
                tile.transform = .identity
            }
        }
    }
    
    func createNewTile(withVal val: Int) -> ForeGroundTileView {
        let tile = ForeGroundTileView()
        tile.valueForTile = val
        view.addSubview(tile)
        return tile
    }
    
    
    func removeViewsNeededToBeRemoved() {
        for view in needsToBeRemoved {
            view.removeFromSuperview()
        }
        needsToBeRemoved.removeAll()
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

extension CASquareViewController {
    struct SizeRatio {
        static let controllerViewHeightRatio: CGFloat = 0.30
        static let tilesViewHeightRatio: CGFloat = 0.70
    }
    
    private var controllerViewHeight: CGFloat {
        return SizeRatio.controllerViewHeightRatio * self.view.bounds.height
    }
    
    private var tilesViewHeightWidth: CGFloat {
        let guide = self.view.layoutMargins
        let contentSize = self.view.frame.offset(byInset: guide)
        let width = contentSize.width
        return min(SizeRatio.tilesViewHeightRatio * self.view.bounds.height, width)
    }
    
    private var tilesSpacing: CGFloat {
        return 8
    }
    
    private var tileHeightWidth: CGFloat {
        return (tilesViewHeightWidth - CGFloat(dimension-1)*tilesSpacing)/CGFloat(dimension)
    }
    
    private var tileSize: CGSize {
        return CGSize(width: tileHeightWidth, height: tileHeightWidth)
    }
    
    private var stackviewHeight: Int {
        return Int(tilesViewHeightWidth) / dimension
    }
    
    private var viewLayoutMargin: UIEdgeInsets {
        return self.view.layoutMargins
    }
}

extension CGRect {
    func offset(byInset inset: UIEdgeInsets) -> CGRect {
        let (top, left, bottom, right) = (inset.top, inset.left, inset.bottom, inset.right)
        return CGRect(x: self.minX-left, y: self.minY-top, width: self.width - left - right, height: self.height - top - bottom)
    }
}
