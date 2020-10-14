//
//  NoteOn.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct NoteOn: Equatable {

    /// Channel Number: 0 ~ 15
    public var channel: Int
    
    /// Note Number: 0 ~ 127
    public var note: Int

    /// Velocity: 0 ~ 127
    public var velocity: Int
    
    public var bytes: [UInt8] {
        [
            StatusType.noteOn.statusByte | UInt8(channel),
            UInt8(note),
            UInt8(velocity)
        ]
    }
    
    public init(channel: Int, note: Int, velocity: Int) {
        self.channel = channel
        self.note = note
        self.velocity = velocity
    }
    
    static func fromData(_ data: [UInt8]) -> NoteOn {
        assert(data.count == 3)
        return NoteOn(
            channel: Int(data[0] & 0x0F),
            note: Int(data[1] & 0x7F),
            velocity: Int(data[2] & 0x7F)
        )
    }
}
