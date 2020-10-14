//
//  TimingClock.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct TimingClock: Equatable {
    
    public var bytes: [UInt8] {
        [
            StatusType.timingClock.statusByte,
        ]
    }
    
    public init() {}
    
    static func fromData(_ data: [UInt8]) -> TimingClock {
        assert(data.count == 1)
        return TimingClock()
    }
}
