//
//  Chunk.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/15.
//

import Foundation

public enum Chunk<SSType: SequencerSpecific>: Parsing, Equatable {
    case header(HeaderChunk)
    case track(TrackChunk<SSType>)
    case unknown(UnknownChunk)
    
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<Chunk> {
        var bytes = smfBytes
        guard case let .success(type) = ChunkType.parse(bytes) else {
            return .failure(.length(smfBytes.count))
        }
        
        bytes = bytes.dropFirst(type.length)
        guard case let .success(chunkLength) = ChunkLength.parse(bytes) else {
            return .failure(.length(smfBytes.count))
        }
        
        bytes = bytes.dropFirst(chunkLength.length).prefix(chunkLength.component.value)
        let wholeLength = type.length + chunkLength.length + chunkLength.component.value
        let failureResult: () -> ParseResult<Chunk> = {
            .failure(.length(min(wholeLength, smfBytes.count)))
        }

        switch type.component {
        case .header:
            guard case let .success(headerChunk) = HeaderChunk.parse(bytes) else {
                return failureResult()
            }
            return .success(
                ParseSucceeded(
                    length: wholeLength,
                    component: .header(headerChunk.component)
                )
            )
        case .track:
            // TrackChunk never fails.
            // If smfBytes is invalid, then return empty TrackChunk. (no events.)
            let trackChunk = TrackChunk<SSType>.parse(bytes)
            return .success(
                ParseSucceeded(
                    length: min(wholeLength, smfBytes.count),
                    component: .track(trackChunk.component)
                )
            )
        case .unknown(let unkonwnTypeName):
            return .success(
                ParseSucceeded(
                    length: min(wholeLength, smfBytes.count),
                    component: .unknown(
                        UnknownChunk(
                            type: .unknown(unkonwnTypeName),
                            data: Array(bytes)
                        )
                    )
                )
            )
        }
    }
    
    public var smfBytes: [UInt8] {
        let body = bodyData
        let type = chunkType
        return type.smfBytes + body.count.toBytes(length: 4) + body
    }
    
    public var headerChunk: HeaderChunk? {
        switch self {
        case .header(let h): return h
        default: return nil
        }
    }
    
    public var trackChunk: TrackChunk<SSType>? {
        switch self {
        case .track(let t): return t
        default: return nil
        }
    }
    
    private var bodyData: [UInt8] {
        switch self {
        case .header(let header):
            return header.smfBytes
        case .track(let track):
            return track.smfBytes
        case .unknown(let unknown):
            return unknown.data
        }
    }
    
    private var chunkType: ChunkType {
        switch self {
        case .header(_):        return .header
        case .track(_):         return .track
        case .unknown(let u):   return .unknown(u.type.identifier)
        }
    }
}
