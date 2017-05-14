import Foundation
import Swifter

final class Server {
    
    private let server = HttpServer()

    init() {
        server.GET["/"] = { request in
            print("Request = \(request)")
            return HttpResponse.ok(.text("Send POST request to /screenshot"))
        }
        
        server.POST["/screenshot"] = { request  in
            let multiparts = request.parseMultiPartFormData()
            
            guard let file = multiparts.first(where: { $0.name == "screenshot" }) else {
                return HttpResponse.badRequest(nil)
            }
            
            let content = Data(bytes: file.body)
            let filename = "\(UUID().uuid)-\(file.name ?? "")"
            let desktop = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(filename)
            try! content.write(to: desktop)
            
            return HttpResponse.ok(.text("OK"))
        }
    }
    func start() throws {
        print("Starting server...")
        try server.start()
    }
}
