//
//  KeySignature.swift
//  Swimi
//
//  Created by kai on 2020/09/07.
//

import Foundation

public struct KeySignature: MetaEventParsing, Equatable {
    
    /// Number of shaprs or flats. (-7 ~ 0 ~ +7)
    ///
    /// * flat: negative value
    /// * sharp: positive value
    public var numberOfSharpsOrFlats: Int {
        willSet {
            Self.checkNumberOfSharpsOrFlatsRange(newValue)
        }
    }
    
    public enum Mode {
        case major
        case minor
        
        /// From smf integer value.
        ///
        /// * 0 -> major
        /// * 1 -> minor
        /// * others (error case) -> nil
        public init?(smfValue: UInt8) {
            switch smfValue {
            case 0: self = .major
            case 1: self = .minor
            default: return nil
            }
        }
        
        public var smfValue: UInt8 {
            switch self {
            case .major: return 0
            case .minor: return 1
            }
        }
    }
    
    public var mode: Mode
    
    public init(numberOfSharpsOrFlats: Int, mode: Mode) {
        Self.checkNumberOfSharpsOrFlatsRange(numberOfSharpsOrFlats)
        self.numberOfSharpsOrFlats = numberOfSharpsOrFlats
        self.mode = mode
    }
    
    public static func parse<SSType: SequencerSpecific>(
        _ smfBytes: ArraySlice<UInt8>
    ) -> ParseResult<MetaEvent<SSType>> {
        guard smfBytes.prefix(prefix.count) == prefix[...] else {
            return .failure(.length(0))
        }
        
        let bytes = smfBytes.dropFirst(prefix.count)
        let numberOfSharpOrFlats = Int8(bitPattern: bytes[bytes.startIndex])
        guard (-7...7).contains(numberOfSharpOrFlats) else {
            return .failure(.length(5))
        }
        guard let mode = Mode(smfValue: bytes[bytes.startIndex + 1]) else {
            return .failure(.length(5))
        }
        
        return .success(
            ParseSucceeded(
                length: prefix.count + 2,
                component: .keySignature(
                    numberOfSharpsOrFlats: Int(numberOfSharpOrFlats),
                    mode: mode
                )
            )
        )
        
    }
    
    public var smfBytes: [UInt8] {
        Self.prefix + [
            UInt8(bitPattern: Int8(numberOfSharpsOrFlats)),
            mode.smfValue
        ]
    }
    
    
    private static let prefix: [UInt8] = [0xFF, 0x59, 0x02]
    private static func checkNumberOfSharpsOrFlatsRange(_ v: Int) {
        guard (-7...7).contains(v) else {
            fatalError("numberOfSharpsOrFlats must be -7 ~ 0 ~ +7")
        }
    }
}
