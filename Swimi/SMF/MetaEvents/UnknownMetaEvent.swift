//
//  UnknownMetaEvent.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/16.
//

import Foundation

/// This can parse all meta event.
public struct UnknownMetaEvent: MetaEventParsing, Equatable {
    
    public static func parse<SSType: SequencerSpecific>(
        _ smfBytes: ArraySlice<UInt8>) -> ParseResult<MetaEvent<SSType>>
    {
        switch parseBody(smfBytes: smfBytes) {
        case .failure(let f):
            return .failure(.length(f.length))
        case .success(let s):
            return .success(
                ParseSucceeded(
                    length: s.length,
                    component: .unknown(
                        UnknownMetaEvent(smfBytes: s.component)
                    )
                )
            )
        }
    }
    
    public static func parseBody(smfBytes: ArraySlice<UInt8>) -> ParseResult<[UInt8]> {
        guard smfBytes.count >= 3 && smfBytes.first == 0xFF else {
            return .failure(.length(0))
        }
        
        /// ignore meta event type
        let bytes = smfBytes.dropFirst(2)
        guard case let .success(length) = VInt.parse(bytes) else {
            return .failure(.length(smfBytes.count))
        }
        let eventLength = 2 + length.length + length.component.value
        guard smfBytes.count >= eventLength else {
            return .failure(.length(smfBytes.count))
        }
        return .success(
            ParseSucceeded(
                length: 2 + length.length + length.component.value,
                component: Array(smfBytes.prefix(eventLength))
            )
        )
    }
    
    public var smfBytes: [UInt8]
    
    public init(smfBytes: [UInt8]) {
        self.smfBytes = smfBytes
    }
    
}
