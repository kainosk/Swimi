//
//  TimeCodeQuarterFrame.swift
//  SwiftyMIDIParser
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct TimeCodeQuarterFrame: Equatable {
    /// Message Type
    public var messageType: TimeCodeQuarterFrameMessageType
    
    /// Value: 0 ~ 15
    public var value: UInt8
    
    static func fromData(_ data: [UInt8]) -> Self {
        assert(data.count == 2)
        return TimeCodeQuarterFrame(
            messageType: .fromByte(data[1]),
            value: data[1] & 0b00001111
        )
    }
}
