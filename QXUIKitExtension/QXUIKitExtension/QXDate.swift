//
//  QXDate.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/27.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation

extension QXDate {
    
    /// support date formats
    public enum Formats: String {
        
        // standard 24
        case standard24 =           "yyyy-MM-dd HH:mm:ss"
        case standard_date =        "yyyy-MM-dd"
        case standard24_time =      "HH:mm:ss"
        case standard24_hourMinute = "HH:mm"
        case standard24_dateHourMinute = "yyyy-MM-dd HH:mm"
        
        case standard12 =           "yyyy-MM-dd aa hh:mm:ss @AM @PM"
        case standard12_time =      "aa hh:mm:ss @AM @PM"
        case standard12_hourMinute = "aa hh:mm @AM @PM"
        
        // slash
        case slash24 =              "yyyy/MM/dd HH:mm:ss"
        case slash_date =           "yyyy/MM/dd"
        case slash12 =              "yyyy/MM/dd aa hh:mm:ss @AM @PM"
        
        // dot
        case dot24 =              "yyyy.MM.dd HH:mm:ss"
        case dot_date =           "yyyy.MM.dd"
        case dot12 =              "yyyy.MM.dd aa hh:mm:ss @AM @PM"
        
        // chinese
        case chinse24 =             "yyyy年MM月dd日 HH时mm分ss秒"
        case chinse_date =          "yyyy年MM月dd日"
        case chinse_monthDay =          "MM月dd日"
        
        case chinse24_hourMinute =  "HH时mm分"
        case chinse24_time =        "HH时mm分ss秒"
        case chinse12 =             "yyyy年MM月dd日 aa hh时mm分ss秒 @上午 @下午"
        case chinse12_hourMinute =  "hh时mm分 @上午 @下午"
        case chinse12_time =        "aa hh时mm分ss秒 @上午 @下午"
        
        // segments
        case segments =             "yyyy MM dd HH mm ss"
        
        // nature
        case nature_chinese =       "nature @刚刚... @分钟前 @分钟后 @小时前 @小时后 @昨天 @明天 @前天 @后天 @天前 @天后 @周前 @周后 @月前 @月后 @年前 @年后"
        case nature_english =       "nature @just now @ minutes ago @ minutes later @ hours ago @ hours later @yesterday @tomorrow @the day before yesterday @the day after tomorrow @ days ago @ days later @ weeks ago @ weeks later @ months ago @ months later @ years ago @ years later"
        
        /// get date from formate string
        public func nsDate(_ dateString: String) -> Date? {
            assert(!self.rawValue.hasPrefix("nature"), "nature string can not transform into date")
            _initFormatter(fmt: self)
            return Formats._formatter.date(from: dateString)
        }
        /// get formate string from date
        public func string(_ nsDate: Date?, _ placeholder: String = "--") -> String {
            guard let date = nsDate else {
                return placeholder
            }
            if self.rawValue.hasPrefix("nature") {
                let components = self.rawValue.components(separatedBy: " @")
                return Formats._getNature(date, components)
            } else {
                _initFormatter(fmt: self)
                return Formats._formatter.string(from: date)
            }
        }
        
        /// get date from formate string
        public func date(_ dateString: String) -> QXDate? {
            if let e = nsDate(dateString) {
                return QXDate(e)
            }
            return nil
        }
        /// get formate string from date
        public func string(_ date: QXDate?, _ placeholder: String = "--") -> String {
            return string(date?.nsDate, placeholder)
        }
        
        /// init static formatter
        private func _initFormatter(fmt: Formats) {
            let formatter = Formats._formatter
            let components = fmt.rawValue.components(separatedBy: " @")
            if components.count >= 3 {
                formatter.dateFormat = components[0]
                formatter.amSymbol = components[1]
                formatter.pmSymbol = components[2]
            } else {
                formatter.dateFormat = fmt.rawValue
            }
        }
        
        /// static formatter for use
        private static var _formatter: DateFormatter = {
            let e = DateFormatter()
            e.calendar = Calendar(identifier: .gregorian)
            e.dateFormat = Formats.standard24.rawValue
            return e
        }()
        
        /// make nature date string
        static func _getNature(_ date: Date, _ components: [String]) -> String {
            
            let justNow = components[1]
            let minutesAgo = components[2]
            let minutesLater = components[3]
            let hoursAgo = components[4]
            let hoursLater = components[5]
            let yesterday = components[6]
            let tomorrow = components[7]
            let dayBeforeYesterday = components[8]
            let dayLaterTomorrow = components[9]
            let daysAgo = components[10]
            let daysLater = components[11]
            let weeksAgo = components[12]
            let weeksLater = components[13]
            let monthsAgo = components[14]
            let monthsLater = components[15]
            let yearsAgo = components[16]
            let yearsLater = components[17]
            
            let seconds: Int = Int(date.timeIntervalSince1970 - Date().timeIntervalSince1970)
            // 60 minutes
            if (abs(seconds / 3600) < 1) {
                let minutes = seconds / 60
                if abs(minutes) <= 0 {
                    return justNow
                } else {
                    if minutes > 0 {
                        return "\(minutes)" + minutesLater
                    } else {
                        return "\(-minutes)" + minutesAgo
                    }
                }
            }
                // 1-24 hour
            else if abs(seconds / 86400) < 1 {
                let hours = seconds / 3600
                if hours > 0 {
                    return "\(hours)" + hoursLater
                } else {
                    return "\(-hours)" + hoursAgo
                }
            }
                // more than one day
            else {
                let days = seconds / 86400
                if abs(days) <= 1 {
                    if days > 0 {
                        return tomorrow
                    } else {
                        return yesterday
                    }
                } else if abs(days) == 2 {
                    if days > 0 {
                        return dayLaterTomorrow
                    } else {
                        return dayBeforeYesterday
                    }
                } else if abs(days) <= 7 {
                    if days > 0 {
                        return "\(days)" + daysLater
                    } else {
                        return "\(-days)" + daysAgo
                    }
                } else if abs(days) <= 30 {
                    if days > 0 {
                        return "\(days / 7)" + weeksLater
                    } else {
                        return "\(-days / 7)" + weeksAgo
                    }
                } else if abs(days) < 365 {
                    if days > 0 {
                        return "\(days / 30)" + monthsLater
                    } else {
                        return "\(-days / 30)" + monthsAgo
                    }
                } else {
                    if days > 0 {
                        return "\(days / 365)" + yearsLater
                    } else {
                        return "\(-days / 365)" + yearsAgo
                    }
                }
            }
        }
    }
}

public struct QXDate: CustomStringConvertible {
    
    /// now date
    public static var now: QXDate {
        return QXDate(Date())
    }
    
    /// utc -> loc，标准时间转换为当前时间，比如现在在东八区，需要偏移8小时
    public static func localDateFrom(UTC date: Date) -> Date {
        let utc_zone = NSTimeZone(abbreviation: "UTC")!
        let loc_zone = NSTimeZone.local
        let gmt_offset = utc_zone.secondsFromGMT(for: date)
        let loc_offset = loc_zone.secondsFromGMT(for: date)
        let interval = loc_offset - gmt_offset
        return Date(timeInterval: TimeInterval(interval), since: date)
    }
    
    // segs
    public let year: Int
    public let month: Int
    public let day: Int
    public let hour: Int
    public let minute: Int
    public let second: Int
    
    public func string(_ fmt: Formats, _ placeholder: String = "--") -> String {
        return fmt.string(nsDate, placeholder)
    }
    
    /// Date
    public var nsDate: Date {
        if let date = _initNSDate {
            return date
        }
        return Formats.segments.nsDate(segmentFormateString)!
    }
    
    public static let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)

    /// day index in a week, 1 - 7
    public var weekDay: Int {
        var i = QXDate.calendar.component(.weekday, from: nsDate)
        if i == 1 {
            i = 7
        } else {
            i -= 1
        }
        return i
    }
    public var monthDays: Int {
        if month >= 1 && month <= 12 {
            return QXDate.calendar.range(of: .day, in: .month, for: nsDate)!.count
        } else {
            return 28
        }
    }

    public var endpointsOfYear: (start: QXDate, end: QXDate) {
        return (
            QXDate(year: year, month: 1, day: 1, hour: 0, minute: 0, second: 0),
            QXDate(year: year, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        )
    }
    public var endpointsOfMonth: (start: QXDate, end: QXDate) {
        let days = monthDays
        return (
            QXDate(year: year, month: month, day: 1, hour: 0, minute: 0, second: 0),
            QXDate(year: year, month: month, day: days, hour: 23, minute: 59, second: 59)
        )
    }
    public var endpointsOfDay: (start: QXDate, end: QXDate) {
        return (
            QXDate(year: year, month: month, day: day, hour: 0, minute: 0, second: 0),
            QXDate(year: year, month: month, day: day, hour: 23, minute: 59, second: 59)
        )
    }
    public var endpointsOfWeak: (start: QXDate, end: QXDate) {
        let now = QXDate(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
        let day = weekDay
        let a = 60 * 60 * 24 * (TimeInterval(day - 1))
        let b = 60 * 60 * 24 * (7 - TimeInterval(day))
        let start = QXDate(now.nsDate.addingTimeInterval(-a))
        let end = QXDate(now.nsDate.addingTimeInterval(b))
        return (
            QXDate(year: start.year, month: start.month, day: start.day, hour: 0, minute: 0, second: 0),
            QXDate(year: end.year, month: end.month, day: end.day, hour: 23, minute: 59, second: 59)
        )
    }
    
    /// date formate string
    public var segmentFormateString: String {
        return "\(year) \(month) \(day) \(hour) \(minute) \(second)"
    }
    
    /// CustomStringConvertible
    public var description: String {
        return "[QXDate] " + Formats.standard24.string(nsDate)
    }
    
    public init(year: Int, month: Int, day: Int) {
        self.init(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
    }
    public init(year: Int, month: Int) {
        self.init(year: year, month: month, day: 1, hour: 0, minute: 0, second: 0)
    }
    public init(month: Int, day: Int) {
        self.init(year: 1970, month: month, day: day, hour: 0, minute: 0, second: 0)
    }
    public init(year: Int) {
        self.init(year: year, month: 1, day: 1, hour: 0, minute: 0, second: 0)
    }
    public init(month: Int) {
        self.init(year: 1970, month: month, day: 1, hour: 0, minute: 0, second: 0)
    }
    public init(day: Int) {
        self.init(year: 1970, month: 1, day: day, hour: 0, minute: 0, second: 0)
    }
    
    public init(hour: Int, minute: Int, second: Int) {
        self.init(year: 1970, month: 1, day: 1, hour: hour, minute: minute, second: second)
    }
    public init(hour: Int, minute: Int) {
        self.init(year: 1970, month: 1, day: 1, hour: hour, minute: minute, second: 0)
    }
    public init(minute: Int, second: Int) {
        self.init(year: 1970, month: 1, day: 1, hour: 0, minute: minute, second: second)
    }
    public init(hour: Int) {
        self.init(year: 1970, month: 1, day: 1, hour: hour, minute: 0, second: 0)
    }
    public init(minute: Int) {
        self.init(year: 1970, month: 1, day: 1, hour: 0, minute: minute, second: 0)
    }
    public init(second: Int) {
        self.init(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: second)
    }
    
    /// init with Date
    public init(_ nsDate: Date) {
        let dateStr = Formats.segments.string(nsDate)
        let segStrs = dateStr.components(separatedBy: " ")
        assert(segStrs.count >= 6)
        self.init(year:     (segStrs[0] as NSString).integerValue,
                  month:    (segStrs[1] as NSString).integerValue,
                  day:      (segStrs[2] as NSString).integerValue,
                  hour:     (segStrs[3] as NSString).integerValue,
                  minute:   (segStrs[4] as NSString).integerValue,
                  second:   (segStrs[5] as NSString).integerValue)
        self._initNSDate = nsDate
    }
    /// base init
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
    }
    
    /// private
    private var _initNSDate: Date?
    
}


extension QXDate: Comparable, Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.nsDate.timeIntervalSince1970 == rhs.nsDate.timeIntervalSince1970
    }
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.nsDate.timeIntervalSince1970 < rhs.nsDate.timeIntervalSince1970
    }
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs.nsDate.timeIntervalSince1970 <= rhs.nsDate.timeIntervalSince1970
    }
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs.nsDate.timeIntervalSince1970 >= rhs.nsDate.timeIntervalSince1970
    }
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.nsDate.timeIntervalSince1970 > rhs.nsDate.timeIntervalSince1970
    }
}
