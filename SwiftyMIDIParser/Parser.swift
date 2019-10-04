//
//  Parser.swift
//  SwiftyMIDIParser
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public class Parser {
    public func input(data: [UInt8]) {
        data.forEach { byte in
            let statusOrNil = StatusType.fromByte(byte)
            if let status = statusOrNil {
                if status.isSystemRealTimeMessage {
                    notifier.notify(messageData: [byte])
                    return
                }
            }
            if !parsing {
                segmentator.reset()
                if statusOrNil != nil  {
                    lastStatus = byte
                } else {
                    // if `RunningStatus`, we have to put last status byte.
                    _ = segmentator.input(byte: lastStatus!)
                }
                parsing = true
            }
            if let message = segmentator.input(byte: byte) {
                parsing = false
                notifier.notify(messageData: message)
            }
        }
    }
    
    public init() {
        
    }
    
    private var parsing: Bool = false
    private var lastStatus: UInt8?
    private let segmentator: Segmentator = Segmentator()
    public let notifier: Notifier = Notifier()
}



