//
//  Response+Result.swift
//  Anvil
//
//  Created by Tyrant on 2020/1/11.
//

import Foundation

import Moya

extension Response {
    
    
    
    /// 是否是网络错误
    /// - Parameters:
    ///   - response: 回应
    ///   - goal: 正常的值
    static func survive(_ response: Response, goal: Int) -> Result<(), AnvilNetError> {
        
        if response.statusCode == goal {
            
            return .success(())
            
        }
        
        return .failure(AnvilNetError.network("网络错误 \(response.statusCode)", response))
    }
    
    
}
