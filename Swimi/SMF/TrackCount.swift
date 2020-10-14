//
//  TrackCount.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

public struct TrackCount: Equatable, Parsing {
    
    public var numberOfTracks: Int

    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<TrackCount> {
        guard let v = Int.fromBytes(smfBytes, length: Self.length) else {
            return .failure(.length(smfBytes.count))
        }
        return .success(
            ParseSucceeded(
                length: Self.length,
                component: TrackCount(v)
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        return numberOfTracks.toBytes(length: 2)
    }
    
    public init(_ numberOfTracks: Int) {
        self.numberOfTracks = numberOfTracks
    }
    
    private static let length: Int = 2
}
