//
//  MetaEventParserSpec.swift
//  SwimiTests
//
//  Created by Kainosuke OBATA on 2020/08/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class MetaEventParserSpec: QuickSpec {
    
    
    override func spec() {
        
        describe("parse") {
            
            var binary: [UInt8]!
            
            context("smfBytes is not meta event") {
                var subject: MetaEventParser<AlwaysFailing>!
                let execute = {
                    subject.parse(binary[...])
                }
                
                beforeEach {
                    binary = SMFMIDIEvent.noteOn(channel: 1, note: 2, velocity: 3).smfBytes
                    subject = MetaEventParser()
                }
                it("returns failure with length 0") {
                    expect(execute()) == .failure(.length(0))
                }
            }
            context("smfBytes is SequencerSpecific but provided type can not parse it") {
                var subject: MetaEventParser<AlwaysFailing>!
                let execute = { subject.parse(binary[...]) }
                beforeEach {
                    binary = [0xFF, 0x7F, 0x01, 0x22]
                    subject = MetaEventParser()
                }
                it("returns success with UnknownMetaEvent") {
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: 4,
                            component: .unknown(binary))
                    )
                }
            }
            context("smfBytes is SenquencerSpecific and provided type can parse it") {
                var subject: MetaEventParser<AlwaysSuccessing>!
                let execute = { subject.parse(binary[...]) }
                beforeEach {
                    binary = [0xFF, 0x7F, 0x01, 0x22]
                    subject = MetaEventParser()
                }
                
                it("returns success with SequencerSpecific") {
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: 4,
                            component: .sequencerSpecific(AlwaysSuccessing(data: binary))
                        )
                    )
                }
            }
            context("Normal meta events") {
                var subject: MetaEventParser<AlwaysFailing>!
                let execute = { subject.parse(binary[...]) }
                beforeEach {
                    subject = MetaEventParser()
                }
                context("smfBytes is SequenceNumber") {
                    beforeEach {
                        binary = SequenceNumber(10).smfBytes
                    }
                    it("returns success with SequenceNumber") {
                        expect(execute()) == .success(
                            ParseSucceeded(
                                length: binary.count,
                                component: .sequenceNumber(10)
                            )
                        )
                    }
                }
                context("smfBytes is TextEvent") {
                    beforeEach {
                        binary = TextEvent(data: [0xFF, 0xEE]).smfBytes
                    }
                    it("returns success with TextEvent") {
                        expect(execute()) == .success(
                            ParseSucceeded(
                                length: binary.count,
                                component: .text([0xFF, 0xEE])
                            )
                        )
                    }
                }
                context("smfBytes is Lyric") {
                    beforeEach {
                        binary = Lyric(data: [0xFF, 0xEE]).smfBytes
                    }
                    it("returns success with Lyric") {
                        expect(execute()) == .success(
                            ParseSucceeded(
                                length: binary.count,
                                component: .lyric([0xFF, 0xEE])
                            )
                        )
                    }
                }
                context("smfBytes is CuePoint") {
                    beforeEach {
                        binary = CuePoint(data: [0xFF, 0xEE]).smfBytes
                    }
                    it("returns success with CuePoint") {
                        expect(execute()) == .success(
                            ParseSucceeded(
                                length: binary.count,
                                component: .cuePoint([0xFF, 0xEE])
                            )
                        )
                    }
                }
                context("smfBytes is MIDIChannelPrefix") {
                    beforeEach {
                        binary = MIDIChannelPrefix(channel: 9).smfBytes
                    }
                    it("returns success with MIDIChannelPrefix") {
                        expect(execute()) == .success(
                            ParseSucceeded(
                                length: binary.count,
                                component: .midiChannelPrefix(channel: 9)
                            )
                        )
                    }
                }
                context("smfBytes is EndOfTrack") {
                    beforeEach {
                        binary = EndOfTrack().smfBytes
                    }
                    it("returns success with EndOfTrack") {
                        expect(execute()) == .success(
                            ParseSucceeded(
                                length: binary.count,
                                component: .endOfTrack()
                            )
                        )
                    }
                }
                context("smfBytes is SetTempo") {
                    beforeEach {
                        binary = SetTempo(bpm: 120).smfBytes
                    }
                    it("returns success with SetTempo") {
                        expect(execute()) == .success(
                            ParseSucceeded(
                                length: binary.count,
                                component: .setTempo(bpm: 120)
                            )
                        )
                    }
                }
                context("smfBytes is TimeSignature") {
                    beforeEach {
                        binary = TimeSignature.standardFourFour.smfBytes
                    }
                    it("returns success with TimeSignature") {
                        expect(execute()) == .success(
                            ParseSucceeded(
                                length: binary.count,
                                component: .timeSignature(.standardFourFour)
                            )
                        )
                    }
                }
                context("smfBytes is meta event but parser could not recognize it") {
                    beforeEach {
                        binary = [0xFF, 0x21, 0x01, 0x22]
                    }
                    it("returns success with UnknownMetaEvent") {
                        expect(execute()) == .success(
                            ParseSucceeded(
                                length: 4,
                                component: .unknown(binary)
                            )
                        )
                    }
                }
            }
        }
    }
}
