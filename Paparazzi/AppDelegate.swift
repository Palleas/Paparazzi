import Cocoa
import ReactiveSwift
import Result

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private let context = MutableProperty<ContextProtocol>(DefaultContext())

    private let paparazzi = Monitor()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let startedAt = Date()
        
        let newScreenshots = paparazzi
            .screenshots()
            .ignoreErrors()
            .map { screenshots in screenshots
                .filter { $0.changedAt >= startedAt }
            }
            .filter { !$0.isEmpty }
            .logEvents(identifier: "Screenshots")
        
        let currentContext = context.producer.logEvents(identifier: "Current Context")
        
        SignalProducer.combineLatest(newScreenshots, currentContext).startWithValues { screenshots, context in
            
            print("Current context = \(context.title)")
            print("Screenshots = \(screenshots)")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

extension SignalProducer {
    
    func ignoreErrors() -> SignalProducer<Value, NoError> {
        return flatMapError { _ in return SignalProducer<Value, NoError>.empty }
    }
}
