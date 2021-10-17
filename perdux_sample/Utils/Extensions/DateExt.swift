import Foundation

enum DateFormat: String {
    case defaultDate = "dd/MM/yy"
    case midDate = "dd MMM yyyy"
    case defaultTime = "HH:mm:ss"
    case defaultTimeMillis = "HH:mm:ss.SSS"
    case rfc1123 = "EEE',' dd MMM yyyy HH':'mm':'ss z"
    case avatarDate = "yyy-MM-dd'T'HH:mm:ss'Z'"
    case dateDashed = "yyyy-MM-dd'T'HH:mm:ss z"
    case dateAsDDMMMM = "dd MMMM"
    case dateAsDDMMMMYYYY = "dd MMMM yyyy"
    case dateAsMMMDDYYYY = "MMM dd, yyyy"
    case dateAsMMMDD = "MMM dd"
    case dateAsDayOfWeek = "EEEE"
    case dateAsDayOfWeekShort = "EEE"
    case dateAsHHmm = "HH:mm"
    case dateAsDDMM = "dd.MM"
    case dateAsDDMMYYY = "dd.MM.yyy"
    case dateNoYear = "MMMdd"
    case dateAsEEEMMMDYYYY = "EEE',' MMM d',' yyyy"
}

extension Date {
    func formatted(
            dateStyle: DateFormatter.Style = .none,
            dateFormat: DateFormat? = nil,
            timeStyle: DateFormatter.Style = .none,
            locale: Locale = .current,
            calendar: Calendar = .current
    ) -> String {
        let formatter = DateFormatter()

        formatter.calendar = calendar
        formatter.locale = locale
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle

        if let dateFormat = dateFormat {
            formatter.setLocalizedDateFormatFromTemplate(dateFormat.rawValue) //"MMMdd"
        }

        return formatter.string(from: self)
    }

    func toString(as format: String, timezone: TimeZone? = .init(secondsFromGMT: 0), locale: Locale = .current) -> String {
        let formatter = DateFormatter()

        formatter.timeZone = timezone
        formatter.locale = locale

        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func toString(as format: DateFormat, timezone: TimeZone = .current, locale: Locale = .current) -> String {
        return toString(as: format.rawValue, timezone: timezone, locale: locale)
    }

    func toString(as format: DateFormat, timezone: String, locale: Locale = .current) -> String {
        if let tzone = TimeZone(identifier: timezone) {
            return toString(as: format, timezone: tzone, locale: locale)
        }

        return toString(as: format, locale: locale)
    }

    func birthdayFormatted() -> String {
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year], from: Date())
        let dateComponents = calendar.dateComponents([.year], from: self)

        if let currentYear = currentComponents.year, let dateOfYear = dateComponents.year{
            if(currentYear == dateOfYear){
                return toString(as: .dateAsDDMMMM, timezone: .current)
            }
        }
        return toString(as: .dateAsDDMMMMYYYY, timezone: .current)
    }

    func recentCallDateFormatted() -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            return toString(as: .dateAsHHmm, timezone: .current)
        }

        let currentComponents = calendar.dateComponents([.weekOfYear], from: Date())
        let dateComponents = calendar.dateComponents([.weekOfYear], from: self)

        if let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear{
            if(currentWeekOfYear == dateWeekOfYear){
                return toString(as: .dateAsDayOfWeekShort, timezone: .current)
            }
        }

        let str = formatted(dateStyle: .short, timeStyle: .none)

        if calendar.isDate(Date(), equalTo: self, toGranularity: .year) {
            return Self.normalizeShortDateStr(str: str, parts: 2)
        }

        return Self.normalizeShortDateStr(str: str, parts: 3)
    }

    private static func normalizeShortDateStr(str: String, parts: Int) -> String {
        let shortDateBuilder: (String, String.Element, Int)->String = { str, separator, parts in
            str
                    .split(separator: separator)
                    .take(parts)
                    .map { $0.count == 1  ? "0\($0)" : $0 }
                    .joined(separator: String(separator))
        }

        if str.contains(".") {
            return shortDateBuilder(str, ".", parts)
        } else if str.contains("/") {
            return shortDateBuilder(str, "/", parts)
        } else if str.contains("-") {
            return shortDateBuilder(str, "/", parts)
        } else {
            return str
        }
    }

    func recentLogTitleFormatted() -> String{
        let calendar = Calendar.current
        if(calendar.isDateInToday(self)){
            return "Today"

        } else if (calendar.isDateInYesterday(self)){
            return "Yesterday"

        } else {
            let currentComponents = calendar.dateComponents([.weekOfYear], from: Date())
            let dateComponents = calendar.dateComponents([.weekOfYear], from: self)

            if let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear{
                if(currentWeekOfYear == dateWeekOfYear){
                    return toString(as: .dateAsDayOfWeek, timezone: .current)
                }
            }

            if calendar.isDate(Date(), equalTo: self, toGranularity: .month){
                return toString(as: .dateAsDDMMMM, timezone: .current)
            }

            return toString(as: .dateAsDDMMMMYYYY, timezone: .current)
        }
    }


    /// Returns date formatted in 'user-friendly' manner.
    ///
    /// - For today and yesterday cases returns corresponding keys (use them as initializers for e.g. LocalizedStringKey);
    /// - If date is within current week of year, returns date in EEEE format (spelled day of week, e.g. Monday) localized and formatted in accordance with passed Locale and Calendar instances;
    /// - If date is within current year, returns date in MMMdd format (day + month) localized and formatted in accordance with passed Locale and Calendar instances;
    /// - If date is from last year (and for all other cases) returns full date in .medium DateFormatter style localized and formatted in accordance with passed Locale and Calendar instances;
    /// - parameter locale: Locale to use for formatting; Defaults to current user locale.
    /// - parameter calendar: Locale to use for formatting; Defaults to current user calendar.
    func userFriendlyFormatted(locale: Locale = .current, calendar: Calendar = .current) -> String {

        let calendar = calendar
        if(calendar.isDateInToday(self)){
            return "today"

        } else if (calendar.isDateInYesterday(self)){
            return "yesterday"

        } else {
            let currentComponents = calendar.dateComponents([.weekOfYear], from: Date())
            let dateComponents = calendar.dateComponents([.weekOfYear], from: self)

            // Date in this week of year
            if let currentWeekOfYear = currentComponents.weekOfYear,
               let dateWeekOfYear = dateComponents.weekOfYear {
                if currentWeekOfYear == dateWeekOfYear {
                    return "\(formatted(dateStyle: .short, dateFormat: .dateAsDayOfWeek, locale: locale, calendar: calendar))"
                }
            }

            // Date in this
            if calendar.isDate(Date(), equalTo: self, toGranularity: .year) {
                return "\(formatted(dateStyle: .short, dateFormat: .dateNoYear, locale: locale, calendar: calendar))"
            }

            return "\(formatted(dateStyle: .medium, timeStyle: .none, locale: locale, calendar: calendar))"
        }

    }

    func chatListFormattedDate() -> String {
        let calendar = Calendar.current
        if(calendar.isDateInToday(self)){
            return toString(as: .dateAsHHmm, timezone: .current)
        } else {
            let currentComponents = calendar.dateComponents([.weekOfYear], from: Date())
            let dateComponents = calendar.dateComponents([.weekOfYear], from: self)

            if let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear{
                if(currentWeekOfYear == dateWeekOfYear){
                    return toString(as: .dateAsDayOfWeekShort, timezone: .current)
                }
            }

            if calendar.isDate(Date(), equalTo: self, toGranularity: .month){
                return toString(as: .dateAsDDMM, timezone: .current)
            }

            return toString(as: .dateAsDDMMYYY, timezone: .current)
        }
    }

    func formattedConversationDate() -> String {
        let calendar = Calendar.current
        if(calendar.isDateInToday(self)){
            return "Today"

        } else if (calendar.isDateInYesterday(self)){
            return "Yesterday"

        } else {
            let currentComponents = calendar.dateComponents([.weekOfYear], from: Date())
            let dateComponents = calendar.dateComponents([.weekOfYear], from: self)

            if let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear{
                if(currentWeekOfYear == dateWeekOfYear){
                    return toString(as: .dateAsDayOfWeek, timezone: .current)
                }
            }

            if calendar.isDate(Date(), equalTo: self, toGranularity: .month){
                return toString(as: .dateAsMMMDD, timezone: .current)
            }

            return toString(as: .dateAsMMMDDYYYY, timezone: .current)
        }
    }

    func formattedTaskDeadline() -> String {
        let calendar = Calendar.current
        if self > Date() {
            if calendar.isDateInToday(self) {
                return "By \(toString(as: .dateAsHHmm, timezone: .current))"
            } else if calendar.isDateInTomorrow(self) {
                return "Tomorrow"
            } else if calendar.isDateInThisWeek(self) {
                return "This week"
            } else if calendar.isDateInNextWeeks(self, amount: 1) {
                return "Next Week"
            } else {
                return "Over Two Weeks"
            }
        } else {
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
            if let years = dateComponents.year, years > 0 {
                return "-\(years) \(years > 1 ? "years" : "year")"

            } else if let months = dateComponents.month, months > 0 {
                return "-\(months) \(months > 1 ? "months" : "month")"

            } else if let days = dateComponents.day, days > 0 {
                let weeks: Int = days/7
                if weeks > 0 {
                    return "-\(weeks) \(weeks > 1 ? "weeks" : "week")"
                } else {
                    return "-\(days) \(days > 1 ? "days" : "day")"
                }

            } else if let hours = dateComponents.hour, hours > 0 {
                let hoursText = String(format: "%02d", hours)
                return "-\(hoursText) \(hours > 1 ? "hours" : "hour")"

            } else if let minutes = dateComponents.minute {
                let minutesText = String(format: "%02d", minutes)
                return "-\(minutesText) \(minutes > 1 ? "minutes" : "minute")"

            } else {
                return ""
            }
        }
    }

    func formattedDeadlineInForm() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            return "Today at \(toString(as: .dateAsHHmm, timezone: .current))"
        } else if calendar.isDateInTomorrow(self) {
            return "Tomorrow at \(toString(as: .dateAsHHmm, timezone: .current))"
        } else {
            return toString(as: .dateAsEEEMMMDYYYY, timezone: .current)
        }
    }

    func formattedStartDateInForm() -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(self) {
            if calendar.startOfDay(for: self) == self {
                return "Today"
            } else {
                return "\(toString(as: .dateAsHHmm, timezone: .current)) - Today"
            }
        } else if calendar.isDateInTomorrow(self) {
            if calendar.startOfDay(for: self) == self {
                return "Tomorrow"
            } else {
                return "\(toString(as: .dateAsHHmm, timezone: .current)) - Tomorrow"
            }
        } else {
            return toString(as: .dateAsEEEMMMDYYYY, timezone: .current)
        }
    }
}

extension String {
    static let timeZoneRegex = "[+-]\\d{2}[:]\\d{2}"

    func asDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        formatter.locale = NSLocale(localeIdentifier: "en_us_POSIX") as Locale
        guard let result = formatter.date(from: self) else {
            return nil
        }

        return result
    }

    func asDate(format: String, timeZone: TimeZone?) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone ?? TimeZone(secondsFromGMT: 0)

        formatter.locale = NSLocale(localeIdentifier: "en_us_POSIX") as Locale
        guard let result = formatter.date(from: self) else {
            return nil
        }

        return result
    }

    func asUtcDate(format: DateFormat) -> Date? {
        asUtcDate(format: format.rawValue)
    }

    func asUtcDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        formatter.locale = NSLocale(localeIdentifier: "en_us_POSIX") as Locale
        guard let result = formatter.date(from: self) else {
            return nil
        }

        return result
    }

    func asDate(format: DateFormat = DateFormat.defaultDate) -> Date? {
        asDate(format: format.rawValue)
    }

    var asDateIgnoreTimeZone: Date? {
        let dateStringIgnoringTimeZone =
                self.replacingOccurrences(of: String.timeZoneRegex, with: "", options: .regularExpression)
                        .replacingOccurrences(of: " AM", with: "")
                        .replacingOccurrences(of: " PM", with: "")
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = DateFormat.defaultDate.rawValue

        return formatter.date(from: dateStringIgnoringTimeZone)
    }
}

extension Date {
    var toMillis: Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }

    var toSeconds: Int64 {
        Int64(timeIntervalSince1970)
    }

    static func from(millis: Int64?) -> Date? {
        millis.map() { number in Date(timeIntervalSince1970: Double(number) / 1000)}
    }

    static func from(seconds: Int64?) -> Date? {
        seconds.map() { number in Date(timeIntervalSince1970: Double(number))}
    }

    static var currentTimeInMillis: Int64 {
        Date().toMillis
    }

    init(fromMillis timeIntervalSince1970inMillis: Int64) {
        let timeIntervalSince1970inMillis = Double(timeIntervalSince1970inMillis)/1000
        self.init(timeIntervalSince1970: timeIntervalSince1970inMillis)
    }

    var timeWithMillis: String {
        "\(self.toString(as: DateFormat.defaultTimeMillis, timezone: .current))"
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension Date {
    enum DayOfWeek: Int {
        case sunday = 1
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday

        var title: String {
            switch self {
            case .sunday:
                return "Sunday"
            case .monday:
                return "Monday"
            case .tuesday:
                return "Tuesday"
            case .wednesday:
                return "Wednesday"
            case .thursday:
                return "Thursday"
            case .friday:
                return "Friday"
            case .saturday:
                return "Saturday"
            }
        }
    }
}
