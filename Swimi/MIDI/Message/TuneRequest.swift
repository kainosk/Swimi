//
//  TuneRequest.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct TuneRequest: Equatable {

    public var bytes: [UInt8] {
        [
            StatusType.tuneRequest.statusByte,
        ]
    }
    
    public init() {}
    
    static func fromData(_ data: [UInt8]) -> TuneRequest {
        assert(data.count == 1)
        return TuneRequest()
    }
}
