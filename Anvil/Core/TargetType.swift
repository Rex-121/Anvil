//
//  TargetType.swift
//  Anvil
//
//  Created by Tyrant on 2020/1/11.
//

import Foundation


public protocol Kx: Decodable {
        
}

public protocol AnvilTargetType: TargetType {
    
    
    var backTrateCodeLikeSuccess: Int { get }
 
    
}



public extension AnvilTargetType {
    
    var backTrateCodeLikeSuccess: Int { 200 }
    
}


public struct AnvilResult<Expect: Decodable>: Decodable {
     /// 解析的结构
       public var result: Expect?
       
       ///信息
       public let message: String?
       
       ///请求码
       public let code: Int?
       
       public let success: Bool
       
       private enum CodingKeys: String, CodingKey {
           case result = "data", code, message, success
       }
}

