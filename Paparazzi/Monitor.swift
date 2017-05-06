import Foundation
import ReactiveSwift
import Cocoa
import Result

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
