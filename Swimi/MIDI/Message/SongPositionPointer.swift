//
//  SongPositionPointer.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct SongPositionPointer: Equatable {
    
    /// LSB
    public var lsb: UInt8
    
    /// MSB
    public var msb: UInt8
    
    public var bytes: [UInt8] {
        [
            StatusType.songPositionPointer.statusByte,
            lsb,
            msb,
        ]
    }
    
    public init(lsb: UInt8, msb: UInt8) {
        self.lsb = lsb
        self.msb = msb
    }

    
    static func fromData(_ data: [UInt8]) -> SongPositionPointer {
        assert(data.count == 3)
        return SongPositionPointer(lsb: data[1], msb: data[2])
    }
}
