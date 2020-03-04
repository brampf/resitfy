import XCTest
@testable import Restify

final class RestifyTests: XCTestCase {

    static var allTests = [
        ("URL Generator", testURLGeneration),
        ("HTTP Method Generator", testHTTPMethodGeneration),
    ]
    
    func testURLGeneration() {

        
        XCTAssertEqual(HTTP(host: "brampf.de", port: nil, path: nil, params: nil).url?.absoluteString, "http://brampf.de")
        XCTAssertEqual(HTTP(host: "brampf.de", port: 8080, path: nil, params: nil).url?.absoluteString, "http://brampf.de:8080")
        XCTAssertEqual(HTTPS(host: "brampf.de", port: nil, path: nil, params: nil).url?.absoluteString, "https://brampf.de")
        XCTAssertEqual(HTTPS(host: "brampf.de", port: 9090, path: nil, params: nil).url?.absoluteString, "https://brampf.de:9090")
        
        XCTAssertEqual(HTTP(host: "brampf.de", port: nil, path: "/version", params: nil).url?.absoluteString, "http://brampf.de/version")
        XCTAssertEqual(HTTP(host: "brampf.de", port: 8080, path: "/version", params: nil).url?.absoluteString, "http://brampf.de:8080/version")
        XCTAssertEqual(HTTPS(host: "brampf.de", port: nil, path: "/version", params: nil).url?.absoluteString, "https://brampf.de/version")
        XCTAssertEqual(HTTPS(host: "brampf.de", port: 9090, path: "/version", params: nil).url?.absoluteString, "https://brampf.de:9090/version")
        
        XCTAssertEqual(HTTP(host: "brampf.de", port: nil, path: nil, params: [.parameter("hully", "gully")]).url?.absoluteString, "http://brampf.de?hully=gully")
        XCTAssertEqual(HTTP(host: "brampf.de", port: 8080, path: nil, params: [.parameter("hully", "gully")]).url?.absoluteString, "http://brampf.de:8080?hully=gully")
        XCTAssertEqual(HTTPS(host: "brampf.de", port: nil, path: nil, params: [.parameter("hully", "gully")]).url?.absoluteString, "https://brampf.de?hully=gully")
        XCTAssertEqual(HTTPS(host: "brampf.de", port: 9090, path: nil, params: [.parameter("hully", "gully")]).url?.absoluteString, "https://brampf.de:9090?hully=gully")
        
        XCTAssertEqual(HTTP(host: "brampf.de", port: nil, path: "/version", params: [.parameter("hully", "gully")]).url?.absoluteString, "http://brampf.de/version?hully=gully")
        XCTAssertEqual(HTTP(host: "brampf.de", port: 8080, path: "/version", params: [.parameter("hully", "gully")]).url?.absoluteString, "http://brampf.de:8080/version?hully=gully")
        XCTAssertEqual(HTTPS(host: "brampf.de", port: nil, path: "/version", params: [.parameter("hully", "gully")]).url?.absoluteString, "https://brampf.de/version?hully=gully")
        XCTAssertEqual(HTTPS(host: "brampf.de", port: 9090, path: "/version", params: [.parameter("hully", "gully")]).url?.absoluteString, "https://brampf.de:9090/version?hully=gully")
    }
    
    func testHTTPMethodGeneration() {
        
        GET(url: HTTP(host: "localhost", port: 8080, path: nil, params: nil), headers: [.contentType("application/json")], expectedStatus: [.OK])
        
        let base = HTTP(host: "domain.tld")
        _ = base⁄"version"
        _ = base⁄[.parameter("test", "best")]
        _ = base⁄"version"⁄"test"
        
    }

}
