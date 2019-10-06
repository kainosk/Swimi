//
//  PitchBendChange.swift
//  Swimi
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct PitchBendChange: Equatable {
    /// Channel Number: 0 ~ 15
    public var channel: Int
    
    /// Value LSB
    public var lsb: UInt8
    
    /// Value MSB
    public var msb: UInt8
    
    /// Value
    public var value: Int {
        return (Int(lsb) & 0x7F) + ((Int(msb & 0x7F) << 7))
    }
    
    static func fromData(_ data: [UInt8]) -> Self {
        assert(data.count == 3)
        return PitchBendChange(
            channel: Int(data[0] & 0x0F),
            lsb: data[1] & 0x7F,
            msb: data[2] & 0x7F
        )
    }
}
