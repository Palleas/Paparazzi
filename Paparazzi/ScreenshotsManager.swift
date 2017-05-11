import Foundation
import ReactiveSwift
import Result

final class ScreenshotsManager {
    
    enum ManagerError: Error {
        
    }
    
    private let monitor: Monitor
    
    let context = MutableProperty<ContextProtocol>(DefaultContext())

    init(monitor: Monitor) {
        self.monitor = monitor
    }
    
    func manage() -> SignalProducer<(), ManagerError> {
        return SignalProducer.combineLatest(newScreenshots().flatten(), context.producer)
            .logEvents(identifier: "New Screenshots")
            .promoteErrors(ManagerError.self)
            .attemptMap(move)
    }
    
    func move(_ screenshot: ScreenShot, to context: ContextProtocol) -> Result<(), ManagerError>  {
        let manager = FileManager.default
        
        // Add proper number
        let target = (context.title as NSString).appendingPathComponent(UUID().uuidString)
        return Result {
            print("Moving file from \(screenshot.path) to \(target)")
            try manager.moveItem(atPath: screenshot.path, toPath: target)
        }
    }
    
    func newScreenshots() -> SignalProducer<[ScreenShot], NoError> {
        let startedAt = Date()
        
        let newScreenshots = monitor
            .screenshots()
            .logEvents(identifier: "Screenshots")
            .ignoreErrors()
            .map { screenshots in screenshots
                .filter { $0.changedAt >= startedAt }
            }
            .filter { !$0.isEmpty }
        
        return newScreenshots
    }
}
