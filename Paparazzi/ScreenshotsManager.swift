import Foundation
import ReactiveSwift
import Result

final class ScreenshotsManager {
    
    enum ManagerError: Error {
        
    }
    
    private let monitor: Monitor
    private let contextController: ContextController
    private let root: Directory

    init(monitor: Monitor, contextController: ContextController, root: Directory) {
        self.monitor = monitor
        self.contextController = contextController
        self.root = root
    }
    
    func manage() -> SignalProducer<(), ManagerError> {
        let allScreenshots = newScreenshots().flatten()
        let context = contextController.current.producer.skipNil()
        
        return SignalProducer.combineLatest(allScreenshots, context)
            .logEvents(identifier: "New Screenshots")
            .promoteErrors(ManagerError.self)
            .attemptMap(move)
    }
    
    func move(_ screenshot: ScreenShot, to context: Context) -> Result<(), ManagerError>  {
        let manager = FileManager.default

        // Add proper number
        return Result {
            let directory = try encureDirectory(for: context)
            
            let target = (directory as NSString).appendingPathComponent(UUID().uuidString)
            print("Moving file from \(screenshot.path) to \(target)")
            try manager.moveItem(atPath: screenshot.path, toPath: target)
        }
    }

    func write(_ screenshot: Data, to context: Context) -> Result<(), ManagerError>  {
        return Result {
            let directory = try encureDirectory(for: context)
            
            let target = (directory as NSString).appendingPathComponent(UUID().uuidString)
            try screenshot.write(to: URL(fileURLWithPath: target))
        }
    }

    func encureDirectory(for context: Context) throws -> String {
        let directory = (root.path as NSString).appendingPathComponent(context.slug)
        
        guard !FileManager.default.fileExists(atPath: directory) else { return directory }
        
        try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)

        return directory
    }
    
    func newScreenshots() -> SignalProducer<[ScreenShot], NoError> {
        let startedAt = Date()
        
        let newScreenshots = monitor
            .screenshots()
            .ignoreErrors()
            .map { screenshots in
                screenshots.filter { $0.changedAt >= startedAt }
            }
            .filter { !$0.isEmpty }
        
        return newScreenshots
    }
}
