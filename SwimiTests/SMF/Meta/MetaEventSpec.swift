//
//  MetaEventSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/11.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class MetaEventSpec: QuickSpec {
    override func spec() {
        describe("smfBytes") {
            var metaEvent: MetaEvent<SS>!
            it("sequenceNumber") {
                let content = SequenceNumber(10)
                metaEvent = .sequenceNumber(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
            it("text") {
                let content = TextEvent(data: [0xFF, 0xEE])
                metaEvent = .text(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
            it("lyric") {
                let content = Lyric(data: [0xFF, 0xEE])
                metaEvent = .lyric(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
            it("cuePoint") {
                let content = CuePoint(data: [0xFF, 0xEE])
                metaEvent = .cuePoint(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
            it("midiChannelPrefix") {
                let content = MIDIChannelPrefix(channel: 11)
                metaEvent = .midiChannelPrefix(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
            it("endOfTrack") {
                let content = EndOfTrack()
                metaEvent = .endOfTrack(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
            it("setTempo") {
                let content = SetTempo(bpm: 120)
                metaEvent = .setTempo(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
            it("timeSignature") {
                let content = TimeSignature.standardFourFour
                metaEvent = .timeSignature(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
            it("keySignature") {
                let content = KeySignature(numberOfSharpsOrFlats: 3, mode: .major)
                metaEvent = .keySignature(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
            it("sequencerSpecific") {
                let content = SS()
                metaEvent = .sequencerSpecific(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
            it("unknown") {
                let content = UnknownMetaEvent(smfBytes: [0x00, 0x11, 0x22])
                metaEvent = .unknown(content)
                expect(metaEvent.smfBytes) == content.smfBytes
            }
        }
        describe("timeSignatureOrNil") {
            context("event is not timeSignature") {
                it("returns nil") {
                    let e = MetaEvent<SS>.text([0x00])
                    expect(e.timeSignatureOrNil).to(beNil())
                }
            }
            context("event is timeSignature") {
                it("returns timeSignature") {
                    let e = MetaEvent<SS>.timeSignature(.standardFourFour)
                    expect(e.timeSignatureOrNil) == .standardFourFour
                }
            }
        }
        
        describe("convenience methods") {
            it("sequencerNumber") {
                let a: MetaEvent<SS> = .sequenceNumber(SequenceNumber(1))
                let b: MetaEvent<SS> = .sequenceNumber(1)
                expect(a) == b
            }
            it("text") {
                let a: MetaEvent<SS> = .text(TextEvent(data: [0x11]))
                let b: MetaEvent<SS> = .text([0x11])
                expect(a) == b
            }
            it("lyric") {
                let a: MetaEvent<SS> = .lyric(Lyric(data: [0x11]))
                let b: MetaEvent<SS> = .lyric([0x11])
                expect(a) == b
            }
            it("cuePoint") {
                let a: MetaEvent<SS> = .cuePoint(CuePoint(data: [0x11]))
                let b: MetaEvent<SS> = .cuePoint([0x11])
                expect(a) == b
            }
            it("midiChannelPrefix") {
                let a: MetaEvent<SS> = .midiChannelPrefix(MIDIChannelPrefix(channel: 1))
                let b: MetaEvent<SS> = .midiChannelPrefix(channel: 1)
                expect(a) == b
            }
            it("endOfTrack") {
                let a: MetaEvent<SS> = .endOfTrack(EndOfTrack())
                let b: MetaEvent<SS> = .endOfTrack()
                expect(a) == b
            }
            it("setTempo bpm") {
                let a: MetaEvent<SS> = .setTempo(SetTempo(bpm: 100))
                let b: MetaEvent<SS> = .setTempo(bpm: 100)
                expect(a) == b
            }
            it("setTempo microsecondsPerQuarterNote") {
                let a: MetaEvent<SS> = .setTempo(SetTempo(microsecondsPerQuarterNote: 10))
                let b: MetaEvent<SS> = .setTempo(microsecondsPerQuarterNote: 10)
                expect(a) == b
            }
            it("timeSignature denominator") {
                let a: MetaEvent<SS> = .timeSignature(
                    TimeSignature(
                        numerator: 3,
                        denominator: 4,
                        midiClocksPerMetronomeClick: 1,
                        thirtySecondNotesPer24MIDIClocks: 2
                    )
                )
                let b: MetaEvent<SS> = .timeSignature(
                    numerator: 3,
                    denominator: 4,
                    midiClocksPerMetronomeClick: 1,
                    thirtySecondNotesPer24MIDIClocks: 2
                )
                expect(a) == b
            }
            it("timeSignature denominatorPowerOfTwo") {
                let a: MetaEvent<SS> = .timeSignature(
                    TimeSignature(
                        numerator: 3,
                        denominatorPowerOfTwo: 2,
                        midiClocksPerMetronomeClick: 1,
                        thirtySecondNotesPer24MIDIClocks: 2
                    )
                )
                let b: MetaEvent<SS> = .timeSignature(
                    numerator: 3,
                    denominatorPowerOfTwo: 2,
                    midiClocksPerMetronomeClick: 1,
                    thirtySecondNotesPer24MIDIClocks: 2
                )
                expect(a) == b
            }
            it("keySignature") {
                let a: MetaEvent<SS> = .keySignature(
                    KeySignature(numberOfSharpsOrFlats: 5, mode: .major)
                )
                let b: MetaEvent<SS> =
                    .keySignature(numberOfSharpsOrFlats: 5, mode: .major)
                expect(a) == b
            }
            it("unknown") {
                let a: MetaEvent<SS> = .unknown(
                    UnknownMetaEvent(smfBytes: [0xFF, 0x7F, 0x01, 0x77])
                )
                let b: MetaEvent<SS> = .unknown([0xFF, 0x7F, 0x01, 0x77])
                expect(a) == b
            }
        }
    }
}
