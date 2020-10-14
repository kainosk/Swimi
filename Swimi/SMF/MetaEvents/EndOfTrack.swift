//
//  EndOfTrack.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/16.
//

import Foundation

public struct EndOfTrack: MetaEventParsing, Equatable {
    public static func parse<SSType>(
        _ smfBytes: ArraySlice<UInt8>
    ) -> ParseResult<MetaEvent<SSType>> {
        guard smfBytes.prefix(prefix.count) == prefix[...] else {
            return .failure(.length(0))
        }
        return .success(
            ParseSucceeded(
                length: 3,
                component: .endOfTrack()
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        Self.prefix
    }
    
    public init() {}
    
    private static let prefix: [UInt8] = [0xFF, 0x2F, 0x00]
}
