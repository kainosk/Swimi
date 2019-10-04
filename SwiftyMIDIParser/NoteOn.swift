//
//  NoteOn.swift
//  SwiftyMIDIParser
//
//  Created by kai on 2019/10/05.
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
    
    static func fromData(_ data: [UInt8]) -> NoteOn {
        assert(data.count == 3)
        return NoteOn(
            channel: Int(data[0] & 0x0F),
            note: Int(data[1] & 0x7F),
            velocity: Int(data[2] & 0x7F)
        )
    }
}
