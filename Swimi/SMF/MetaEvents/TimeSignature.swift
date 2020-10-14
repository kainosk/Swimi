//
//  TimeSignature.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/16.
//

import Foundation

public struct TimeSignature: MetaEventParsing, Equatable {
    
    public static let standardFourFour: TimeSignature = TimeSignature(
        numerator: 4,
        denominator: 4,
        midiClocksPerMetronomeClick: 24,
        thirtySecondNotesPer24MIDIClocks: 8
    )
    
    public static let standardThreeFour: TimeSignature = TimeSignature(
        numerator: 3,
        denominator: 4,
        midiClocksPerMetronomeClick: 24,
        thirtySecondNotesPer24MIDIClocks: 8
    )
    
    public static let standardTwoTwo: TimeSignature = TimeSignature(
        numerator: 2,
        denominator: 2,
        midiClocksPerMetronomeClick: 24,
        thirtySecondNotesPer24MIDIClocks: 8
    )
    
    public static func parse<SSType: SequencerSpecific>(
        _ smfBytes: ArraySlice<UInt8>
    ) -> ParseResult<MetaEvent<SSType>> {
        guard smfBytes.prefix(prefix.count) == prefix[...] else {
            return .failure(.length(0))
        }
        
        var bytes = smfBytes.dropFirst(prefix.count)
        let failure = ParseResult<MetaEvent<SSType>>.failure(.length(smfBytes.count))
        
        guard let n = Int.fromBytes(bytes, length: 1) else {
            return failure
        }
        bytes = bytes.dropFirst(1)
        guard let d = Int.fromBytes(bytes, length: 1) else {
            return failure
        }
        bytes = bytes.dropFirst(1)
        guard let c = Int.fromBytes(bytes, length: 1) else {
            return failure
        }
        bytes = bytes.dropFirst(1)
        guard let b = Int.fromBytes(bytes, length: 1) else {
            return failure
        }
        
        return .success(
            ParseSucceeded(
                length: prefix.count + 4,
                component: .timeSignature(
                    numerator: n,
                    denominatorPowerOfTwo: d,
                    midiClocksPerMetronomeClick: c,
                    thirtySecondNotesPer24MIDIClocks: b
                )
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        Self.prefix +
            numerator.toBytes(length: 1) +
            denominatorPowerOfTwo.toBytes(length: 1) +
            midiClocksPerMetronomeClick.toBytes(length: 1) +
            thirtySecondNotesPer24MIDIClocks.toBytes(length: 1)
    }
    
    public var numerator: Int = 4
    public var denominator: Int = 4
    public var denominatorPowerOfTwo: Int {
        set {
            denominator = Int(pow(2.0, Double(newValue)))
        }
        get {
            Int(log2(Double(denominator)))
        }
    }
    public var midiClocksPerMetronomeClick: Int
    public var thirtySecondNotesPer24MIDIClocks: Int
    
    public init(
        numerator: Int,
        denominatorPowerOfTwo: Int,
        midiClocksPerMetronomeClick: Int,
        thirtySecondNotesPer24MIDIClocks: Int
    ) {
        self.midiClocksPerMetronomeClick = midiClocksPerMetronomeClick
        self.thirtySecondNotesPer24MIDIClocks = thirtySecondNotesPer24MIDIClocks
        self.numerator = numerator
        self.denominatorPowerOfTwo = denominatorPowerOfTwo
    }
    
    public init(
        numerator: Int,
        denominator: Int,
        midiClocksPerMetronomeClick: Int,
        thirtySecondNotesPer24MIDIClocks: Int
    ) {
        self.midiClocksPerMetronomeClick = midiClocksPerMetronomeClick
        self.thirtySecondNotesPer24MIDIClocks = thirtySecondNotesPer24MIDIClocks
        self.numerator = numerator
        self.denominator = convertToNearestPowerOfTwo(denominator)
    }
    
    private static let prefix: [UInt8] = [0xFF, 0x58, 0x04]
}

fileprivate func convertToNearestPowerOfTwo(_ original: Int) -> Int {
    let p = round(
        log2(Double(original))
    )
    
    return Int(pow(2, p))
}
