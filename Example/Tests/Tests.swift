import XCTest
import ReactiveSwift
import Moya
import Anvil

class Tests: XCTestCase {
    
    fileprivate let net = NetProvider<NetBusiness>()
    
    func testVersion() throws {
        
        let success = XCTestExpectation(description: "success")
        
        
        let action = Action { self.net.detach(.version) }
        
        
        action.values.observeValues { (version) in
            XCTAssert(false)
            success.fulfill()
        }
        
        action.errors.observeValues { e in
            print(e)
            XCTAssert(true)
            success.fulfill()
        }
        
        action.apply().start()
        
        wait(for: [success], timeout: 60)
        
        
    }
    
    
    fileprivate enum NetBusiness: AnvilTargetType {
        
        
        var headers: [String : String]? { nil }
        
        
        case version
        
        case net404
        
        var baseURL: URL {
            return URL(string: "http://appcourse.roobo.com.cn/pudding/teacher/v1")!
        }
        
        var path: String {
            switch self {
            case .version: return "/apk/org/version/detail"
            case .net404: return "/app/version/404"
            }
            
        }
        
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task { .requestPlain }
        
    }
}
