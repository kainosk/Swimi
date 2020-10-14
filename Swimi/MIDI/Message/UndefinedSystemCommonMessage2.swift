//
//  UndefinedSystemCommonMessage2.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct UndefinedSystemCommonMessage2: Equatable {
    
    public var bytes: [UInt8] {
        [
            StatusType.undefinedSystemCommonMessage2.statusByte,
        ]
    }
    
    public init() {}
    
    static func fromData(_ data: [UInt8]) -> UndefinedSystemCommonMessage2 {
        return UndefinedSystemCommonMessage2()
    }
}
