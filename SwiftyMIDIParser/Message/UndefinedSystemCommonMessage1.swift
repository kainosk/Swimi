//
//  UndefinedSystemCommonMessage1.swift
//  SwiftyMIDIParser
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct UndefinedSystemCommonMessage1: Equatable {
    
    static func fromData(_ data: [UInt8]) -> Self {
        return UndefinedSystemCommonMessage1()
    }
}
