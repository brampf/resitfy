import XCTest
@testable import Restify
import CryptoKit

final class RestifyTests: XCTestCase {

    static var allTests = [
        ("URL Generator", testURLGeneration),
        ("URL Operator", testURLOperator),
        ("HTTP Method Generator", testHTTPMethodGeneration),
        ("GET Request Geenrator", testDataDownloadRequest)
    ]
    
    func testURLOperator() {
        
        let base = HTTP(host: "domain.tld")
        XCTAssertEqual((base⁄"/version").url?.absoluteString, "http://domain.tld/version")
        //XCTAssertEqual((base⁄"/version"⁄"/test").url?.absoluteString, "http://domain.tld/version/test")
        XCTAssertEqual((base⁄[.parameter("test", "best")]).url?.absoluteString, "http://domain.tld?test=best")
        XCTAssertEqual((base⁄[.parameter("test", "best"),.parameter("west", "rest")]).url?.absoluteString, "http://domain.tld?test=best&west=rest")
    }
    
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
        
        
        XCTAssertEqual(HTTPS(host: "brampf.de", port: 9090, path: "/version", params: [.parameter("hully", "gully"), .parameter("hello", "world")]).url?.absoluteString, "https://brampf.de:9090/version?hully=gully&hello=world")
    }
    
    func testHTTPMethodGeneration() {
        
        let get = GET(url: HTTP(host: "localhost", port: 8080, path: nil, params: nil), headers: [.ContentType("application/json")], expectedStatus: [.OK])
        
        XCTAssertNotNil(get)
        
    }
    
    func testMethodGeneration() {
        
        struct Data : Codable {
            var hello : String = "WORLD"
        }

        
        let put = PUT(url: HTTP(host: "brampf.de"), body: Data(), expectedStatus: [.OK])
        
        XCTAssertNotNil(put)
        
        put.debug()
        
    }
    
    
    func testDataDownloadRequest() {
        
        let data = "HELLO WORLD".data(using: .utf8)
        
        let get = GET(url: HTTP(host: "localhost", port: 8080, path: nil, params: nil),  headers: [.ContentType("audio/x-wav")], expectedStatus: [.OK])
        let request = get.request
        
        XCTAssertEqual(request?.value(forHTTPHeaderField: "ContentType"), "audio/x-wav")
        
        
    }
    
    func pp<C:Codable>(_ c: C?) -> String? {
        
        let enc = JSONEncoder()
        enc.outputFormatting = .prettyPrinted
        if let data = try? enc.encode(c){
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
        
    }
}
