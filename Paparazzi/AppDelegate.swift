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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.contextController = ContextController()
        
        self.menuController = MenuController(statusItem: NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength), contextController: contextController)

        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let root = documents.flatMap(Directory.init)!
        
        self.manager = ScreenshotsManager(monitor: Monitor(), contextController: contextController, root: root)
        
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
