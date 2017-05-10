import Cocoa
import ReactiveSwift
import Result

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let manager = ScreenshotsManager(monitor: Monitor())
    
    private var disposable: Disposable?
    private var menu = NSMenu(title: "Paparazzi")
    private let menuController = MenuController(statusItem: NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength))
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
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
