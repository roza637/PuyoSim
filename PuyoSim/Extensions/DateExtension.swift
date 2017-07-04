//
//  DateExtension.swift
//  PuyoSim
//
//  Created by roza on 2016/10/04.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation

extension String {
    
    func date(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.date(from: self)
    }
    
}

extension Date {
    
    //時間部分を除いた日付のみで同値比較する
    func isSameDate(date: Date) -> Bool {
        return self.string(format: "yyyyMMdd") == date.string(format: "yyyyMMdd")
    }

    //時間部分を除いた日付のみのDateを返却する
    var date: Date {
        //HACK: 他に方法があれば変更したほうがよさそう
        return self.string(format: "yyyyMMdd").date(format: "yyyyMMdd")!
    }
    
    //当月一日取得
    var firstDayOfMonth: Date {
        return self.setDay(1)
    }
    
    //当月末日取得
    var lastDayOfMonth: Date {
        return self.firstDayOfMonth.addMonth(1).addDay(-1)
    }

    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: self)
    }
    
    func addHour(_ hour: Int) -> Date {
        return self.add(component: .hour, value: hour)
    }
    
    func addDay(_ day: Int) -> Date {
        return self.add(component: .day, value: day)
    }
    
    func addMonth(_ month: Int) -> Date {
        return self.add(component: .month, value: month)
    }
    
    func addYear(_ year: Int) -> Date {
        return self.add(component: .year, value: year)
    }
    
    func add(component: Calendar.Component, value: Int) -> Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return calendar.date(byAdding: component, value: value, to: self)!
    }
    
    func setDay(_ day: Int) -> Date {
        return self.set(component: .day, value: day)
    }
    
    func set(component: Calendar.Component, value: Int) -> Date {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        components.setValue(value, for: component)
        return calendar.date(from: components)!
    }
    
    func enumeration(days: Int) -> [Date] {
        return (0 ..< days).map{ self.addDay($0) }
    }
}
