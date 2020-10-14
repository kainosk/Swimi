//
//  UndefinedSystemRealTimeMessage2.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct UndefinedSystemRealTimeMessage2: Equatable {
    
    public var bytes: [UInt8] {
        [
            StatusType.undefinedSystemRealTimeMessage2.statusByte,
        ]
    }
    
    public init() {}
    
    static func fromData(_ data: [UInt8]) -> UndefinedSystemRealTimeMessage2 {
        return UndefinedSystemRealTimeMessage2()
    }
}

