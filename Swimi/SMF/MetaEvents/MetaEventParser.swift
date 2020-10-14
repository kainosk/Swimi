//
//  MetaEventParser.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/04.
//

import Foundation

struct MetaEventParser<SSType: SequencerSpecific> {
    func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<MetaEvent<SSType>> {
        let success: ParseResult<MetaEvent<SSType>>? = parsers.compactMap {
            let result = $0(smfBytes)
            return result.isSuccess ? result : nil
        }
        .first
        
        return success ?? .failure(.length(0))
    }
    
    private let parsers: [(ArraySlice<UInt8>) -> ParseResult<MetaEvent<SSType>>] = [
        SequenceNumber.parse,
        TextEvent.parse,
        Lyric.parse,
        CuePoint.parse,
        MIDIChannelPrefix.parse,
        EndOfTrack.parse,
        SetTempo.parse,
        TimeSignature.parse,
        
        Self.sequencerSpecificEventParseFunc,
        
        UnknownMetaEvent.parse,
    ]
    
    
    private static func sequencerSpecificEventParseFunc(
        _ smfBytes: ArraySlice<UInt8>
    ) -> ParseResult<MetaEvent<SSType>> {
        
        guard smfBytes.prefix(2) == [0xFF, 0x7F] else {
            return .failure(.length(0))
        }
        
        let result = SSType.parse(smfBytes)
        switch result {
        case .success(let success):
            return .success(
                ParseSucceeded(
                    length: success.length,
                    component: .sequencerSpecific(success.component)
                )
            )
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
