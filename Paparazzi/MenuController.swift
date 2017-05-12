import Foundation
import Cocoa

final class MenuController {
    private let statusItem: NSStatusItem
    
    private let contextController: ContextController
    
    init(statusItem: NSStatusItem, contextController: ContextController) {
        self.statusItem = statusItem
        self.contextController = contextController
        
        statusItem.title = "📷"
        
        // Build menu
        contextController.all.producer.logEvents().startWithValues { [weak self] in
            self?.statusItem.menu = self?.createMenu(with: $0)
        }
    }
    
    func createMenu(with contexts: [Context]) -> NSMenu {
        print("Building menu")
        let menu = NSMenu()
        menu.addItem(withTitle: "New context...", action: #selector(didTapAddContext), keyEquivalent: "N").target = self
        
        guard !contexts.isEmpty else { return menu }
        
        menu.addItem(.separator())
        contexts
            .enumerated()
            .map { offset, element in
                let item = NSMenuItem(title: element.title, action: #selector(didSelect(item:)), keyEquivalent: "")
                item.tag = offset
                item.target = self

                return item
            }
            .forEach(menu.addItem)
        
        return menu
    }
    
    @objc
    func didSelect(item: NSMenuItem) {
        let contexts = self.contextController.all.value
        guard item.tag >= 0 && item.tag < contexts.count else {
            fatalError("Invalid context!")
        }
        
        let context = contexts[item.tag]
        print("You have selected \(context.title)")
        
        self.contextController.current.swap(context)
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
        
        _ = contextController.createContext(withName: contextName)
    }
    
    
}
