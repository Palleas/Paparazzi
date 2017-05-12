import Foundation
import ReactiveSwift
import Result

final class ContextController {

    let all = MutableProperty<[Context]>([])

    let current = MutableProperty<Context?>(nil)

    func createContext(withName name: String) -> Context {
        let context = Context(title: name)
        all.swap(all.value + [context])
        
        return context
    }
    
}
