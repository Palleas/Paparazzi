import Foundation
import Swifter
import ReactiveSwift
import Result

final class Server {
    
    enum ServerError: Error {
        case startingError
    }
    
    private let server = HttpServer()
    
    let feed = Signal<Data, NoError>.pipe()
    
    func startServer() throws {
        server.POST["/screenshot"] = { request  in
            let multiparts = request.parseMultiPartFormData()
            
            guard let file = multiparts.first(where: { $0.name == "screenshot" }) else {
                return HttpResponse.badRequest(nil)
            }
            
            let content = Data(bytes: file.body)

            self.feed.input.send(value: content)
            
            return HttpResponse.ok(.text("OK"))
        }

        try server.start()
    }
}
