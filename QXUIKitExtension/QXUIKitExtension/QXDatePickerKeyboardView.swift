//
//  QXDatePickerView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/19.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXYearMonthDayPickerKeyboardView: QXDatePickerBaseKeyboardView {
        
    open override var bringInDate: QXDate? {
        didSet {
            if let e = bringInDate {
                let year = QXPickerView.Item(e.year, "\(e.year)", e.year)
                let month = QXPickerView.Item(e.month, "\(e.month)", e.month)
                let day = QXPickerView.Item(e.day, "\(e.day)", e.day)
                self.bringInPickedItems = [year, month, day]
            }
            super.bringInDate = bringInDate
        }
    }
    public let yearPickerView: QXPickerView
    public let monthPickerView: QXPickerView
    public let dayPickerView: QXPickerView
    public required init(minDate: QXDate, maxDate: QXDate) {
        yearPickerView = QXPickerView()
        yearPickerView.suffixView = {
            let e = QXLabel()
            e.text = "年"
            return e
        }()
        monthPickerView = QXPickerView()
        monthPickerView.suffixView = {
            let e = QXLabel()
            e.text = "月"
            return e
        }()
        dayPickerView = QXPickerView()
        dayPickerView.suffixView = {
            let e = QXLabel()
            e.text = "日"
            return e
        }()
        super.init([yearPickerView, monthPickerView, dayPickerView], isLazyMode: true)
        
        var years: [QXPickerView.Item] = []
        for y in minDate.year...maxDate.year {
            let year = QXPickerView.Item(y, "\(y)", y)
            var months: [QXPickerView.Item] = []
            var m1: Int = 1
            var m2: Int = 12
            if y == minDate.year {
                m1 = minDate.month
            }
            if y == maxDate.year {
                m2 = maxDate.month
            }
            for m in m1...m2 {
                let month = QXPickerView.Item(m, "\(m)", m)
                var days: [QXPickerView.Item] = []
                let date = QXDate(year: y, month: m, day: 1).nsDate
                var d1: Int = 1
                var d2: Int = Calendar.current.range(of: .day, in: .month, for: date)!.count
                if y == minDate.year && m == minDate.month {
                    d1 = minDate.day
                }
                if y == maxDate.year && m == maxDate.month {
                    d2 = maxDate.day
                }
                for d in d1...d2 {
                    let day = QXPickerView.Item(d, "\(d)", d)
                    days.append(day)
                }
                month.children = days
                months.append(month)
            }
            year.children = months
            years.append(year)
        }
        items = years
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ pickerViews: [QXPickerView], isLazyMode: Bool) {
        fatalError("init(_:) has not been implemented")
    }
    
}

open class QXYearMonthPickerKeyboardView: QXDatePickerBaseKeyboardView {
        
    open override var bringInDate: QXDate? {
        didSet {
            if let e = bringInDate {
                let year = QXPickerView.Item(e.year, "\(e.year)", e.year)
                let month = QXPickerView.Item(e.month, "\(e.month)", e.month)
                self.bringInPickedItems = [year, month]
            }
            super.bringInDate = bringInDate
        }
    }
    public let yearPickerView: QXPickerView
    public let monthPickerView: QXPickerView
    public required init(minDate: QXDate, maxDate: QXDate) {
        yearPickerView = QXPickerView()
        yearPickerView.suffixView = {
            let e = QXLabel()
            e.text = "年"
            return e
        }()
        monthPickerView = QXPickerView()
        monthPickerView.suffixView = {
            let e = QXLabel()
            e.text = "月"
            return e
        }()
        super.init([yearPickerView, monthPickerView], isLazyMode: true)
        
        var years: [QXPickerView.Item] = []
        for y in minDate.year...maxDate.year {
            let year = QXPickerView.Item(y, "\(y)", y)
            var months: [QXPickerView.Item] = []
            var m1: Int = 1
            var m2: Int = 12
            if y == minDate.year {
                m1 = minDate.month
            }
            if y == maxDate.year {
                m2 = maxDate.month
            }
            for m in m1...m2 {
                let month = QXPickerView.Item(m, "\(m)", m)
                months.append(month)
            }
            year.children = months
            years.append(year)
        }
        items = years
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ pickerViews: [QXPickerView], isLazyMode: Bool) {
        fatalError("init(_:) has not been implemented")
    }
}

open class QXMonthDayPickerKeyboardView: QXDatePickerBaseKeyboardView {
        
    open override var bringInDate: QXDate? {
        didSet {
            if let e = bringInDate {
                let month = QXPickerView.Item(e.month, "\(e.month)", e.month)
                let day = QXPickerView.Item(e.day, "\(e.day)", e.day)
                self.bringInPickedItems = [month, day]
            }
            super.bringInDate = bringInDate
        }
    }
    public let monthPickerView: QXPickerView
    public let dayPickerView: QXPickerView
    public required init(minDate: QXDate, maxDate: QXDate) {
        monthPickerView = QXPickerView()
        monthPickerView.suffixView = {
            let e = QXLabel()
            e.text = "月"
            return e
        }()
        dayPickerView = QXPickerView()
        dayPickerView.suffixView = {
            let e = QXLabel()
            e.text = "日"
            return e
        }()
        super.init([monthPickerView, dayPickerView], isLazyMode: true)
        
        var months: [QXPickerView.Item] = []
        for m in minDate.month...maxDate.month {
            let month = QXPickerView.Item(m, "\(m)", m)
            var days: [QXPickerView.Item] = []
            let date = QXDate(month: m, day: 1).nsDate
            var d1: Int = 1
            var d2: Int = Calendar.current.range(of: .day, in: .month, for: date)!.count
            if m == minDate.month {
                d1 = minDate.day
            }
            if m == maxDate.month {
                d2 = maxDate.day
            }
            for d in d1...d2 {
                let day = QXPickerView.Item(d, "\(d)", d)
                days.append(day)
            }
            month.children = days
            months.append(month)
        }
        items = months
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ pickerViews: [QXPickerView], isLazyMode: Bool) {
        fatalError("init(_:) has not been implemented")
    }
    
}

open class QXHourMinuteSecondPickerKeyboardView: QXDatePickerBaseKeyboardView {
        
    open override var bringInDate: QXDate? {
        didSet {
            if let e = bringInDate {
                let hour = QXPickerView.Item(e.hour, "\(e.hour)", e.hour)
                let minute = QXPickerView.Item(e.minute, "\(e.minute)", e.minute)
                let second = QXPickerView.Item(e.second, "\(e.second)", e.second)
                self.bringInPickedItems = [hour, minute, second]
            }
            super.bringInDate = bringInDate
        }
    }
    public let hourPickerView: QXPickerView
    public let minutePickerView: QXPickerView
    public let secondPickerView: QXPickerView
    public required init(minDate: QXDate, maxDate: QXDate) {
        hourPickerView = QXPickerView()
        hourPickerView.suffixView = {
            let e = QXLabel()
            e.text = "时"
            return e
        }()
        minutePickerView = QXPickerView()
        minutePickerView.suffixView = {
            let e = QXLabel()
            e.text = "分"
            return e
        }()
        secondPickerView = QXPickerView()
        secondPickerView.suffixView = {
            let e = QXLabel()
            e.text = "秒"
            return e
        }()
        super.init([hourPickerView, minutePickerView, secondPickerView], isLazyMode: true)
        
        var hours: [QXPickerView.Item] = []
        for h in minDate.hour...maxDate.hour {
            let hour = QXPickerView.Item(h, "\(h)", h)
            var minutes: [QXPickerView.Item] = []
            var m1: Int = 0
            var m2: Int = 59
            if h == minDate.hour {
                m1 = minDate.minute
            }
            if h == maxDate.hour {
                m2 = maxDate.minute
            }
            for m in m1...m2 {
                let minute = QXPickerView.Item(m, "\(m)", m)
                var seconds: [QXPickerView.Item] = []
                var s1: Int = 0
                var s2: Int = 59
                if h == minDate.hour && m == minDate.minute {
                    s1 = minDate.second
                }
                if h == maxDate.hour && m == maxDate.minute {
                    s2 = maxDate.second
                }
                for s in s1...s2 {
                    let second = QXPickerView.Item(s, "\(s)", s)
                    seconds.append(second)
                }
                minute.children = seconds
                minutes.append(minute)
            }
            hour.children = minutes
            hours.append(hour)
        }
        items = hours
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ pickerViews: [QXPickerView], isLazyMode: Bool) {
        fatalError("init(_:) has not been implemented")
    }
    
}

open class QXYearPickerKeyboardView: QXDatePickerBaseKeyboardView {
    open override var bringInDate: QXDate? {
        didSet {
            if let e = bringInDate {
                let item = QXPickerView.Item(e.year, "\(e.year)", e)
                self.bringInPickedItems = [item]
            }
            super.bringInDate = bringInDate
        }
    }
    public let pickerView: QXPickerView
    public required init(minDate: QXDate, maxDate: QXDate) {
        pickerView = QXPickerView()
        pickerView.suffixView = {
            let e = QXLabel()
            e.text = "年"
            return e
        }()
        pickerView.fixWidth = 120
        super.init([pickerView], isLazyMode: true)
        items = (minDate.year...maxDate.year).map { (year) -> QXPickerView.Item in
            return QXPickerView.Item(year, "\(year)", QXDate(year: year))
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ pickerViews: [QXPickerView], isLazyMode: Bool) {
        fatalError("init(_:) has not been implemented")
    }
}

open class QXMonthPickerKeyboardView: QXDatePickerBaseKeyboardView {
    open override var bringInDate: QXDate? {
        didSet {
            if let e = bringInDate {
                let item = QXPickerView.Item(e.month, "\(e.month)", e)
                self.bringInPickedItems = [item]
            }
            super.bringInDate = bringInDate
        }
    }
    public let pickerView: QXPickerView
    public required init(minDate: QXDate, maxDate: QXDate) {
        pickerView = QXPickerView()
        pickerView.suffixView = {
            let e = QXLabel()
            e.text = "月"
            return e
        }()
        pickerView.fixWidth = 120
        super.init([pickerView], isLazyMode: true)
        items = (minDate.month...maxDate.month).map { (month) -> QXPickerView.Item in
            return QXPickerView.Item(month, "\(month)", QXDate(month: month))
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ pickerViews: [QXPickerView], isLazyMode: Bool) {
        fatalError("init(_:) has not been implemented")
    }
}

open class QXDayPickerKeyboardView: QXDatePickerBaseKeyboardView {
    open override var bringInDate: QXDate? {
        didSet {
            if let e = bringInDate {
                let item = QXPickerView.Item(e.day, "\(e.day)", e)
                self.bringInPickedItems = [item]
            }
            super.bringInDate = bringInDate
        }
    }
    public let pickerView: QXPickerView
    public required init(minDate: QXDate, maxDate: QXDate) {
        pickerView = QXPickerView()
        pickerView.suffixView = {
            let e = QXLabel()
            e.text = "日"
            return e
        }()
        pickerView.fixWidth = 120
        super.init([pickerView], isLazyMode: true)
        items = (minDate.day...maxDate.day).map { (day) -> QXPickerView.Item in
            return QXPickerView.Item(day, "\(day)", QXDate(day: day))
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ pickerViews: [QXPickerView], isLazyMode: Bool) {
        fatalError("init(_:) has not been implemented")
    }
}

open class QXHourPickerKeyboardView: QXDatePickerBaseKeyboardView {
    open override var bringInDate: QXDate? {
        didSet {
            if let e = bringInDate {
                let item = QXPickerView.Item(e.hour, "\(e.hour)", e)
                self.bringInPickedItems = [item]
            }
            super.bringInDate = bringInDate
        }
    }
    public let pickerView: QXPickerView
    public required init(minDate: QXDate, maxDate: QXDate) {
        pickerView = QXPickerView()
        pickerView.suffixView = {
            let e = QXLabel()
            e.text = "时"
            return e
        }()
        pickerView.fixWidth = 120
        super.init([pickerView], isLazyMode: true)
        items = (minDate.hour...maxDate.hour).map { (hour) -> QXPickerView.Item in
            return QXPickerView.Item(hour, "\(hour)", QXDate(hour: hour))
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ pickerViews: [QXPickerView], isLazyMode: Bool) {
        fatalError("init(_:) has not been implemented")
    }
}

open class QXMinutePickerKeyboardView: QXDatePickerBaseKeyboardView {
    open override var bringInDate: QXDate? {
        didSet {
            if let e = bringInDate {
                let item = QXPickerView.Item(e.minute, "\(e.minute)", e)
                self.bringInPickedItems = [item]
            }
            super.bringInDate = bringInDate
        }
    }
    public let pickerView: QXPickerView
    public required init(minDate: QXDate, maxDate: QXDate) {
        pickerView = QXPickerView()
        pickerView.suffixView = {
            let e = QXLabel()
            e.text = "分"
            return e
        }()
        pickerView.fixWidth = 120
        super.init([pickerView], isLazyMode: true)
        items = (minDate.minute...maxDate.minute).map { (minute) -> QXPickerView.Item in
            return QXPickerView.Item(minute, "\(minute)", QXDate(minute: minute))
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ pickerViews: [QXPickerView], isLazyMode: Bool) {
        fatalError("init(_:) has not been implemented")
    }
}

open class QXSecondPickerKeyboardView: QXDatePickerBaseKeyboardView {
    open override var bringInDate: QXDate? {
        didSet {
            if let e = bringInDate {
                let item = QXPickerView.Item(e.second, "\(e.second)", e)
                self.bringInPickedItems = [item]
            }
            super.bringInDate = bringInDate
        }
    }
    public let pickerView: QXPickerView
    public required init(minDate: QXDate, maxDate: QXDate) {
        pickerView = QXPickerView()
        pickerView.suffixView = {
            let e = QXLabel()
            e.text = "秒"
            return e
        }()
        pickerView.fixWidth = 120
        super.init([pickerView], isLazyMode: true)
        items = (minDate.second...maxDate.second).map { (second) -> QXPickerView.Item in
            return QXPickerView.Item(second, "\(second)", QXDate(second: second))
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ pickerViews: [QXPickerView], isLazyMode: Bool) {
        fatalError("init(_:) has not been implemented")
    }
}

open class QXDatePickerBaseKeyboardView: QXPickerKeyboardView {
    open var bringInDate: QXDate?
}
