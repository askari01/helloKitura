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

router.get("/custom-headers") { request, response, next in
    response.headers["X-Generator"] = "Kitura!"
    response.headers.setType("text/plainText", charset: "utf-8")
    response.send("Hello!")
    next()
}

router.get("/redirect") { request, response, next in
    try? response.redirect("/", status: .movedPermanently)
    next()
}

router.get("/calc") { request, response, next in
    defer {
        next()
    }
    guard let value1 = request.queryParameters["a"], let value2 = request.queryParameters["b"] else {
        response.status(.badRequest)
        response.send("value for a or b missing")
        Log.error("missing parameter")
        return
    }
    
    guard let value1Int = Int(value1), let value2Int = Int(value2) else {
        response.status(.badRequest)
        response.send("value for a or b is not integer")
        Log.error("parameter conversion to integer issue")
        return
    }
    
    let sum = value1Int + value2Int
    response.send("sum is \(sum)")
}

// routes
router.lock("/lock") { request, response, next in
    defer {
        next()
    }
    response.send("lock request")
}

router.get("/post/:postId") {request, response, next in
    defer {
        next()
    }
    
    let postId = request.parameters["postId"]!
    response.send("response id is \(postId)")
    
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
