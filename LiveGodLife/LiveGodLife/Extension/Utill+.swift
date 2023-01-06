//
//  Utill+Formatter.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/15.
//

import Foundation

extension Locale {
    static var preferredLocale: Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}

enum Format: String {
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = Locale.preferredLocale.groupingSeparator ?? ","
        formatter.alwaysShowsDecimalSeparator = false
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.preferredLocale
        formatter.timeZone = TimeZone.current
        formatter.calendar = Calendar.current
        return formatter
    }()
    
    case Date = "yyyyMMdd"
    case Time = "HHmmss"
    case Hour = "HHmm"
    case DateAndTime = "yyyy-MM-dd HH:mm:ss"
    case DateAndTime2 = "yyyyMMdd HHmmss"
    case DateAndTime3 = "yyyyMMddHHmmss"
    case DateAndTime4 = "yyyy-MM-dd HH:mm"
    
    case MonthPresent = "yyyy.MM"
    case DatePresent = "yyyy.MM.dd"
    case DateAndMinutesPresent = "yyyy.MM.dd HH:mm"
    case DateAndTimePresent = "yyyy.MM.dd HH:mm:ss"
    
    case OnlyMonthPresent = "MMMM"
    case DayOfWeekPresent = "E"
    case TimeAndMinutesPresent = "HH:mm"
    case Time24AndMinutesPresent = "kkmm"
    
    var formatter: DateFormatter {
        let formatter = Format.dateFormatter.copy() as! DateFormatter
        formatter.dateFormat = self.rawValue
        return formatter
    }
}

extension Date {
    public func toString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
    
    public func toParameterString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
    
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    public var monthName: String {
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM" // format January, February, March, ...
        return nameFormatter.string(from: self)
    }
    
    static var today: String {
        return Format.Date.formatter.string(from: Date())
    }
    
    static var now: String {
        return Format.Time.formatter.string(from: Date())
    }
    
    static func isInTimeBetween(from: Date, to: Date) -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let fromComponent = calendar.dateComponents([.day, .hour, .minute], from: from)
        let toComponent = calendar.dateComponents([.day, .hour, .minute], from: to)
        guard
            let fromDate = calendar.date(bySettingHour: fromComponent.hour ?? 0, minute: fromComponent.minute ?? 0, second: 0, of: date),
            var toDate = calendar.date(bySettingHour: toComponent.hour ?? 0, minute: toComponent.minute ?? 0, second: 0, of: date)
        else {
            return false
        }
        if fromDate >= toDate {
            toDate.addTimeInterval(86400)
        }
        return fromDate < date && date < toDate
    }
    
    var currentTimeMillis: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    var sevenDaysAgo: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .calendar], from: self)
        components.day = components.day! - 7
        return components.date!
    }
    
    var sixMonthAgo: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .calendar], from: self)
        components.month = components.month! - 6
        return components.date!
    }
    
    var anYearAgo: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .calendar], from: self)
        components.day = components.day! + 1    // To avoid error from server-side validation.
        components.year = components.year! - 1
        return components.date!
    }
    
    var aDayAgo: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .calendar], from: self)
        components.day = components.day! - 1    // To avoid error from server-side validation.
        return components.date!
    }
    
    func daysBetween(date: Date) -> Int? {
        let calendar = Calendar.current
        guard
            let date1 = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self),
            let date2 = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date)
        else {
            return nil
        }
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day
    }
    
    func yearsBetween(date: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date, to: self)
        return components.year
    }
    
    var dateString: String {
        return Format.Date.formatter.string(from: self)
    }
    
    var dateAndTime4: String {
        return Format.DateAndTime4.formatter.string(from: self)
    }
    
    var dateRepresent: String {
        return Format.DatePresent.formatter.string(from: self)
    }
    
    var dateAndTimeRepresent: String {
        return Format.DateAndTimePresent.formatter.string(from: self)
    }
    
    var dateAndMinutesRepresent: String {
        return Format.DateAndMinutesPresent.formatter.string(from: self)
    }
    
    var hourRepresent: String {
        return Format.TimeAndMinutesPresent.formatter.string(from: self)
    }
    
    var hour24Represent: String {
        return Format.Time24AndMinutesPresent.formatter.string(from: self)
    }
    
    var monthRepresent: String {
        return Format.MonthPresent.formatter.string(from: self)
    }
    
    var onlyMonthRepresent: String {
        return Format.OnlyMonthPresent.formatter.string(from: self)
    }
    
    var dayOfWeek: String {
        return Format.DayOfWeekPresent.formatter.string(from: self)
    }
}

extension String {
    // .... cause of too many formats
    var date: Date? {
        return Format.DateAndTime.formatter.date(from: self) ??
            Format.DateAndTime2.formatter.date(from: self) ??
            Format.DateAndTime3.formatter.date(from: self) ??
            Format.DatePresent.formatter.date(from: self) ??
            Format.Date.formatter.date(from: self) ??
            Format.Time.formatter.date(from: self) ??
            Format.Hour.formatter.date(from: self) ?? nil
    }
    
    var intValue: Int? {
        return Int(self)
    }
    
    var doubleValue: Double? {
        return Double(self)
    }
    
    var literValue: Double? {
        guard let self = self.doubleValue else { return nil }
        return Double(self / 1_000)
    }
    
    func separate(every stride: Int = 4, with separator: Character = "-") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    var formattedCreditCardNumber: String {
        if self.lengthOfBytes(using: .utf16) == 30 {
            return
                self[String.Index(utf16Offset: 0, in: self)...String.Index(utf16Offset: 3, in: self)]
                + "-"
                + self[String.Index(utf16Offset: 4, in: self)...String.Index(utf16Offset: 9, in: self)]
                + "-"
                + self[String.Index(utf16Offset: 10, in: self)...String.Index(utf16Offset: 14, in: self)]
        }
        return self.separate()
    }
    
    var formattedPointCardNumber: String {
        return self.separate()
    }
}

protocol FormattableNumeric {}
extension FormattableNumeric {
    private func formatter(with suffix: String) -> String {
        guard let number = self as? NSNumber else { return "-" }
        let formatter = Format.numberFormatter.copy() as! NumberFormatter
        formatter.positiveSuffix = suffix
        formatter.negativeSuffix = suffix
        if number.stringValue.contains(".") {
            formatter.allowsFloats = true
            formatter.maximumFractionDigits = 2
        }
        return formatter.string(from: number) ?? ""
    }
    
    var formatted: String {
        return formatter(with: "")
    }
    
    var currency: String {
        return formatter(with: "원")
    }
    
    var amount: String {
        return formatter(with: "개")
    }
    
    var coupon: String {
        return formatter(with: "장")
    }
    
    var count: String {
        return formatter(with: "회")
    }
    
    var percent: String {
        return formatter(with: "%")
    }
    
    var point: String {
        return formatter(with: "원")
    }
    
    var liter: String {
        return formatter(with: "ℓ")
    }
    
    var distance: String {
        return formatter(with: "km")
    }
    
    var milliString: String {
        guard let self = self as? Int else { return "" }
        return String(self * 1_000)
    }
}

extension Int: FormattableNumeric { }
extension Float: FormattableNumeric { }
extension Double: FormattableNumeric { }
