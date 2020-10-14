//
//  VInt.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//  Copyright © 2020 kai. All rights reserved.
//

import Foundation

/// SMF's Variable Length Integer
public struct VInt: Equatable, Parsing {
    
    public let value: Int
    public var smfBytes: [UInt8] {
        var bytes: [UInt8] = []
        var v = value
        var first = true
        while true {
            let sevenBit = v & 0b01111111
            let b = first ? sevenBit : sevenBit | 0b10000000
            bytes.append(UInt8(b))
            v = v >> 7
            first = false
            if v == 0 {
                break
            }
        }
        return bytes.reversed()
    }
    
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<VInt> {
        guard !smfBytes.isEmpty else { return .failure(.length(0)) }
        var i = 0
        var value = 0
        var msb0Detected = false
        for byte in smfBytes {
            value = value << 7
            value = value | Int(byte & 0b01111111)
            i += 1
            if byte & 0b10000000 == 0 {
                msb0Detected = true
                break
            }
        }
        guard msb0Detected else { return .failure(.length(smfBytes.count)) }
        return .success(
            ParseSucceeded(
                length: i,
                component: VInt(value)
            )
        )
    }
    
    public init(_ value: Int) {
        self.value = value
    }
}
