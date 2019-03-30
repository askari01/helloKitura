import Kitura
import LoggerAPI
import HeliumLogger
import Foundation

let router = Router()
let helium = HeliumLogger(.verbose)
Log.logger = helium

router.get("/") { request, response, next in
    defer {
        next()
    }
    response.send("Hello World!")
}

router.get("/") { request, response, next in
    defer {
        next()
    }
    response.send("\nHello again!")
}

router.all("request-info") { request, response, next in
    response.send("you are accessing \(request.hostname) on port \(request.port)")
    response.send("request method was \(request.method.rawValue).\n")
    if let agent = request.headers["User-Agent"] {
        response.send("your user agent is \(agent)")
    }
    next()
}

router.get("/hello-you") { request, response, next in
    response.status(.forbidden)
    if let name = request.queryParameters["name"] {
        response.send("your name is \(name)")
    } else {
        response.send("no name")
    }
    next()
}

// for logging
struct StandardError: TextOutputStream {
    func write(_ text: String) {
        guard let data = text.data(using: String.Encoding.utf8) else {
            return
        }
        FileHandle.standardError.write(data)
    }
}

let se = StandardError()
HeliumStreamLogger.use(outputStream: se)

Kitura.addHTTPServer(onPort: 8080, with: router)
// Kitura.addFastCGIServer(onPort: 9000, with: router) 

Kitura.run()
