//
//  PolyphonicKeyPressure.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct PolyphonicKeyPressure: Equatable {
        
    /// Channel Number: 0 ~ 15
    public var channel: Int
    
    /// Note Number: 0 ~ 127
    public var note: Int
    
    /// Pressure: 0 ~ 127
    public var pressure: Int
    
    public var bytes: [UInt8] {
        [
            StatusType.polyphonicKeyPressure.statusByte | UInt8(channel),
            UInt8(note),
            UInt8(pressure),
        ]
    }
    
    public init(channel: Int, note: Int, pressure: Int) {
        self.channel = channel
        self.note = note
        self.pressure = pressure
    }

    
    static func fromData(_ data: [UInt8]) -> PolyphonicKeyPressure {
        assert(data.count == 3)
        return PolyphonicKeyPressure(
            channel: Int(data[0] & 0x0F),
            note: Int(data[1] & 0x7F),
            pressure: Int(data[2] & 0x7F)
        )
    }
}
