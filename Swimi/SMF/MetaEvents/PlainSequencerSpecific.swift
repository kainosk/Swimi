//
//  PlainSequencerSpecific.swift
//  Swimi
//
//  Created by kai on 2020/09/07.
//

import Foundation

public struct PlainSequencerSpecific: SequencerSpecific, Equatable {
    public static func parse(
        _ smfBytes: ArraySlice<UInt8>
    ) -> ParseResult<PlainSequencerSpecific> {
        
        guard smfBytes.prefix(prefix.count) == prefix[...] else {
            return .failure(.length(0))
        }
        var bytes = smfBytes.dropFirst(prefix.count)
        guard case let .success(lengthResult) = VInt.parse(bytes) else {
            return .failure(.length(smfBytes.count))
        }
        bytes = bytes.dropFirst(lengthResult.length)
        let dataLength = lengthResult.component.value
        guard bytes.count >= dataLength else {
            return .failure(.length(smfBytes.count))
        }
        
        let data = bytes.prefix(dataLength)
        return .success(
            ParseSucceeded(
                length: prefix.count + lengthResult.length + data.count,
                component: PlainSequencerSpecific(dataWithoutPrefix: Array(data))
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        Self.prefix + VInt(data.count).smfBytes + data
    }
    
    public var data: [UInt8]
    
    /// Initialize with data without prefix `0xFF, 0x7F`.
    public init(dataWithoutPrefix data: [UInt8]) {
        self.data = data
    }
    
    private static let prefix: [UInt8] = [0xFF, 0x7F]
}
