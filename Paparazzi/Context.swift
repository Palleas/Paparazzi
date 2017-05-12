import Foundation

protocol ContextProtocol: AutoEquatable, AutoSluggable {
    
    /// The title of the context
    /// sourcery: includeInSlug
    var title: String { get }

}

struct DefaultContext: ContextProtocol {
    
    let title = "Default"

}


struct Context: ContextProtocol {

    let title: String

}
