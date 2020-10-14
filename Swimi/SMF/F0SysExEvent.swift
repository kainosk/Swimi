//
//  SysExEvent.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/03.
//

import Foundation

/// This represent `F0` style SysEx event. There is another `F7` style SysEx event.
public struct F0SysExEvent: Parsing, Equatable {
    
    /// Data of this SysEx Event.
    ///
    /// This data contains `F0` (SysEx start byte) at first element (data[0]).
    /// Depending on original data, the terminal `F7` may or may not exists. This struct
    /// does not care about its correctness because there is another SysEx format
    /// beginning with `F7`. With `F7` style message, SysEx message can be split into
    /// multiple messages.
    public var data: [UInt8] {
        willSet {
            Self.checkFirstByteIsF0(newValue)
        }
    }
    
    public init(dataIncludingFirstF0 firstF0Data: [UInt8]) {
        Self.checkFirstByteIsF0(firstF0Data)
        self.data = firstF0Data
    }
    
    public init(dataWithoutFirstF0: [UInt8]) {
        self.data = [0xF0] + dataWithoutFirstF0
    }
    
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<F0SysExEvent> {
        
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
                    component: F0SysExEvent(dataWithoutFirstF0: Array(data))
                )
            )
        }
    }
    
    public var smfBytes: [UInt8] {
        let body = data.dropFirst()
        return Self.prefix + VInt(body.count).smfBytes + body
    }
    
    private static let prefix: [UInt8] = [0xF0]
    
    private static func checkFirstByteIsF0(_ bytes: [UInt8]) {
        if let first = bytes.first {
            if first != 0xF0 {
                fatalError("first byte must be F0")
            }
        }
    }
}
