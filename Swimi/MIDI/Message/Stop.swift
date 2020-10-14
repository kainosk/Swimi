//
//  Stop.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/06.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct Stop: Equatable {

    public var bytes: [UInt8] {
        [
            StatusType.stop.statusByte,
        ]
    }
    
    public init() {}
    
    static func fromData(_ data: [UInt8]) -> Stop {
        assert(data.count == 1)
        return Stop()
    }
}
