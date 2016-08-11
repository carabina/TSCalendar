//
//  TSDateTool.swift
//  TSCalendar
//
//  Created by TaeSu Lee on 2016. 7. 28..
//  Copyright © 2016년 TaeSu Lee. All rights reserved.
//

import UIKit

public class TSDateTool: NSObject {

    public class func year(date date: NSDate) -> Int
    {
        return NSCalendar.currentCalendar().component(.Year, fromDate: date)
    }
    
    public class func month(date date: NSDate) -> Int
    {
        return NSCalendar.currentCalendar().component(.Month, fromDate: date)
    }
    
    public class func day(date date: NSDate) -> Int
    {
        return NSCalendar.currentCalendar().component(.Day, fromDate: date)
    }
    
    public class func weekday(date date: NSDate) -> Int
    {
        return NSCalendar.currentCalendar().component(.Weekday, fromDate: date)
    }
    
    public class func weekOfYear(date date: NSDate) -> Int
    {
        return NSCalendar.currentCalendar().component(.WeekOfYear, fromDate: date)
    }
    
    public class func hour(date date: NSDate) -> Int
    {
        return NSCalendar.currentCalendar().component(.Hour, fromDate: date)
    }
    
    public class func miniute(date date: NSDate) -> Int
    {
        return NSCalendar.currentCalendar().component(.Minute, fromDate: date)
    }
    
    public class func second(date date: NSDate) -> Int
    {
        return NSCalendar.currentCalendar().component(.Second, fromDate: date)
    }
    
    public class func numberOfRowsInMonth(month month: NSDate) -> Int
    {
        return 6
    }
    
    public class func dateByIgnoringTimeComponent(date date: NSDate) -> NSDate
    {
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
        components.hour = 0
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    public class func beginingOfMonth(date date: NSDate) -> NSDate
    {
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
        components.day = 1
        components.hour = 0
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    public class func endOfMonth(date date: NSDate) -> NSDate
    {
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
        components.month += 1
        components.day = 0
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    public class func date(year year: Int, month: Int, day: Int) -> NSDate
    {
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 0
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    public class func dateByAdding(months months: Int, toDate date: NSDate) -> NSDate
    {
        let components = NSDateComponents()
        components.month = months
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))!
    }
    
    public class func dateByAdding(days days: Int, toDate date: NSDate) -> NSDate
    {
        let components = NSDateComponents()
        components.day = days
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))!
    }
    
    public class func dateBySubstracting(days days: Int, fromDate date: NSDate) -> NSDate
    {
        return dateByAdding(days: -days, toDate: date)
    }
    
    public class func numberOfHeadPlaceholders(month month: NSDate) -> Int
    {
        let currentWeekday = weekday(date: month)
        let number = (currentWeekday - firstWeekday() + 7) % 7
        return number
    }
    
    public class func months(fromDate fromDate: NSDate, toDate: NSDate) -> Int
    {
        let components = NSCalendar.currentCalendar().components(.Month,
                                                                 fromDate: fromDate,
                                                                 toDate: toDate,
                                                                 options: NSCalendarOptions(rawValue: 0))
        return components.month
    }
    
    public class func days(fromDate fromDate: NSDate, toDate: NSDate) -> Int
    {
        let components = NSCalendar.currentCalendar().components(.Day,
                                                                 fromDate: fromDate,
                                                                 toDate: toDate,
                                                                 options: NSCalendarOptions(rawValue: 0))
        return components.day
    }
    
    public class func isSame(date1 date1: NSDate, date2: NSDate, calendarUnit unit: TSCalendarUnit) -> Bool
    {
        switch unit {
        case .Month:
            return year(date: date1) == year(date: date2) &&
                month(date: date1) == month(date: date2)
        case .Week:
            return year(date: date1) == year(date: date2) &&
                weekOfYear(date: date1) == weekOfYear(date: date2)
        case .Day:
            return year(date: date1) == year(date: date2) &&
                month(date: date1) == month(date: date2) &&
                day(date: date1) == day(date: date2)
        }
    }
    
    public class func isDateInToday(date date: NSDate) ->Bool
    {
        return TSDateTool.isSame(date1: date, date2: NSDate(), calendarUnit: .Day)
    }
    
    // MARK: - Label
    /**
     *  "일 월 화 수 목 금 토" 레벨 구하는 함수
     */
    public class func weekdaySymbols() -> [String] {
        let calendar = NSCalendar.currentCalendar()
        var weekdays = calendar.veryShortWeekdaySymbols
        if firstWeekday() == 2   //시작이 월요일이면
        {
            weekdays.append(weekdays.removeFirst())
        }
        return weekdays
    }
    
    /**
     *   한주의 시작이 1: 일요일 , 2: 월요일
     */
    private class func firstWeekday() ->  Int {
        var firstWeekday: Int = 1
//        switch NSUserDefaults.firstWeekday() {
//        case String(WCalendarFirstWeekday.Sunday):
//            firstWeekday = 1
//            break
//        case String(WCalendarFirstWeekday.Monday):
//            firstWeekday = 2
//            break
//        default:
            firstWeekday = NSCalendar.currentCalendar().firstWeekday
//            break
//        }
        
        return firstWeekday
    }
}
