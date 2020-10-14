//
//  HeaderChunk.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

public struct HeaderChunk: Equatable, Parsing {
    
    public var type: ChunkType
    public var format: Format
    public var trackCount: TrackCount
    public var deltaTimeFormat: DeltaTimeFormat
    
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<HeaderChunk> {
        var bytes = smfBytes
        
        let format: Format!
        switch Format.parse(bytes) {
        case .failure(_):
            return .failure(.length(smfBytes.count))
        case .success(let s):
            format = s.component
            bytes = bytes.dropFirst(s.length)
        }
        
        let trackCount: TrackCount!
        switch TrackCount.parse(bytes) {
        case .failure(_):
            return .failure(.length(smfBytes.count))
        case .success(let s):
            trackCount = s.component
            bytes = bytes.dropFirst(s.length)
        }
        
        let deltaTimeFormat: DeltaTimeFormat!
        switch DeltaTimeFormat.parse(bytes) {
        case .failure(_):
            return .failure(.length(smfBytes.count))
        case .success(let s):
            deltaTimeFormat = s.component
        }
        
        return .success(
            ParseSucceeded(
                length: Self.length,
                component: HeaderChunk(
                    format: format,
                    trackCount: trackCount,
                    deltaTimeFormat: deltaTimeFormat
                )
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        return format.smfBytes + trackCount.smfBytes + deltaTimeFormat.smfBytes
    }
    
    public init(
        format: Format,
        trackCount: TrackCount,
        deltaTimeFormat: DeltaTimeFormat
    ) {
        type = .header
        self.format = format
        self.trackCount = trackCount
        self.deltaTimeFormat = deltaTimeFormat
    }
    
    /// Header chunk is fixed size 6
    private static let length: Int = 6
}
