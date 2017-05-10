import Foundation
import Cocoa

protocol MenuControllerDelegate: class {
    func didCreate(context: String)
}

final class MenuController {
    private let statusItem: NSStatusItem
    
    weak var delegate: MenuControllerDelegate?
    
    init(statusItem: NSStatusItem) {
        self.statusItem = statusItem
        statusItem.title = "📷"
        
        // Build menu
        statusItem.menu = buildMenu()
    }
    
    func buildMenu() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(withTitle: "New context...", action: #selector(didTapAddContext), keyEquivalent: "N").target = self
        
        return menu
    }
    
    @objc
    func didTapAddContext() {
        let contextField = NSTextField(frame: NSRect(origin: .zero, size: CGSize(width: 200, height: 24)))
        
        let prompt = NSAlert()
        prompt.alertStyle = .informational
        prompt.informativeText = "What's the name of your context?"
        prompt.accessoryView = contextField
        prompt.addButton(withTitle: "OK")
        prompt.addButton(withTitle: "Cancel")
        let button = prompt.runModal()
        
        guard prompt.buttons[button - 1000].title == "OK" && !contextField.stringValue.isEmpty else { return }

        let contextName = contextField.stringValue
        print("Creating context with name: \(contextName)")
        
        delegate?.didCreate(context: contextName)
    }
    
    
}
