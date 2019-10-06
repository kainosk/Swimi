//
//  SystemExclusive.swift
//  Swimi
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct SystemExclusive: Equatable {
    
    /// Raw data of this System Exclusive Message.
    /// This data includes  `F0` as first element and  `F7` as last element.
    public var rawData: [UInt8]
    
    static func fromData(_ data: [UInt8]) -> Self {
        return SystemExclusive(rawData: data)
    }
}
