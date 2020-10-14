//
//  ChannelPressure.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct ChannelPressure: Equatable {
       
    /// Channel Number: 0 ~ 15
    public var channel: Int
    
    /// Pressure: 0 ~ 127
    public var pressure: Int
    
    public var bytes: [UInt8] {
        [
            StatusType.channelPressure.statusByte | UInt8(channel),
            UInt8(pressure),
        ]
    }
    
    public init(channel: Int, pressure: Int) {
        self.channel = channel
        self.pressure = pressure
    }
    
    static func fromData(_ data: [UInt8]) -> ChannelPressure {
        assert(data.count == 2)
        return ChannelPressure(
            channel: Int(data[0] & 0x0F),
            pressure: Int(data[1] & 0x7F)
        )
    }
}
