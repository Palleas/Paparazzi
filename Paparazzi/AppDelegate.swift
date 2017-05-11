import Cocoa
import ReactiveSwift
import Result

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let manager = ScreenshotsManager(monitor: Monitor())
    
    private var disposable: Disposable?
    private var menu = NSMenu(title: "Paparazzi")
    
    private var contextController: ContextController!
    private var menuController: MenuController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        self.contextController = ContextController(root: documents.flatMap(Directory.init)!)
        
        self.menuController = MenuController(statusItem: NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength), contextController: contextController)
        
        disposable = manager.manage().logEvents().start()
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
