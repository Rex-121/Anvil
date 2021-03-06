//
//  TResult.swift
//  GINetworking
//
//  Created by Ray on 2018/12/6.
//

import Moya

public typealias MFData = Moya.MultipartFormData
extension Dictionary where Value == String, Key == String {
    public func multipartData() -> [MFData] { return self.map { MultipartFormData(provider: .data($1.data(using: .utf8)!), name: $0) } }
}

public struct DontCare: Codable { }

public struct GIResult<Care: Decodable>: Decodable {
    
    /// 解析的结构
    public var result: Care?
    
    ///信息
    public let message: String?
    
    ///请求码
    public let code: String?
    
    ///请求状态
//    public let status: String?
    
    public let good: Bool
    
    private enum CodingKeys: String, CodingKey {
        case result = "obj", code, message = "msg", good = "success"
    }
    
    /// 是否成功，后台信息
    public var info: BasicInfo {
        return BasicInfo(success: good, message: message, code: code)
    }

    /// 可能的错误信息　
    public var errorInfo: GINetError {
        return .business(info)
    }
    
}

public struct BasicInfo: CustomStringConvertible {
    /// 是否成功
    public let success: Bool
    
    /// 信息
    public let message: String?
    
    /// 状态码
    public let code: String?
    
    public var description: String {
        return message ?? ""
    }
}

extension GIResult {
    public static var ParseWrong: GIResult {
        return GIResult(result: nil, message: "解析错误", code: "-999", good: false)
    }
    
    public static var NotFound: GIResult {
        return GIResult(result: nil, message: "无法连接到服务器", code: "404", good: false)
    }
}


public enum GINetError: Error, CustomStringConvertible {
    case business(BasicInfo), network(String, Response?)
    
    
    /// 解析错误
    public static var ParseWrong: GINetError {
        return .business(BasicInfo(success: false, message: "解析错误", code: "-999"))
    }
    
    
    /// 快速创建业务错误
    ///
    /// - Parameters:
    ///   - business: 错误信息
    ///   - success: 是否成功 默认为 false
    ///   - code: 错误码 默认为 -1740
    /// - Returns: 业务错误
    public static func at<B: CustomStringConvertible>(business: B?, _ success: Bool = false, _ code: String = "-1740") -> GINetError {
        return .business(BasicInfo(success: success, message: business?.description, code: code))
    }

    /// 原始的信息
    private var message: String? {
        switch self {
        case .business(let info): return info.message
        case .network(let info, _): return info
        }
    }

    /// 错误信息
    public var description: String {
        return message ?? ""
    }
    
}


//extension GIResult {
//    
//    /// (解析的结构，请求信息)
//    var truck: (Care?, GIResult) {
//        return (self.result, self)
//    }
//}

//public enum XResult: Codable {
//
//    case success
//
//    case failure
//
//    struct Keys: CodingKey {
//        var stringValue: String
//        init?(stringValue: String) {
//            self.stringValue = stringValue
//        }
//
//        var intValue: Int? { return nil }
//        init?(intValue: Int) { return nil }
//
//        static let message = Keys(stringValue: "message")!
//        static let code = Keys(stringValue: "responseCode")!
//        static let data = Keys(stringValue: "data")!
//        static let status = Keys(stringValue: "status")!
//    }
//
//
//    public init(from decoder: Decoder) throws {
//        do {
//           let k = try decoder.container(keyedBy: Keys.self)
//
//            let m = try k.decode(String.self, forKey: .message)
//
//            print(m)
//
////            for key in k.allKeys {
////                print(key)
//////                let productContainer = try k.nestedContainer(keyedBy: ProductKey.self, forKey: key)
////                let p = try productContainer.decode(Int.self, forKey: .code)
////                print(p)
////            }
//
//            self = .success
//        } catch {
//            self = .failure
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws { }
//}
//

