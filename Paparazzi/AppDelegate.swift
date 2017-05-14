import Cocoa
import ReactiveSwift
import Result

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var manager: ScreenshotsManager!
    
    private var disposable: Disposable?
    private var menu = NSMenu(title: "Paparazzi")
    
    private var contextController: ContextController!
    private var menuController: MenuController!
    private var cacheManager: FileSystem!
    private let server = Server()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
            .first
            .flatMap(Directory.init)!
        self.cacheManager = FileSystem(directory: cache)

        self.contextController = ContextController()
        
        // Load cache
        switch cacheManager.read(resource: ContextResource()) {
        case let .success(contexts):
            self.contextController.all.swap(contexts)
        case let .failure(error):
            print("Unable to load cache: \(error)")
        }

        self.menuController = MenuController(statusItem: NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength), contextController: contextController)

        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let root = documents.flatMap(Directory.init)!
        
        self.manager = ScreenshotsManager(monitor: Monitor(), contextController: contextController, root: root)
        
        disposable = manager.manage().logEvents().start()
        
        _ = contextController.all.producer.logEvents(identifier: "⚠️")
            .attempt { contexts in
                let raw: [[String: String]] = contexts.map { ["title": $0.title] }
                try! self.cacheManager.write(raw, to: ContextResource())
            }
            .start()
        
        try! server.start()
    }

    func applicationWillTerminate(_ notification: Notification) {
        disposable?.dispose()
    }

}

extension SignalProducer {
    
    func ignoreErrors() -> SignalProducer<Value, NoError> {
        return flatMapError { _ in return SignalProducer<Value, NoError>.empty }
    }
}
