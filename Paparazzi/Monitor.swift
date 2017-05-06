import Foundation
import ReactiveSwift
import Cocoa
import Result

enum MonitorError: Error {
    case missingAttribute(String)
}


final class Monitor {
    
    private let query: NSMetadataQuery
    
    private var desktopDirectory: String {
        guard let desktop = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first else {
            fatalError("User has no desktop, call the priest!")
        }
        
        return desktop
    }
    
    init() {
        query = NSMetadataQuery()
        query.predicate = NSPredicate(format: "kMDItemIsScreenCapture = 1")
        query.searchScopes = [desktopDirectory]
    }
    
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
