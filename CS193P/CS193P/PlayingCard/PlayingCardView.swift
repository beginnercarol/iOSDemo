//
//  PlayingCardView.swift
//  CS193P
//
//  Created by Carol on 2019/1/9.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {
    var card: PlayingCard! {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.clearsContextBeforeDrawing = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.yellow.setFill()
        path.fill()
        drawPatterns()
    }
    
    func centeredAttributedString(_ string: String, fontSize size: CGFloat) -> NSAttributedString {
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(size)
        let fontMetric = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: fontMetric, .paragraphStyle: paragraphStyle])
    }
    
    // MARK: - draw
    func drawPatterns() {
        if card.isFaceUp {
            let pipRect = bounds.insetBy(dx: cornerInset, dy: cornerInset)
            let ranks = PlayingCard.CardRank.allItems.map(){ $0.rawValue}
            let rank = card.rank!.rawValue
            let maxRanks = ranks.max()!
            let increaseWidth = pipRect.width/CGFloat(maxRanks)
            let midRect = CGRect(x: pipRect.minX+increaseWidth, y: pipRect.minY, width: increaseWidth, height: pipRect.height)
            let leftRect = CGRect(x: pipRect.minX, y: pipRect.minY, width: increaseWidth, height: pipRect.height)
            let rightRect = CGRect(x: pipRect.minX + increaseWidth*2, y: pipRect.minY, width: increaseWidth, height: pipRect.height)
            switch rank {
            case 1:
                drawRect(inRect: midRect)
            case 2:
                drawRect(inRect: pipRect.leftHalf)
                drawRect(inRect: pipRect.rightHalf)
            case 3:
                drawRect(inRect: leftRect)
                drawRect(inRect: midRect)
                drawRect(inRect: rightRect)
            default: break
            }
        }
    }
    
    private func drawRect(inRect rect: CGRect) {
        let insetWidth = rect.width*SizeRatio.pipRectOriginInsetToBoundsWidth
        let rect = rect.insetBy(dx: insetWidth, dy: insetWidth)
        var path: UIBezierPath!
        let color = card.color!.value
        let shading = card.shading!
        switch card.symbol! {
        case .spade:
            path = UIBezierPath(rect: rect)
        case .diamond:
            path = UIBezierPath()
            var point = CGPoint(x: rect.midX, y: rect.minY)
            path.move(to: point)
            point = CGPoint(x: rect.minX, y: rect.midY)
            path.addLine(to: point)
            point = CGPoint(x: rect.midX, y: rect.maxY)
            path.addLine(to: point)
            point = CGPoint(x: rect.maxX, y: rect.midY)
            path.addLine(to: point)
            point = CGPoint(x: rect.midX, y: rect.minY)
            path.addLine(to: point)
            path.close()
        case .heart:
            path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: min(rect.width/2, rect.height/2), startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        }
        switch shading {
        case .open:
            color.setStroke()
            path.stroke()
        case .stripped:
            let topColor = color
            let buttomColor = UIColor.clear
            let gradientColors = [topColor.cgColor, buttomColor.cgColor, topColor.cgColor, buttomColor.cgColor, topColor.cgColor]
            let gradientLocations: [NSNumber] = [0.0, 0.33, 0.66, 0.99, 1.0]
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = gradientColors
            gradientLayer.locations = gradientLocations
            gradientLayer.frame = rect
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            self.layer.addSublayer(gradientLayer)
        case .shading:
            color.setFill()
            path.fill()
        }
    }
}



extension PlayingCardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.085
        static let cornerFontToBoundsHeight: CGFloat = 0.065
        static let cornerOffsetToBoundHeight: CGFloat = 0.15
        static let pipRectOriginInsetToBoundsWidth: CGFloat = 0.085
    }
    
    private var cornerRadius: CGFloat { return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight }
    private var cornerFont: CGFloat { return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight }
    private var cornerInset: CGFloat { return bounds.size.width * SizeRatio.cornerOffsetToBoundHeight }
    private var pipOriginXInset: CGFloat { return bounds.size.width * SizeRatio.pipRectOriginInsetToBoundsWidth }
    
}

extension CGRect {
    func insetBy(dx: CGFloat, dy: CGFloat) -> CGRect {
        return CGRect(x: self.minX+dx, y: self.minY+dy, width: self.width-2*dx, height: self.height-2*dy)
    }
    
    var leftHalf: CGRect {
        return CGRect(x: self.minX, y: self.minY, width: self.width/2, height: self.height)
    }
    
    var rightHalf: CGRect {
        return CGRect(x: self.minX + self.width/2, y: self.minY, width: self.width/2, height: self.height)
    }
}
