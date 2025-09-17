import Foundation
import SwiftData

enum HistoryRange {
    case day
    case week
    case month
    case quarter
    case year
    case all
}

extension HistoryRange {
    func filter() -> Predicate<RideItem>? {
        switch self {
        case .all:
            return #Predicate { _ in true }
            
        case .day:
            let today = Calendar.current.startOfDay(for: .now)
            
            return #Predicate {
                $0.date >= today
            }
            
        case .week:
            let weekOfYear = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: .now)
            let startOfWeek = Calendar.current.date(from: weekOfYear)!
            
            return #Predicate {
                $0.date >= startOfWeek
            }
            
        case .month:
            let monthOfYear = Calendar.current.dateComponents([.month, .year], from: .now)
            let startOfMonth = Calendar.current.date(from: monthOfYear)!
            
            return #Predicate {
                $0.date >= startOfMonth
            }
            
        case .quarter:
            let quarter = Calendar.current.dateComponents([.quarter, .year], from: .now)
            let startOfQuarter = Calendar.current.date(from: quarter)!
            
            return #Predicate {
                $0.date >= startOfQuarter
            }
            
        case .year:
            let year = Calendar.current.component(.year, from: .now)
            let dateComponents = DateComponents(year: year)
            
            let startOfYear = Calendar.current.date(from: dateComponents)!
            
            return #Predicate {
                $0.date >= startOfYear
            }
            
        @unknown default:
            return nil
        }
    }
    
    func previousFilter() -> Predicate<RideItem>? {
        switch self {
        case .all:
            return nil
            
        case .day:
            let today = Calendar.current.startOfDay(for: .now)
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            
            return #Predicate {
                $0.date >= yesterday && $0.date < today
            }
            
        case .week:
            let weekOfYear = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: .now)
            let startOfWeek = Calendar.current.date(from: weekOfYear)!
            
            let previousWeekOfYear: DateComponents
            
            guard let woy = weekOfYear.weekOfYear,
                  let year = weekOfYear.yearForWeekOfYear else {
                return nil
            }
            if woy == 1 {
                previousWeekOfYear = DateComponents(weekOfYear: 52, yearForWeekOfYear: year - 1)
            } else {
                previousWeekOfYear = DateComponents(weekOfYear: woy - 1, yearForWeekOfYear: year)
            }
            
            let lastWeek = Calendar.current.date(from: previousWeekOfYear)!
            
            print("\(lastWeek) - \(startOfWeek)")
            return #Predicate {
                $0.date >= lastWeek && $0.date < startOfWeek
            }
            
        case .month:
            let monthOfYear = Calendar.current.dateComponents([.month, .year], from: .now)
            let startOfMonth = Calendar.current.date(from: monthOfYear)!
            
            let previousMonthOfYear: DateComponents
            guard let moy = monthOfYear.month,
                  let year = monthOfYear.year else {
                return nil
            }
            
            if moy == 1 {
                previousMonthOfYear = DateComponents(year: year - 1, month: 12)
            } else {
                previousMonthOfYear = DateComponents(year: year, month: moy - 1)
            }
            
            let lastMonth = Calendar.current.date(from: previousMonthOfYear)!
            
            print("\(lastMonth) - \(startOfMonth)")
            return #Predicate {
                $0.date >= lastMonth && $0.date < startOfMonth
            }
            
        case .quarter:
            let quarter = Calendar.current.dateComponents([.quarter, .year], from: .now)
            let startOfQuarter = Calendar.current.date(from: quarter)!
            
            let previousQuarter: DateComponents
            guard let qtr = quarter.quarter,
                  let year = quarter.year else {
                return nil
            }
            
            if qtr == 1 {
                previousQuarter = DateComponents(year: year - 1, quarter: 4)
            } else {
                previousQuarter = DateComponents(year: year, quarter: qtr - 1)
            }

            let lastQuarter = Calendar.current.date(from: previousQuarter)!

            print("\(lastQuarter) - \(startOfQuarter)")
            return #Predicate {
                $0.date >= lastQuarter && $0.date < startOfQuarter
            }

        case .year:
            let year = Calendar.current.component(.year, from: .now)
            let dateComponents = DateComponents(year: year)
            
            let startOfYear = Calendar.current.date(from: dateComponents)!
            
            let previousYear = DateComponents(year: year - 1)
            let lastYear = Calendar.current.date(from: previousYear)!
            
            print("\(lastYear) - \(startOfYear)")
            return #Predicate {
                $0.date >= lastYear && $0.date < startOfYear
            }
            
        @unknown default:
            return nil
        }
    }
}
