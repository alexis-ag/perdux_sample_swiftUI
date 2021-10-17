import Foundation

extension Calendar {
    func isDateInThisWeek(_ date: Date) -> Bool {
        isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }

    func isDateInNextWeeks(_ date: Date, amount: Int) -> Bool {
        guard let nextWeek = self.date(byAdding: DateComponents(weekOfYear: amount), to: Date()) else {
            return false
        }
        return isDate(date, equalTo: nextWeek, toGranularity: .weekOfYear)
    }
}
