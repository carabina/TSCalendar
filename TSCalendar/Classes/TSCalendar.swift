//
//  TSCalendar.swift
//  TSCalendar
//
//  Created by TaeSu Lee on 2016. 7. 25..
//  Copyright © 2016년 TaeSu Lee. All rights reserved.
//

import UIKit

@objc protocol TSCalendarDelegate: NSObjectProtocol {
    
    optional func minimumDateForCalendar(calendar: TSCalendar) -> NSDate
    optional func maximumDateForCalendar(calendar: TSCalendar) -> NSDate
    
    optional func calendar(calendar calendar: TSCalendar, didSelectTitle: NSDate)
    optional func calendar(calendar calendar: TSCalendar, didSelectDate: NSDate)
}

public enum TSCalendarUnit {
    case Month
    case Week
    case Day
}

@IBDesignable
class TSCalendar: UIView {
    
    weak var delegate: TSCalendarDelegate?
    
    let appearance = TSCalendarAppearance()
    
    var allowsMultipleSelection: Bool = false
    var minimumDate: NSDate = TSDateTool.date(year: 2016, month: 1, day: 1)
    var maximumDate: NSDate = TSDateTool.date(year: 2016, month: 12, day: 31)
    weak var collectionView: TSCalendarCollectionView!
    
    private weak var contentView: UIView!
    private weak var titleHeader: UIView!
    private weak var lblHeaderTitle: UILabel!
    private weak var btnToday: UIButton!
    private weak var weekdayHeader: TSCalendarWeekdayHeader!
    private weak var daysContainer: UIView!
    
    private var needsAdjustingMonthPosition: Bool = true
    
    private var currentPage: NSDate = TSDateTool.beginingOfMonth(date: NSDate())
    private var selectedDates: [NSDate] = []
    
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
        
        let titleHeader = UIView(frame: CGRectZero)
        titleHeader.backgroundColor = UIColor.clearColor()
        contentView.addSubview(titleHeader)
        self.titleHeader = titleHeader
        
        let lblHeaderTitle = UILabel(frame: CGRectZero)
        lblHeaderTitle.backgroundColor = UIColor.clearColor()
        lblHeaderTitle.textColor = UIColor.redColor()
        lblHeaderTitle.font = UIFont.boldSystemFontOfSize(15)
        lblHeaderTitle.textAlignment = .Center
        titleHeader.addSubview(lblHeaderTitle)
        self.lblHeaderTitle = lblHeaderTitle
        
        let btnToday = UIButton(type: .Custom)
        btnToday.setTitle("오늘", forState: .Normal)
        btnToday.setTitleColor(UIColor.blueColor(), forState: .Normal)
        btnToday.addTarget(self, action: #selector(TSCalendar.touchUpInsideToday(_:)), forControlEvents: .TouchUpInside)
        contentView.addSubview(btnToday)
        self.btnToday = btnToday
        
        let weekdayHeader = TSCalendarWeekdayHeader(frame: CGRectZero)
        contentView.addSubview(weekdayHeader)
        self.weekdayHeader = weekdayHeader
        
        let daysContainer = UIView(frame: CGRectZero)
        daysContainer.backgroundColor = UIColor.clearColor()
        daysContainer.clipsToBounds = true
        contentView.addSubview(daysContainer)
        self.daysContainer = daysContainer
        
        let collectionViewLayout = TSCalendarFlowLayout()
        
        let collectionView = TSCalendarCollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.bounces = true
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        
        collectionView.registerClass(TSCalendarCell.classForCoder(), forCellWithReuseIdentifier: "TSCalendarCell")
        daysContainer.addSubview(collectionView)
        self.collectionView = collectionView
        
        currentPageDidChange()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(self.bounds)
        contentView.frame = self.bounds
        titleHeader.frame = CGRect(x: 0, y: 0, width: ts_width, height: 40)
        lblHeaderTitle.frame = titleHeader.bounds
        btnToday.frame = CGRect(x: ts_width-50, y: 0, width: 50, height: titleHeader.ts_height)
        weekdayHeader.frame = CGRect(x: 0, y: titleHeader.ts_bottom, width: ts_width, height: 20)
        daysContainer.frame = CGRect(x: 0, y: weekdayHeader.ts_bottom, width: ts_width, height: ts_height-weekdayHeader.ts_bottom)
        collectionView.frame = daysContainer.bounds
        
        if needsAdjustingMonthPosition {
            needsAdjustingMonthPosition = false
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            scroll(toPage: currentPage, animated: false)
            CATransaction.commit()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TSCalendar: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return TSDateTool.months(fromDate: minimumDate, toDate: maximumDate) + 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TSCalendarCell", forIndexPath: indexPath) as! TSCalendarCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: TSCalendarCell, atIndexPath indexPath: NSIndexPath) {
        let firstPage = TSDateTool.beginingOfMonth(date: minimumDate)
        let month = TSDateTool.dateByAdding(months: indexPath.section, toDate: firstPage)
        cell.month = month
        cell.date = date(forIndexPath: indexPath)
        cell.dateIsSelected = selectedDates.contains(cell.date!)
        cell.dateIsToday = TSDateTool.isDateInToday(date: cell.date!)
        cell.dateIsPlaceholder = !TSDateTool.isSame(date1: cell.date!, date2: cell.month!, calendarUnit: .Month)
        
        cell.layoutSubviews()
    }
}

// MARK: - UICollecionViewDelegate
extension TSCalendar: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TSCalendarCell
        cell.dateIsSelected = true
        cell.performSelecting()
        didSelectDate(date: cell.date)
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TSCalendarCell
        if isDataSelected(date: cell.date) {
            return false
        }
        
        if !allowsMultipleSelection && selectedDates.last != nil {
            deselectDate(date: selectedDates.last)
        }
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

// MARK: - UIScrollViewDelegate
extension TSCalendar: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var targetOffset: CGFloat = 0, contentSize: CGFloat = 0
        
        targetOffset = targetContentOffset.memory.y
        contentSize = scrollView.ts_height
        
        let minimumPage = TSDateTool.beginingOfMonth(date: minimumDate)
        let targetPage: NSDate = TSDateTool.dateByAdding(months: Int(targetOffset/contentSize), toDate: minimumPage)
        
        let shouldTriggerPageChange = isDateInDifferentPage(date1: targetPage)
        if shouldTriggerPageChange {
            currentPage = targetPage
            currentPageDidChange()
        }
    }
}

// MARK: - Help
extension TSCalendar {
    
    private func scroll(toDate date: NSDate, animated: Bool) {
//        let targetDate = TSDateTool.daysFromDate(fromDate: minimumDate, toDate: date)
        let scrollOffset = TSDateTool.months(fromDate: TSDateTool.beginingOfMonth(date: minimumDate), toDate: date)
        collectionView.setContentOffset(CGPointMake(0, CGFloat(scrollOffset) * collectionView.ts_height), animated: animated)
        currentPageDidChange()
    }
    
    private func scroll(toPage date: NSDate, animated: Bool) {
        scroll(toDate: date, animated: animated)
    }
    
    private func date(forIndexPath indexPath: NSIndexPath) -> NSDate {
        let currentPage = TSDateTool.dateByAdding(months: indexPath.section, toDate: TSDateTool.beginingOfMonth(date: minimumDate))
        let numberOfHeadPlaceholders = TSDateTool.numberOfHeadPlaceholders(month: currentPage)
        let firstDateOfPage = TSDateTool.dateBySubstracting(days: numberOfHeadPlaceholders, fromDate: currentPage)
        let rows: Int = indexPath.item / 7
        let columns: Int = indexPath.item % 7
        let daysOffset = 7*rows + columns
        return TSDateTool.dateByAdding(days: daysOffset, toDate: firstDateOfPage)
    }
    
    private func indexPath(forDate date: NSDate) -> NSIndexPath {
        var item = 0
        var section = 0
        
        section = TSDateTool.months(fromDate: TSDateTool.beginingOfMonth(date: minimumDate), toDate: date)
        let firstDayOfMonth = TSDateTool.beginingOfMonth(date: date)
        let numberOfHeadPlaceholders = TSDateTool.numberOfHeadPlaceholders(month: firstDayOfMonth)
        let firstDateOfPage = TSDateTool.dateBySubstracting(days: numberOfHeadPlaceholders, fromDate: firstDayOfMonth)
        item = TSDateTool.days(fromDate: firstDateOfPage, toDate: date)
        
        return NSIndexPath(forItem: item, inSection: section)
    }
    
    private func titleForDate(date date: NSDate) {
        
    }
    
    private func currentPageDidChange() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = appearance.headerDateFormat
        lblHeaderTitle.text = formatter.stringFromDate(currentPage)
    }
    
    private func isDataSelected(date dateOrNil: NSDate?) -> Bool {
        guard let date = dateOrNil else {return false}
        return selectedDates.contains(date)
    }
    
    private func isDateInDifferentPage(date1 date: NSDate) -> Bool {
        return !TSDateTool.isSame(date1: date, date2: currentPage, calendarUnit: .Month)
    }
    
    private func enqueueSelectedDate(date date: NSDate) {
        if allowsMultipleSelection {
            selectedDates.removeAll()
        }
        if !selectedDates.contains(date) {
            selectedDates.append(date)
        }
    }
}

// MARK: - Action
extension TSCalendar {
    func touchUpInsideToday(sender: UIButton) {
        select(date: NSDate(), animated: true)
    }
}

// MARK: - Delegate
extension TSCalendar {
    func didSelectDate(date dateOrNil: NSDate?) {
        guard let date = dateOrNil else {return}
        enqueueSelectedDate(date: date)
        delegate?.calendar?(calendar: self, didSelectDate: date)
    }
}

// MARK: - Public
extension TSCalendar {
    
    func select(date date: NSDate) {
        select(date: date, animated: false)
    }
    
    func select(date date: NSDate, animated: Bool) {
        currentPage = TSDateTool.beginingOfMonth(date: date)
        scroll(toPage: currentPage, animated: animated)
    }
    
    func deselectDate(date dateOrNil: NSDate?) {
        guard let date = dateOrNil else {return}
        let dateIngoringTime = TSDateTool.dateByIgnoringTimeComponent(date: date)
        if !selectedDates.contains(dateIngoringTime) {return}
        for (index, selectedDate) in selectedDates.enumerate() {
            if date == selectedDate {
                selectedDates.removeAtIndex(index)
            }
        }
        let atIndexPath = indexPath(forDate: date)
        let cell = collectionView.cellForItemAtIndexPath(atIndexPath) as! TSCalendarCell
        cell.dateIsSelected = false
        cell.setNeedsLayout()
    }
}
