//
//  ChunkType.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

public enum ChunkType: Equatable, Parsing {
    case header
    case track
    case unknown(String)
    
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<ChunkType> {
        guard smfBytes.count >= 4 else { return failureResult }
        let first4 = Data(smfBytes.prefix(upTo: smfBytes.startIndex + 4))
        // Swift's `String` api never fails to decode any bytes. So we use `!`
        let string = String(data: first4, encoding: .ascii)!
        return .success(
            ParseSucceeded(
                length: 4,
                component: ChunkType(string)
            )
        )
    }
    
    public init(_ string: String) {
        guard string.count == 4 else { fatalError("ChunkType's length must be 4.") }
        let fixedTypes: [ChunkType] = [.header, .track]
        self = fixedTypes.first(where: { $0.identifier == string }) ?? .unknown(string)
    }
    
    public var smfBytes: [UInt8] {
        let id = identifier
        assert(id.count == 4)
        return [UInt8](id.data(using: .ascii)!)
    }
    
    public var identifier: String {
        switch self {
        case .header:                  return "MThd"
        case .track:                   return "MTrk"
        case .unknown(let identifier): return identifier
        }
    }
    
    /// Chunk type is fixed size 4
    private static let failureResult: ParseResult<ChunkType> = .failure(.length(4))
}
