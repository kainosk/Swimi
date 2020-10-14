//
//  UnknownChunk.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/15.
//

import Foundation

public struct UnknownChunk: Equatable {
      
    /// ChunkType is always `.unknown`
    public var type: ChunkType
    
    /// Data (without chunk type and length).
    public var data: [UInt8]
    
    public init(type: ChunkType, data: [UInt8]) {
          self.type = type
          self.data = data
    }
}
