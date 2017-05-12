// Generated using Sourcery 0.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}

// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - Context AutoEquatable
extension Context: Equatable {} 
internal func == (lhs: Context, rhs: Context) -> Bool {
    guard lhs.title == rhs.title else { return false }
    return true
}
// MARK: - ScreenShot AutoEquatable
extension ScreenShot: Equatable {} 
internal func == (lhs: ScreenShot, rhs: ScreenShot) -> Bool {
    guard lhs.displayName == rhs.displayName else { return false }
    guard lhs.path == rhs.path else { return false }
    guard lhs.changedAt == rhs.changedAt else { return false }
    return true
}

// MARK: - AutoEquatable for Enums

// MARK: -
