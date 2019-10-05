//
//  SongPositionPointer.swift
//  SwiftyMIDIParser
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct SongPositionPointer: Equatable {
    /// LSB
    public var lsb: UInt8
    
    /// MSB
    public var msb: UInt8
    
    static func fromData(_ data: [UInt8]) -> Self {
        assert(data.count == 3)
        return SongPositionPointer(lsb: data[1], msb: data[2])
    }
}
