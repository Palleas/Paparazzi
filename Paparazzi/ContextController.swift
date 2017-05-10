import Foundation
import ReactiveSwift
import Result

struct Directory: AutoSluggable {
    // sourcery: includeInSlug
    let path: String
}


final class ContextController {

    private let contexts = MutableProperty<[Context]>([])

    private let root: Directory

    init(root: Directory) {
        self.root = root
    }

    func createContext(withName name: String) -> SignalProducer<Context, NoError> {
        return .empty
    }
}
