import Foundation

public extension Array {
    mutating func insert(_ elem: Element) where Element: Equatable {
        self.append(elem)
    }

    mutating func upsert(_ elems: [Element]) where Element: Equatable {
        elems.forEach { self.upsert($0) }
    }

    mutating func upsert(_ elem: Element) where Element: Equatable {
        if let index = self.firstIndex(of: elem) {
            self.append(elem)
            self.swapAt(index, self.count - 1)
            self.removeLast()
        } else {
            self.append(elem)
        }
    }

    mutating func remove(_ elem: Element) where Element: Equatable {
        if let index = self.firstIndex(of: elem),
           index < self.count {
            self.swapAt(index, self.count - 1)
            self.removeLast()
        }
    }
    mutating func removeById(_ elem: Element) where Element: Identifiable {
        self = self.filter { $0.id != elem.id }
    }

    func take(_ take: Int, skip: Int = 0) -> Array<Element> {
        Array(self[skip..<skip+Swift.min(take, self.count-skip)])
    }

    func distinct<T: Hashable>(byKey key: (Element) -> T) -> [Element] {
        var result = [Element]()
        var seen = Set<T>()

        for value in self {
            if seen.insert(key(value)).inserted {
                result.append(value)
            }
        }

        return result
    }

    func concat(_ another: Array) -> [Element] {
        var result: [Element] = []
        result.append(contentsOf: self)
        result.append(contentsOf: another)
        return result
    }

    func groupBy<G: Hashable>(groupClosure: (Element) -> G) -> [G: [Element]] {
        Dictionary(grouping: self, by: groupClosure)
    }

    var hasMany: Bool {
        self.count > 1
    }
    var hasOne: Bool {
        self.count == 1
    }
    var isNotEmpty: Bool {
        !isEmpty
    }
    func isLast(_ elem: Element) -> Bool where Element: Equatable {
        self.last == elem
    }
    func isFirst(_ elem: Element) -> Bool where Element: Equatable {
        self.first == elem
    }
}


extension Set {
    var isNotEmpty: Bool {
        !isEmpty
    }

    func groupBy<G: Hashable>(groupClosure: (Element) -> G) -> [G: [Element]] {
        Dictionary(grouping: self, by: groupClosure)
    }
}


extension Dictionary {
    var isNotEmpty: Bool {
        !isEmpty
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}