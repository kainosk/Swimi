//
//  SetTempo.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/16.
//

import Foundation

public struct SetTempo: MetaEventParsing, Equatable {
    public static func parse<SSType>(
        _ smfBytes: ArraySlice<UInt8>
    ) -> ParseResult<MetaEvent<SSType>> {
        guard smfBytes.prefix(prefix.count) == prefix[...] else {
            return .failure(.length(0))
        }
        let bytes = smfBytes.dropFirst(prefix.count)
        guard let value = Int.fromBytes(bytes, length: 3) else {
            return .failure(.length(smfBytes.count))
        }
        return .success(
            ParseSucceeded(
                length: prefix.count + 3,
                component: .setTempo(microsecondsPerQuarterNote: value)
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        Self.prefix + microsecondsPerQuarterNote.toBytes(length: 3)
    }
    
    public var microsecondsPerQuarterNote: Int {
        set {
            bpm = 1_000_000 / Double(newValue) * 60
        }
        get {
            Int(
                round(1_000_000 / (bpm / 60))
            )
        }
    }
    public var bpm: Double = 120
    
    public init(bpm: Double) {
        self.bpm = bpm
    }
    
    public init(microsecondsPerQuarterNote: Int) {
        self.microsecondsPerQuarterNote = microsecondsPerQuarterNote
    }
    
    private static let prefix: [UInt8] = [0xFF, 0x51, 0x03]
    
    
}
