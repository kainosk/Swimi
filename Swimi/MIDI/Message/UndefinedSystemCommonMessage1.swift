//
//  UndefinedSystemCommonMessage1.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct UndefinedSystemCommonMessage1: Equatable {
    
    public var bytes: [UInt8] {
        [
            StatusType.undefinedSystemCommonMessage1.statusByte,
        ]
    }
    
    public init() {}
    
    static func fromData(_ data: [UInt8]) -> UndefinedSystemCommonMessage1 {
        return UndefinedSystemCommonMessage1()
    }
}
