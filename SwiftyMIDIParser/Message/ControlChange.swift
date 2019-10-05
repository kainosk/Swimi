//
//  ControlChange.swift
//  SwiftyMIDIParser
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct ControlChange: Equatable {
    /// Channel Number: 0 ~ 15
    public var channel: Int
    
    /// Control Number
    public var controlNumber: ControlNumber
    
    /// Value
    public var value: Int
    
    static func fromData(_ data: [UInt8]) -> ControlChange {
        assert(data.count == 3)
        return ControlChange(
            channel: Int(data[0] & 0x0F),
            controlNumber: ControlNumber(rawValue: data[1])!,
            value: Int(data[2] & 0x7F)
        )
    }
}
