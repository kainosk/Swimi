//
//  TuneRequest.swift
//  SwiftyMIDIParser
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct TuneRequest: Equatable {
    
    static func fromData(_ data: [UInt8]) -> Self {
        assert(data.count == 1)
        return TuneRequest()
    }
}
