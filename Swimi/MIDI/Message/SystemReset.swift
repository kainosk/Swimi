//
//  SystemReset.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/06.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct SystemReset: Equatable {

    public var bytes: [UInt8] {
        [
            StatusType.systemReset.statusByte,
        ]
    }
    
    public init() {}
    
    static func fromData(_ data: [UInt8]) -> SystemReset {
        assert(data.count == 1)
        return SystemReset()
    }
}
