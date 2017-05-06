import Foundation
import ReactiveSwift
import Cocoa
import Result

extension NSMetadataItem {
    func value(for name: String) -> String? {
        guard let value = self.value(forAttribute: name) else { return nil }
        
        return value as? String
    }

    func date(for name: String) -> Date? {
        guard let value = self.value(forAttribute: name) else { return nil }
        
        return value as? Date
    }

    
    var displayName: String? {
        return value(for: NSMetadataItemDisplayNameKey)
    }
    
    var path: String? {
        return value(for: NSMetadataItemPathKey)
    }
    
    var contentChangedAt: Date? {
        return date(for: NSMetadataItemFSContentChangeDateKey)
    }
}

struct ScreenShot: AutoEquatable {
    
    let displayName: String
    
    let path: String
    
    let changedAt: Date
}

extension ScreenShot {
    static func create(item: NSMetadataItem) throws -> ScreenShot {
        guard let displayName = item.displayName else {
            throw MonitorError.missingAttribute(NSMetadataItemDisplayNameKey)
        }

        guard let path = item.path else {
            throw MonitorError.missingAttribute(NSMetadataItemPathKey)
        }
        
        guard let changedAt = item.contentChangedAt else {
            throw MonitorError.missingAttribute(NSMetadataItemFSContentChangeDateKey)
        }
        
        return ScreenShot(displayName: displayName, path: path, changedAt: changedAt)
    }
}

// TODO: Use sourcery's hashable
extension ScreenShot: Hashable {
    var hashValue: Int {
        return path.hashValue ^ displayName.hashValue
    }
}

enum MonitorError: Error {
    case missingAttribute(String)
}

final class Monitor {
    
    let query: NSMetadataQuery = {
        // TODO: update query to search *new* items
        $0.predicate = NSPredicate(format: "kMDItemIsScreenCapture = 1")
        $0.searchScopes = [NSMetadataQueryUserHomeScope]

        return $0
    }(NSMetadataQuery())
    
    func screenshots() -> SignalProducer<[ScreenShot], MonitorError> {
        let screenshots = watch(self.query)
            .promoteErrors(MonitorError.self)
            .attemptMap { items in return Result<[ScreenShot], MonitorError> {
                try items.map(ScreenShot.create)
            } }
        return screenshots
    }
    
    func watch(_ query: NSMetadataQuery) -> SignalProducer<[NSMetadataItem], NoError> {
        if !query.isStarted {
            query.start()
        }
        
        let center = NotificationCenter.default.reactive
        
        let didUpdate = Signal.merge(
            center.notifications(forName: .NSMetadataQueryDidStartGathering, object: query),
            center.notifications(forName: .NSMetadataQueryDidUpdate, object: query),
            center.notifications(forName: .NSMetadataQueryDidFinishGathering, object: query)
        )
        
        return SignalProducer(didUpdate)
            .map { note in (note.object as! NSMetadataQuery).results as! [NSMetadataItem] }
    }

}
