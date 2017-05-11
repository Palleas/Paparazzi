import Foundation
import ReactiveSwift
import Result

struct Directory: AutoSluggable {
    // sourcery: includeInSlug
    let path: String
}

final class ContextController {

    let all = MutableProperty<[Context]>([])

    let current = MutableProperty<Context?>(nil)

    private let root: Directory
    
    
    
    init(root: Directory) {
        self.root = root

    }

    func createContext(withName name: String) -> Context {
        let context = Context(title: name)
        all.swap(all.value + [context])
        
        return context
    }
    
}
