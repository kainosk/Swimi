//
//  ProgramChange.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct ProgramChange: Equatable {
        
    /// Channel Number: 0 ~ 15
    public var channel: Int
    
    /// Program Number: 0 ~ 127
    public var program: Int
    
    public var bytes: [UInt8] {
        [
            StatusType.programChange.statusByte | UInt8(channel),
            UInt8(program),
        ]
    }
    
    public init(channel: Int, program: Int) {
        self.channel = channel
        self.program = program
    }

    
    static func fromData(_ data: [UInt8]) -> ProgramChange {
        assert(data.count == 2)
        return ProgramChange(
            channel: Int(data[0] & 0x0F),
            program: Int(data[1] & 0x7F)
        )
    }
}
