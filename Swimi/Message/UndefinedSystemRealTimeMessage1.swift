//
//  UndefinedSystemRealTimeMessage1.swift
//  Swimi
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct UndefinedSystemRealTimeMessage1: Equatable {
    
    static func fromData(_ data: [UInt8]) -> Self {
        return UndefinedSystemRealTimeMessage1()
    }
}

