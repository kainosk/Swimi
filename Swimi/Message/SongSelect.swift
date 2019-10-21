//
//  SongSelect.swift
//  Swimi
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public struct SongSelect: Equatable {
    /// Song Number: 0 ~ 127
    public var songNumber: UInt8
    
    static func fromData(_ data: [UInt8]) -> SongSelect {
        assert(data.count == 2)
        return SongSelect(songNumber: data[1] & 0x7F)
    }
}
