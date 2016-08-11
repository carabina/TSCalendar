//
//  TSCalendarWeekdayHeader.swift
//  TheDay
//
//  Created by TaeSu Lee on 2016. 8. 2..
//  Copyright © 2016년 TaeSu Lee. All rights reserved.
//

import UIKit

class TSCalendarWeekdayHeader: UIView {
    
    weak var calendar: TSCalendar?
    
    private var contentView: UIView!
    private var needsAdjustingViewFrame: Bool = true
    
    var weekdayLabels: [UILabel]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        let contentView = UIView(frame: CGRectZero)
        contentView.backgroundColor = UIColor.clearColor()
        addSubview(contentView)
        self.contentView = contentView
        
        var weekdayLabels: [UILabel] = []
        for _ in 0...6 {
            let label = UILabel(frame: CGRectZero)
            label.textAlignment = .Center
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize(12)
            contentView.addSubview(label)
            weekdayLabels.append(label)
        }
        self.weekdayLabels = weekdayLabels
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if needsAdjustingViewFrame {
            needsAdjustingViewFrame = false
            
            contentView.frame = bounds
            let weekdayWidth = ts_width/7
            let weekdayHeight = ts_height
            
            for (index, label) in weekdayLabels.enumerate() {
                label.frame = CGRect(x: CGFloat(index)*weekdayWidth, y: 0, width: weekdayWidth, height: weekdayHeight)
            }
            
            reloadData()
        }
    }
    
    // MARK: - Help
    private func invalidateWeekdaySymbols() {
        let weekdaySymbols = TSDateTool.weekdaySymbols()
        for (index, label) in weekdayLabels.enumerate() {
            label.text = weekdaySymbols[index]
        }
    }
    
    // MARK: - Public
    func reloadData() {
        invalidateWeekdaySymbols()
    }
}
