//
//  SystemReset.swift
//  Swimi
//
//  Created by kai on 2019/10/06.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct SystemReset: Equatable {
    
    static func fromData(_ data: [UInt8]) -> SystemReset {
        assert(data.count == 1)
        return SystemReset()
    }
}
