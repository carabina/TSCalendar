//
//  TSCalendarCell.swift
//  TSCalendar
//
//  Created by TaeSu Lee on 2016. 7. 25..
//  Copyright © 2016년 TaeSu Lee. All rights reserved.
//

import UIKit

class TSCalendarCell: UICollectionViewCell {
    
    var lblTitle: UILabel!
    
    var month: NSDate?
    var date: NSDate?
    
    var dateIsPlaceholder: Bool = false
    var dateIsSelected: Bool = false
    var dateIsToday: Bool = false
    
    private weak var shapeLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        
        let diameter = min(ts_height, ts_width)
        
        var label: UILabel!
        
//        label = UILabel(frame: CGRectZero)
        label = UILabel(frame: CGRect(x: 0, y: 0, width: ts_width, height: ts_height))
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        contentView.addSubview(label)
        lblTitle = label
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: (ts_width-diameter)/2, y: (ts_height-diameter)/2, width: diameter, height: diameter)
        shapeLayer.backgroundColor = UIColor.clearColor().CGColor
        shapeLayer.hidden = true
        contentView.layer.insertSublayer(shapeLayer, below: lblTitle.layer)
        self.shapeLayer = shapeLayer
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        month = nil
        date = nil
        lblTitle.text = ""
        CATransaction.setDisableActions(true)
        shapeLayer.hidden = true
        contentView.layer.removeAnimationForKey("opacity")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.hidden = true
        configureCell()
    }
    
    // MARK: - Help
    private func configureCell() {
        
        if dateIsPlaceholder {
            contentView.alpha = 0.3
        } else {
            contentView.alpha = 1
        }
        
        if dateIsToday || dateIsSelected {
            let path: CGPathRef = UIBezierPath(ovalInRect: shapeLayer.bounds).CGPath
            if !CGPathEqualToPath(shapeLayer.path, path) {
                shapeLayer.path = path
            }
            let cellFillColor = UIColor.redColor().CGColor
            if !CGColorEqualToColor(shapeLayer.fillColor, cellFillColor) {
                shapeLayer.fillColor = cellFillColor
            }
            let cellBorderColor = UIColor.blueColor().CGColor
            if !CGColorEqualToColor(shapeLayer.strokeColor, cellBorderColor) {
                shapeLayer.strokeColor = cellBorderColor
            }
            
            shapeLayer.hidden = false
        }
        
        if date != nil {
            lblTitle.text = String(TSDateTool.day(date: date!))
        }
    }
    
    // MARK: - Public
    func performSelecting() {
        
        shapeLayer.hidden = false
        
        let animationDuration = 0.15
        
        let group = CAAnimationGroup()
        let zoomOut = CABasicAnimation(keyPath: "transform.scale")
        zoomOut.fromValue = 0.3
        zoomOut.toValue = 1.2
        zoomOut.duration = animationDuration/4*3
        let zoomIn = CABasicAnimation(keyPath: "transform.scale")
        zoomIn.fromValue = 1.2
        zoomIn.toValue = 1.0
        zoomIn.beginTime = animationDuration/4*3
        zoomIn.duration = animationDuration/4
        group.duration = animationDuration
        group.animations = [zoomOut, zoomIn]
        shapeLayer.addAnimation(group, forKey: "bounce")
        configureCell()
    }
}
