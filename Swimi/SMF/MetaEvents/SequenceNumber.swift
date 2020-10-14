//
//  SequenceNumber.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/04.
//

import Foundation

public struct SequenceNumber: MetaEventParsing, Equatable {
    
    public static func parse<SSType: SequencerSpecific>(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<MetaEvent<SSType>> {
        guard smfBytes.prefix(prefix.count) == prefix[...] else {
            return .failure(.length(0))
        }
        let bytes = smfBytes.dropFirst(prefix.count)
        guard let value = Int.fromBytes(bytes, length: 2) else {
            return .failure(.length(smfBytes.count))
        }
        
        return .success(
            ParseSucceeded(
                length: prefix.count + 2,
                component: .sequenceNumber(value)
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        return Self.prefix + value.toBytes(length: 2)
    }
    
    public var value: Int
    
    public init(_ value: Int) {
        guard value <= 0xFFFF else {
            fatalError("Sequence Nubmer must be 2 bytes integer.")
        }
        self.value = value
    }
    
    private static let prefix: [UInt8] = [0xFF, 0x00, 0x02]
}
