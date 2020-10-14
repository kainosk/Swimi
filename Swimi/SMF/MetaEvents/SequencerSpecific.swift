//
//  SequencerSpecific.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/15.
//

import Foundation

public protocol SequencerSpecific: Equatable {
    static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<Self>
    var smfBytes: [UInt8] { get }
}

