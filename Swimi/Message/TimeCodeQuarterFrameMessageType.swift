//
//  TimeCodeQuarterFrameMessageType.swift
//  Swimi
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public enum TimeCodeQuarterFrameMessageType: UInt8 {
    case frameCountLower4bit = 0
    case frameCountUpper4bit = 1
    case secondCountLower4bit = 2
    case secondCountUpper4bit = 3
    case minuteCountLower4bit = 4
    case minuteCountUpper4bit = 5
    case timeCountLower4bit = 6
    case timeCountUpper4bit = 7
    
    static func fromByte(_ byte: UInt8) -> TimeCodeQuarterFrameMessageType {
        let value = (byte >> 4) & 0b0111
        return TimeCodeQuarterFrameMessageType(rawValue: value)!
    }
}
