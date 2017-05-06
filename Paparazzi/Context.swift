import Foundation

protocol ContextProtocol {
    
    /// The title of the context
    var title: String { get }
    
    /// The path to save a screenshot to
    var path: String { get }
    
}

struct DefaultContext: ContextProtocol {
    
    let title = "Default"
    
    let path = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first!

}
