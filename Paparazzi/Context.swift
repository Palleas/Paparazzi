import Foundation
import Unbox


struct Context: AutoEquatable, AutoSluggable {

    /// The title of the context
    /// sourcery: includeInSlug
    let title: String

}

extension Context: Unboxable {
    
    init(unboxer: Unboxer) throws {
        self.title = try unboxer.unbox(key: "title")
    }
    
}
