//
//  Segmentator.swift
//  SwiftyMIDIParser
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

class Segmentator {
    
    func input(byte: UInt8) -> [UInt8]? {
        let status = StatusType.fromByte(byte)
        if focusingDataSize == nil {
            focusingDataSize = status?.dataByteSize
        }
        
        message.append(byte)
        
        switch focusingDataSize! {
            
        case .fixed(let size):
            if message.count - 1 == size {
                return message
            }
        case .variable:
            if status == .endOfExclusive {
                return message
            }
        }
        
        return nil
    }
    
    func reset() {
        message = [UInt8]()
    }

    init() {
        
    }
    
    private var focusingDataSize: DataSize?
    private var message: [UInt8] = []
}
