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
    public enum DateFormats: String {
        
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
        public func date(_ dateString: String) -> Date? {
            assert(!self.rawValue.hasPrefix("nature"), "nature string can not transform into date")
            _initFormatter(fmt: self)
            return DateFormats._formatter.date(from: dateString)
        }
        /// get formate string from date
        public func string(_ date: Date?, _ placeholder: String = "--") -> String {
            guard let date = date else {
                return placeholder
            }
            if self.rawValue.hasPrefix("nature") {
                let components = self.rawValue.components(separatedBy: " @")
                return DateFormats._getNature(date, components)
            } else {
                _initFormatter(fmt: self)
                return DateFormats._formatter.string(from: date)
            }
        }
        
        /// init static formatter
        private func _initFormatter(fmt: DateFormats) {
            let formatter = DateFormats._formatter
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
            let one = DateFormatter()
            one.calendar = Calendar(identifier: .gregorian)
            one.dateFormat = DateFormats.standard24.rawValue
            return one
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
    
    /// 格式化类
    public static let Formats = DateFormats.self
    
    // segs
    public let year: Int
    public let month: Int
    public let day: Int
    public let hour: Int
    public let minute: Int
    public let second: Int
    
    /// judge exist of year, month and day segs, true if any of them is zero
    public var isTimeMode: Bool {
        let dateExist = year != 0 && month != 0 && day != 0
        return !dateExist
    }
    
    public func string(_ fmt: DateFormats, _ placeholder: String = "--") -> String {
        return fmt.string(nsDate, placeholder)
    }
    
    /// Date
    public var nsDate: Date {
        if let date = _initNSDate {
            return date
        }
        return DateFormats.segments.date(segmentFormateString)!
    }
    
    /// date formate string
    public var segmentFormateString: String {
        return "\(year) \(month) \(day) \(hour) \(minute) \(second)"
    }
    
    /// CustomStringConvertible
    public var description: String {
        return "[QXDate] " + DateFormats.segments.string(nsDate)
    }
    
    /// init with year, month and day
    public init(year: Int, month: Int, day: Int) {
        self.init(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
    }
    /// init with hour, minute and second
    public init(hour: Int, minute: Int, second: Int) {
        self.init(year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 0)
    }
    /// init with Date
    public init(_ nsDate: Date) {
        let dateStr = DateFormats.segments.string(nsDate)
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


