//
//  TimeCodeQuarterFrame.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct TimeCodeQuarterFrame: Equatable {
        
    /// Message Type
    public var messageType: TimeCodeQuarterFrameMessageType
    
    /// Value: 0 ~ 15
    public var value: UInt8
    
    public var bytes: [UInt8] {
        [
            StatusType.timecodeQuarterFrame.statusByte,
            messageType.rawValue << 4 | value,
        ]
    }
    
    public init(messageType: TimeCodeQuarterFrameMessageType, value: UInt8) {
        self.messageType = messageType
        self.value = value
    }

    
    static func fromData(_ data: [UInt8]) -> TimeCodeQuarterFrame {
        assert(data.count == 2)
        return TimeCodeQuarterFrame(
            messageType: .fromByte(data[1]),
            value: data[1] & 0b00001111
        )
    }
}
