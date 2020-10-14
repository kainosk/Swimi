//
//  F7SysExEvent.swift
//  Swimi
//
//  Created by kai on 2020/08/27.
//

import Foundation

public struct F7SysExEvent: Parsing, Equatable {
    
    public var data: [UInt8]
    
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<F7SysExEvent> {
        guard smfBytes.prefix(prefix.count) == prefix[...] else {
            return .failure(.length(0))
        }
        var bytes = smfBytes.dropFirst(prefix.count)
        switch VInt.parse(bytes) {
        case .failure(let failure):
            return .failure(.length(prefix.count + failure.length))
            
        case .success(let success):
            bytes = bytes.dropFirst(success.length)
            let dataLength = success.component.value
            let data = bytes.prefix(dataLength)
            guard data.count == dataLength else {
                return .failure(.length(smfBytes.count))
            }
            return .success(
                ParseSucceeded(
                    length: prefix.count + success.length + data.count,
                    component: F7SysExEvent(data: Array(data))
                )
            )
        }
    }
    
    public var smfBytes: [UInt8] {
        Self.prefix + VInt(data.count).smfBytes + data
    }
    
    public init(data: [UInt8]) {
        self.data = data
    }
    
    private static let prefix: [UInt8] = [0xF7]
}
