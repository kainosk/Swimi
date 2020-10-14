//
//  Util.swift
//  SwimiTests
//
//  Created by kai on 2020/09/11.
//

import Foundation
@testable import Swimi

/// Dummy SequencerSpecific type.
struct SS: SequencerSpecific {
    static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<SS> {
        fatalError()
    }
    var smfBytes: [UInt8] {
        // fake data
        return [0x00, 0x11, 0x22, 0x33]
    }
}


struct AlwaysFailing: SequencerSpecific {
    static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<AlwaysFailing> {
        return .failure(.length(0))
    }
    var smfBytes: [UInt8] { fatalError() }
}

struct AlwaysSuccessing: SequencerSpecific {
    let data: [UInt8]
    static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<AlwaysSuccessing> {
        return .success(
            ParseSucceeded(
                length: smfBytes.count,
                component: AlwaysSuccessing(data: Array(smfBytes))
            )
        )
    }
    var smfBytes: [UInt8] { fatalError() }
}
