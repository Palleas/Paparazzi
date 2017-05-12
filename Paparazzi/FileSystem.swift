import Foundation
import Result
import Unbox

protocol Resource {
    
    associatedtype ValueObject: Unboxable
    
    var filename: String { get }

}

struct Directory: AutoSluggable {

    // sourcery: includeInSlug
    let path: String
    
    func filename<T: Resource>(for resource: T) -> String {
        return (path as NSString).appendingPathComponent(resource.filename)
    }
}


final class CacheManager {
    
    enum CacheError: Error {
        case doesNotExist
    }
    
    private let directory: Directory
    
    init(directory: Directory) {
        self.directory = directory
    }
    
    func read<T: Resource>(resource: T) -> Result<[T.ValueObject], CacheError> {
        let path = directory.filename(for: resource)
        guard FileManager.default.fileExists(atPath: path) else {
            return .failure(CacheError.doesNotExist)
        }
        
        return Result(attempt: {
            let content = try Data(contentsOf: URL(fileURLWithPath: path))
            
            return try unbox(data: content)
        })
    }
    
    func write<R: Resource>(_ writable: Any, to resource: R) throws {
        let data = try JSONSerialization.data(withJSONObject: writable, options: .prettyPrinted)
        let path = directory.filename(for: resource)
        try data.write(to: URL(fileURLWithPath: path))
    }
}

struct ContextResource: Resource {
    typealias ValueObject = Context
    
    let filename = "contexts.json"
}
