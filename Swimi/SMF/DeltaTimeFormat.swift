//
//  DeltaTimeFormat.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

public enum DeltaTimeFormat: Equatable, Parsing {
    case ticksPerQuarterNote(Int)
    
    /// Currently this format is not supported.
    case smpte
    
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<DeltaTimeFormat> {
        guard smfBytes.count >= 2 else {
            return .failure(.length(smfBytes.count))
        }
        let isQuarterNoteTicks = smfBytes.first! & 0b10000000 == 0
        let f: DeltaTimeFormat
        
        if isQuarterNoteTicks {
            let bytes: [UInt8] = [
                smfBytes[smfBytes.startIndex] & 0b0111111,
                smfBytes[smfBytes.startIndex + 1]
            ]
            f = .ticksPerQuarterNote(Int.fromBytes(bytes, length: 2)!)
        } else {
            f = .smpte
        }
        
        return .success(
            ParseSucceeded(
                length: Self.length,
                component: f
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        switch self {
        case .ticksPerQuarterNote(let v):
            let bytes = v.toBytes(length: 2)
            return bytes
        case .smpte:
            fatalError("Currently this format `SMPTE` is not supported.")
        }
    }
    
    /// Delta time format is fixed size 2
    private static let length: Int = 2
    private static let failureResult: ParseResult<DeltaTimeFormat> =
        .failure(.length(Self.length))
}
