//
//  Parser.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public class Parser {
    public func input(data: [UInt8]) {
        data.forEach(parseByte)
    }
    
    public init() {
        
    }
    
    private var parsing: Bool = false
    private var lastStatus: StatusType?
    private var lastStatusByte: UInt8?
    public let notifier: Notifier = Notifier()
    
    private var parsingData: [UInt8] = []
    
    private func parseByte(_ byte: UInt8) {
        let statusOrNil = StatusType.fromByte(byte)
        if let status = statusOrNil, status.isSystemRealTimeMessage {
            // System Real Time Message is 1 byte and can interrupt any messages.
            // So we'll notify this Real Time Message immediately and keep current status.
            notifier.notify(messageData: [byte])
            return
        }
        
        switch (parsing, lastStatus, statusOrNil) {
        case (true, .some(.systemExclusive), .some(.endOfExclusive)):
            // parsing exclusive and receive end of exclusive -> notify
            parsingData.append(byte)
            notifier.notify(messageData: parsingData)
            clearData()
            return
        case (_, _, .some(.endOfExclusive)):
            // error case:
            // End Of Exclusive received but not parsing System Exclusive now.
            // We will just ignore this.
            clearData()
            return
            
        case (true, nil, _):
            // impossible condition
            fatalError()
        
        case (false, nil, nil):
            // Received unkown byte before receiving StatusByte. So we'll ignore this byte.
            return
        
        case (false, nil, .some(_)):
            // Received 1st status. So start parsing 1st message.
            gotMessageByte(status: byte, data: nil)
            
        case (false, .some(_), nil):
            // Maybe running status. So start parse with previous status.
            gotMessageByte(status: lastStatusByte!, data: byte)
            
        case (false, .some(_), .some(_)):
            // Received new status. So start parse with new status.
            gotMessageByte(status: byte, data: nil)
        
        case (true, .some(_), nil):
            // Received new data byte.
            gotMessageByte(status: nil, data: byte)
            
        case (true, .some(_), .some(_)):
            // Receiving new Status while parsing current Status.
            // This indicates the sequence is invalid.
            // Obviously this is MIDI protocol violation. But we'll clear current status
            // and continue to parse new status instead of crash.
            // Or, We can consider some handler to notify protocol violation detection...
            clearData()
            gotMessageByte(status: byte, data: nil)
        }
    }
    
    private func clearData() {
        parsingData = []
        parsing = false
    }
    
    private func gotMessageByte(status: UInt8?, data: UInt8?) {
        parsing = true
        
        if let status = status {
            lastStatusByte = status
            lastStatus = StatusType.fromByte(status)!
            parsingData.append(status)
        }
        if let data = data {
            parsingData.append(data)
        }
        
        if case .fixed(let dataSize) = lastStatus!.dataByteSize {
            if (parsingData.count - 1) == dataSize {
                notifier.notify(messageData: parsingData)
                clearData()
            }
        }
    }
}



