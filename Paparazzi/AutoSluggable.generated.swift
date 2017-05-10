// Generated using Sourcery 0.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length

import Foundation

// MARK: - Sluggable for classes, protocols, structs
extension Directory {
    var slug: String {
        let _merged = [
            path
        ].joined(separator: "-")

        return slugify(_merged)
    }
}

fileprivate func slugify(_ string: String) -> String {
    let s = string
        .components(separatedBy: CharacterSet.alphanumerics.inverted)
        .joined(separator: "-")
        .lowercased()

    let r = try! NSRegularExpression(pattern: "-{2,}", options: [])
    let s2 = r.stringByReplacingMatches(in: s, options: [], range: NSMakeRange(0, s.characters.count), withTemplate: "-")

    let r2 = try! NSRegularExpression(pattern: "-$", options: [])
    return r2.stringByReplacingMatches(in: s2, options: [], range: NSMakeRange(0, s2.characters.count), withTemplate: "")
}
