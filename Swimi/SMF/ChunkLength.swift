//
//  ChunkLength.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

public struct ChunkLength: Equatable, Parsing {
    
    public let value: Int
    
    public var smfBytes: [UInt8] {
        value.toBytes(length: Self.length)
    }
    
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<Self> {
        guard let v = Int.fromBytes(smfBytes, length: Self.length) else {
            return .failure(.length(smfBytes.count))
        }
        return .success(
            ParseSucceeded(
                length: Self.length,
                component: ChunkLength(v)
            )
        )
    }
    
    public init(_ value: Int) {
        self.value = value
    }
    
    /// Chunk's Length is represented by 4 bytes
    private static let length = 4
    private static let failedResult: ParseResult<ChunkLength> = .failure(.length(length))
}
