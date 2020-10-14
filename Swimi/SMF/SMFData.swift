//
//  SMF.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/15.
//

import Foundation

public enum SMFParseError: Error {
    case failedToParse
}

public struct SMFData<SSType: SequencerSpecific>: Parsing, Equatable {
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<SMFData<SSType>> {
        let failureResult: ParseResult<SMFData> = .failure(.length(smfBytes.count))

        var bytes = smfBytes
        var chunks: [Chunk<SSType>] = []
        
        while_break: while true {
            print("loop")
            let result = Chunk<SSType>.parse(bytes)
            guard bytes.count > 0 else { break }
            switch result {
            case .success(let chunk):
                chunks.append(chunk.component)
                bytes = bytes.dropFirst(chunk.length)
            case .failure(_):
                // We want to break from while loop (not switch statement) so we use
                // break with label.
                break while_break
            }
        }
        
        // SMF must have header chunk.
        guard chunks.first?.headerChunk != nil else {
            return failureResult
        }
      
        return .success(
            ParseSucceeded(
                length: smfBytes.count,
                component: SMFData<SSType>(chunks: chunks)
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        chunks.flatMap { $0.smfBytes }
    }
    
    public var chunks: [Chunk<SSType>]
    
    /// Header chunk.
    public var headerChunk: HeaderChunk {
        // HeaderChunk is located at first chunk.
        chunks.first!.headerChunk!
    }
    
    /// Track chunks.
    public var trackChunks: [TrackChunk<SSType>] {
        chunks.compactMap { $0.trackChunk }
    }
    
    public var firstTimeSignature: TimeSignature? {
        // Search all track chunks
        let timeSignatureEvents = trackChunks.compactMap { trackChunk in
            trackChunk.events.first { $0.timeSignatureOrNil != nil }
        }
        return timeSignatureEvents
            .sorted { $0.position < $1.position }
            .first?.timeSignatureOrNil
    }
    
    public init(
        headerChunk: HeaderChunk,
        trackChunks: [TrackChunk<SSType>]
    ) {
        chunks = []
        chunks.append(.header(headerChunk))
        chunks.append(contentsOf: trackChunks.map { Chunk.track($0) } )
    }
    
    public init(chunks: [Chunk<SSType>]) {
        guard chunks.first?.headerChunk != nil else {
            fatalError("The SMF must have header chunk at first element.")
        }
        self.chunks = chunks
    }
    
    public init(_ smfBytes: [UInt8]) throws {
        if case let .success(data) = SMFData.parse(smfBytes[...]) {
            self = data.component
        } else {
            throw SMFParseError.failedToParse
        }
    }
}
