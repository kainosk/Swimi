//
//  MultiByteInt.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

extension Int {
    static func fromBytes(_ bytes: ArraySlice<UInt8>, length: Int) -> Int? {
        guard bytes.count >= length else { return nil }
        let prefixBytes = bytes.prefix(upTo: bytes.startIndex + length)
        var v = 0
        var shift = 8 * (length - 1)
        for byte in prefixBytes {
            v += Int(byte) << shift
            shift -= 8
        }
        return v
    }
    
    static func fromBytes(_ bytes: [UInt8], length: Int) -> Int? {
        return fromBytes(bytes[...], length: length)
    }
    
    func toBytes(length: Int) -> [UInt8] {
        return (0..<length)
            .map {
                UInt8((self >> (8 * $0)) & 0xFF)
            }
            .reversed()
    }
}
