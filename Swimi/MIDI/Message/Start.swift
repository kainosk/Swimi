//
//  Start.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/06.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct Start: Equatable {
    
    public var bytes: [UInt8] {
        [
            StatusType.start.statusByte,
        ]
    }
    
    public init() {}
    
    static func fromData(_ data: [UInt8]) -> Start {
        assert(data.count == 1)
        return Start()
    }
}
