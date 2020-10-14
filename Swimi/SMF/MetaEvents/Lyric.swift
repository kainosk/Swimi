//
//  Lyric.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/15.
//

import Foundation

public struct Lyric: MetaEventParsing, Equatable {
        
    public static func parse<SSType: SequencerSpecific>(
        _ smfBytes: ArraySlice<UInt8>
    ) -> ParseResult<MetaEvent<SSType>> {
        guard smfBytes.prefix(prefix.count) == prefix[...] else {
            return .failure(.length(0))
        }
        
        var bytes = smfBytes.dropFirst(prefix.count)
        guard case let .success(length) = VInt.parse(bytes) else {
            return .failure(.length(smfBytes.count))
        }
        
        bytes = bytes.dropFirst(length.length)
        let data = bytes.prefix(length.component.value)
        return .success(
            ParseSucceeded(
                length: prefix.count + length.length + length.component.value,
                component: .lyric(Array(data))
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        Self.prefix + VInt(data.count).smfBytes + data
    }
    
    public var data: [UInt8]
    
    public init(data: [UInt8]) {
        self.data = data
    }

    
    private static let prefix: [UInt8] = [0xFF, 0x05]
}
