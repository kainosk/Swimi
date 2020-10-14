//
//  SMFDataSpec.swift
//  SwimiTests
//
//  Created by Kainosuke OBATA on 2020/08/16.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class SMFDataSpec: QuickSpec {
    
    enum MySequencerSpecificMetaEvent: SequencerSpecific {
        static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<SMFDataSpec.MySequencerSpecificMetaEvent> {
            return .failure(.length(0))
        }
        var smfBytes: [UInt8] { [] }
        
        case superEvent(Int)
        case ultraEvent(String)
    }
    
    let defaultHeaderChunkBinary: [UInt8] = [
        0x4D, 0x54, 0x68, 0x64, // MThd
        0x00, 0x00, 0x00, 0x06, // length of chunk
        0x00, 0x00,             // format 0
        0x00, 0x01,             // number of tracks = 1
        0x00, 0x60,             // 96 ticks per quarter note
    ]
    
    let defaultHeaderChunk: HeaderChunk = HeaderChunk(
        format: .zero,
        trackCount: TrackCount(1),
        deltaTimeFormat: .ticksPerQuarterNote(96)
    )
    
    override func spec() {
        describe("from binary & to binary") {
            describe("MIDI1.0 spec's sample1: format 0") {
                // from MIDI1.0 spec
                let sampleBinary: [UInt8] = [
                    0x4D, 0x54, 0x68, 0x64, // MThd
                    0x00, 0x00, 0x00, 0x06, // length of chunk
                    0x00, 0x00,             // format 0
                    0x00, 0x01,             // number of tracks = 1
                    0x00, 0x60,             // 96 ticks per quarter note
                    
                    0x4D,          0x54, 0x72, 0x6B, // MTrk
                    0x00,          0x00, 0x00, 0x3B, // length of chunk
                    // Delta Time,
                    0x00,          0xFF, 0x58, 0x04, 0x04, 0x02, 0x18, 0x08, // Time signature
                    0x00,          0xFF, 0x51, 0x03, 0x07, 0xA1, 0x20,       // Set tempo (BPM 120)
                    0x00,          0xC0, 0x05,                               // ch1 program change 5
                    0x00,          0xC1, 0x2E,                               // ch2 program change 46
                    0x00,          0xC2, 0x46,                               // ch3 program change 70
                    0x00,          0x92, 0x30, 0x60,                         // ch3 note on  48, forte
                    0x00,                0x3C, 0x60,                         // ch3 note on  60, forte
                    0x60,          0x91, 0x43, 0x40,                         // ch2 note on  67, mezzo forte
                    0x60,          0x90, 0x4C, 0x20,                         // ch1 note on  76, piano
                    0x81, 0x40,    0x82, 0x30, 0x40,                         // ch3 note off 48
                    0x00,                0x3C, 0x40,                         // ch3 note off 60
                    0x00,          0x81, 0x43, 0x40,                         // ch2 note off 67
                    0x00,          0x80, 0x4C, 0x40,                         // ch1 note off 76
                    0x00,          0xFF, 0x2F, 0x00,                         // End of track
                ]
                
                let correctData = SMFData<MySequencerSpecificMetaEvent>(
                    chunks: [
                        .header(
                            HeaderChunk(
                                format: .zero,
                                trackCount: TrackCount(1),
                                deltaTimeFormat: .ticksPerQuarterNote(96)
                            )
                        ),
                        .track(
                            TrackChunk(
                                events: [
                                    PositionalTrackEvent(
                                        event: .meta(
                                            .timeSignature(
                                                TimeSignature(
                                                    numerator: 4,
                                                    denominator: 4,
                                                    midiClocksPerMetronomeClick: 24,
                                                    thirtySecondNotesPer24MIDIClocks: 8
                                                )
                                            )
                                        ),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .meta(.setTempo(bpm: 120)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.programChange(channel: 0, program: 5)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.programChange(channel: 1, program: 46)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.programChange(channel: 2, program: 70)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 2, note: 48, velocity: 96)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 2, note: 60, velocity: 96)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 1, note: 67, velocity: 64)),
                                        position: 96
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 0, note: 76, velocity: 32)),
                                        position: 96 + 96
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOff(channel: 2, note: 48, velocity: 64)),
                                        position: 96 + 96 + 192
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOff(channel: 2, note: 60, velocity: 64)),
                                        position: 96 + 96 + 192
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOff(channel: 1, note: 67, velocity: 64)),
                                        position: 96 + 96 + 192
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOff(channel: 0, note: 76, velocity: 64)),
                                        position: 96 + 96 + 192
                                    ),
                                    PositionalTrackEvent(
                                        event: .meta(.endOfTrack()),
                                        position: 96 + 96 + 192
                                    )
                                ]
                            )
                        )
                    ]
                )
                
                /// generated binary does not contain Running Status
                let correctBinary: [UInt8] = [
                    
                    0x4D, 0x54, 0x68, 0x64, // MThd
                    0x00, 0x00, 0x00, 0x06, // length of chunk
                    0x00, 0x00,             // format 0
                    0x00, 0x01,             // number of tracks = 1
                    0x00, 0x60,             // 96 ticks per quarter note
                    
                    0x4D,          0x54, 0x72, 0x6B, // MTrk
                    0x00,          0x00, 0x00, 0x3B + 2, // length of chunk (2 is runnning status)
                    0x00,          0xFF, 0x58, 0x04, 0x04, 0x02, 0x18, 0x08, // Time signature
                    0x00,          0xFF, 0x51, 0x03, 0x07, 0xA1, 0x20,       // Set tempo (BPM 120)
                    0x00,          0xC0, 0x05,                               // ch1 program change 5
                    0x00,          0xC1, 0x2E,                               // ch2 program change 46
                    0x00,          0xC2, 0x46,                               // ch3 program change 70
                    0x00,          0x92, 0x30, 0x60,                         // ch3 note on  48, forte
                    0x00,          0x92, 0x3C, 0x60,                         // ch3 note on  60, forte
                    0x60,          0x91, 0x43, 0x40,                         // ch2 note on  67, mezzo forte
                    0x60,          0x90, 0x4C, 0x20,                         // ch1 note on  76, piano
                    0x81, 0x40,    0x82, 0x30, 0x40,                         // ch3 note off 48
                    0x00,          0x82, 0x3C, 0x40,                         // ch3 note off 60
                    0x00,          0x81, 0x43, 0x40,                         // ch2 note off 67
                    0x00,          0x80, 0x4C, 0x40,                         // ch1 note off 76
                    0x00,          0xFF, 0x2F, 0x00,                         // End of track
                ]
                
                it("can initialize from binary data") {
                    let smfData = try! SMFData<MySequencerSpecificMetaEvent>(sampleBinary)
                    expect(smfData) == correctData
                }
                it("can be convert to binary data") {
                    let smfData = try! SMFData<MySequencerSpecificMetaEvent>(sampleBinary)
                    let binary = smfData.smfBytes
                    expect(binary) == correctBinary
                }
            }
            
            it("can parse MIDI1.0 spec's sample data. format 1") {
                let smfBinary: [UInt8] = [
                    // Header
                    0x4D, 0x54, 0x68, 0x64, // MThd
                    0x00, 0x00, 0x00, 0x06, // Length of header chunk (6)
                    0x00, 0x01,             // format 1
                    0x00, 0x04,             // number of tracks 4
                    0x00, 0x60,             // delta time format 96 ticks per quarter note
                    
                    // Track 1
                    0x4D, 0x54, 0x72, 0x6B, // MTrk
                    0x00, 0x00, 0x00, 0x14, // Length of track chunk 1 (20)
                    
                    0x00,             0xFF, 0x58, 0x04, 0x04, 0x02, 0x18, 0x08, // Time signature
                    0x00,             0xFF, 0x51, 0x03, 0x07, 0xA1, 0x20,       // Tempo
                    0x83, 0x00,       0xFF, 0x2F, 0x00,                         // End of track
                    
                    // Track 2
                    0x4D, 0x54, 0x72, 0x6B, // MTrk
                    0x00, 0x00, 0x00, 0x10, // Length of track chunk 1 (16)
                    
                    0x00,             0xC0, 0x05,       // ch1 program change 5
                    0x81, 0x40,       0x90, 0x4C, 0x20, // ch1 note on  76, piano
                    0x81, 0x40,             0x4C, 0x00, // ch1 note off (by velocity 0 note on)
                    0x00,             0xFF, 0x2F, 0x00, // End of track
                    
                    // Track 3
                    0x4D, 0x54, 0x72, 0x6B, // MTrk
                    0x00, 0x00, 0x00, 0x0F, // Length of track chunk 1 (15)
                    
                    0x00,             0xC1, 0x2E,       // ch2 program change 46
                    0x60,             0x91, 0x43, 0x40, // ch2 note on 67
                    0x82, 0x20,             0x43, 0x00, // ch2 note off (by velocity 0 note on)
                    0x00,             0xFF, 0x2F, 0x00, // End of track
                    
                    // Track4
                    0x4D, 0x54, 0x72, 0x6B, // MTrk
                    0x00, 0x00, 0x00, 0x15, // Length of track chunk 1 (21)
                    
                    0x00,             0xC2, 0x46,       // ch3 program change 70
                    0x00,             0x92, 0x30, 0x60, // ch3 note on 48
                    0x00,                   0x3C, 0x60, // ch3 note on 60 (running status)
                    0x83, 0x00,             0x30, 0x00, // ch3 note off (by velocity 0 note on)
                    0x00,                   0x3C, 0x00, // ch3 note off (by velocity 0 note on)
                    0x00,             0xFF, 0x2F, 0x00, // End of track
                ]
                
                let smfData = try! SMFData<MySequencerSpecificMetaEvent>(smfBinary)
                expect(smfData) == SMFData(
                    chunks: [
                        .header(
                            HeaderChunk(format: .one, trackCount: TrackCount(4), deltaTimeFormat: .ticksPerQuarterNote(96))
                        ),
                        .track(
                            TrackChunk(
                                events: [
                                    PositionalTrackEvent(
                                        event: .meta(.timeSignature(.standardFourFour)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .meta(.setTempo(bpm: 120)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .meta(.endOfTrack()),
                                        position: 96 + 96 + 192
                                    ),
                                ]
                            )
                        ),
                        .track(
                            TrackChunk(
                                events: [
                                    PositionalTrackEvent(
                                        event: .midi(.programChange(channel: 0, program: 5)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 0, note: 76, velocity: 32)),
                                        position: 96 + 96
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 0, note: 76, velocity: 0)),
                                        position: 96 + 96 + 192
                                    ),
                                    PositionalTrackEvent(
                                        event: .meta(.endOfTrack()),
                                        position: 96 + 96 + 192
                                    )
                                ]
                            )
                        ),
                        .track(
                            TrackChunk(
                                events: [
                                    PositionalTrackEvent(
                                        event: .midi(.programChange(channel: 1, program: 46)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 1, note: 67, velocity: 64)),
                                        position: 96
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 1, note: 67, velocity: 0)),
                                        position: 96 + 96 + 192
                                    ),
                                    PositionalTrackEvent(
                                        event: .meta(.endOfTrack()),
                                        position: 96 + 96 + 192
                                    )
                                ]
                            )
                        ),
                        .track(
                            TrackChunk(
                                events: [
                                    PositionalTrackEvent(
                                        event: .midi(.programChange(channel: 2, program: 70)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 2, note: 48, velocity: 96)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 2, note: 60, velocity: 96)),
                                        position: 0
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 2, note: 48, velocity: 0)),
                                        position: 96 + 96 + 192
                                    ),
                                    PositionalTrackEvent(
                                        event: .midi(.noteOn(channel: 2, note: 60, velocity: 0)),
                                        position: 96 + 96 + 192
                                    ),
                                    PositionalTrackEvent(
                                        event: .meta(.endOfTrack()),
                                        position: 96 + 96 + 192
                                    )
                                ]
                            )
                        )
                    ]
                )
            }
            
            describe("Data containing SysEx") {
                let binary: [UInt8] = defaultHeaderChunkBinary + [
                    0x4D,          0x54, 0x72, 0x6B, // MTrk
                    0x00,          0x00, 0x00, 0x0A, // length of chunk
                    // Delta Time,
                    0x00,          0xF0, 0x03, 0x11, 0x22, 0x7F,
                    0x00,          0xFF, 0x2F, 0x00,                         // End of track
                ]
                let correctData = SMFData<MySequencerSpecificMetaEvent>(
                    chunks: [
                        .header(defaultHeaderChunk),
                        .track(
                            TrackChunk(
                                events: [
                                    .at(0, .sysEx(.f0(dataIncludingFirstF0: [0xF0, 0x11, 0x22, 0x7F]))),
                                    .at(0, .meta(.endOfTrack()))
                                ]
                            )
                        )
                    ]
                )
                it("can parse correctly") {
                    let result = try! SMFData<MySequencerSpecificMetaEvent>(binary)
                    expect(result) == correctData
                }
            }
        }
        
        describe("parse") {
            var binary: [UInt8]!
            let execute = { SMFData<SS>.parse(binary[...]) }
            context("smfBytes has invalid chunk") {
                let headerChunk = HeaderChunk(
                    format: .zero,
                    trackCount: TrackCount(1),
                    deltaTimeFormat: .ticksPerQuarterNote(480)
                )
                let c: Chunk<SS> = .header(headerChunk)
                beforeEach {
                    // TrackChunk and UnknownChunk never fails to parse.
                    // So we use imcomplete HeaderChunk to test.
                    binary = c.smfBytes + c.smfBytes.dropLast()
                }
                it("returns success without invalid chunk") {
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: binary.count,
                            component: SMFData<SS>(chunks: [.header(headerChunk)])
                        )
                    )
                }
            }
            context("smfBytes has no header chunk") {
                beforeEach {
                    let trackChunk = TrackChunk<SS>(events: [
                        .at(100, .midi(.noteOn(channel: 1, note: 2, velocity: 3)))
                    ])
                    binary = Chunk<SS>.track(trackChunk).smfBytes
                }
                it("returns failure") {
                    expect(execute()) == .failure(.length(binary.count))
                }
            }
            context("smfBytes has header chunk as first chunk") {
                let header = HeaderChunk(
                    format: .zero,
                    trackCount: TrackCount(1),
                    deltaTimeFormat: .ticksPerQuarterNote(480)
                )
                let track = TrackChunk<SS>(events: [
                    .at(100, .midi(.noteOn(channel: 1, note: 2, velocity: 3)))
                ])
                
                beforeEach {
                    binary = [Chunk.header(header), Chunk.track(track)]
                        .flatMap { $0.smfBytes }
                }
                
                it("returns success") {
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: binary.count,
                            component: SMFData(chunks: [
                                .header(header),
                                .track(track)
                            ])
                        )
                    )
                }
            }
        }
        
        let header = HeaderChunk(
            format: .one,
            trackCount: TrackCount(1),
            deltaTimeFormat: .ticksPerQuarterNote(480)
        )
        let track1 = TrackChunk<SS>(events: [
            .at(100, .midi(.noteOn(channel: 1, note: 2, velocity: 3)))
        ])
        let track2 = TrackChunk<SS>(events: [
            .at(200, .midi(.noteOn(channel: 1, note: 2, velocity: 3)))
        ])
        
        describe("headerChunk") {
            it("returns first HeaderChunk") {
                let data = SMFData<SS>(
                    chunks: [
                        .header(header),
                        .track(track1),
                    ]
                )
                expect(data.headerChunk) == header
            }
        }
        
        describe("trackChunks") {
            it("returns all track chunks") {
                let data = SMFData<SS>(
                    chunks: [
                        .header(header),
                        .track(track1),
                        .track(track2),
                    ]
                )
                expect(data.trackChunks) == [track1, track2]
            }
        }
        
        describe("firstTimeSignature") {
            
            var trackEvents1: [PositionalTrackEvent<SS>]!
            var trackEvents2: [PositionalTrackEvent<SS>]!
            let execute = {
                SMFData<SS>(chunks: [
                    .header(header),
                    .track(TrackChunk(events: trackEvents1)),
                    .track(TrackChunk(events: trackEvents2)),
                ]).firstTimeSignature
            }
            context("no TimeSignature") {
                it("returns nil") {
                    
                }
            }
            context("first track chunk has TimeSignature") {
                beforeEach {
                    trackEvents1 = [
                        .at(100, .meta(.timeSignature(.standardFourFour))),
                        .at(200, .meta(.timeSignature(.standardThreeFour))),
                    ]
                    trackEvents2 = []
                }
                it("returns first TimeSignature event") {
                    expect(execute()) == .standardFourFour
                }
            }
            context("second track chunk has TimeSignature") {
                beforeEach {
                    trackEvents1 = []
                    trackEvents2 = [
                        .at(100, .meta(.timeSignature(.standardFourFour))),
                        .at(200, .meta(.timeSignature(.standardThreeFour))),
                    ]
                }
                it("returns first TimeSignature event") {
                    expect(execute()) == .standardFourFour
                }
            }
            context("multiple track chunks has TimeSignature") {
                beforeEach {
                    trackEvents1 = [
                        .at(500, .meta(.timeSignature(.standardFourFour))),
                        .at(600, .meta(.timeSignature(.standardThreeFour)))
                    ]
                    trackEvents2 = [
                        .at(100, .meta(.timeSignature(.standardTwoTwo))),
                        .at(999, .meta(.timeSignature(.standardThreeFour))),
                    ]
                }
                it("returns earliest TimeSignature event") {
                    expect(execute()) == .standardTwoTwo
                }
            }
        }
        
        describe("init with chunks") {
            var chunks: [Chunk<SS>]!
            context("passed chunks's first element is not header chunk") {
                beforeEach {
                    chunks = [
                        .track(track1),
                        .track(track2)
                    ]
                }
                it("throws fatalError") {
                    expect {
                        _ = SMFData(chunks: chunks)
                    }.to(throwAssertion())
                }
            }
            context("passed chunks's first element is header chunk") {
                beforeEach {
                    chunks = [
                        .header(header),
                        .track(track1),
                        .track(track2)
                    ]
                }
                it("can be initialized successfully and provides passed chunks") {
                    let data = SMFData(chunks: chunks)
                    expect(data.headerChunk) == header
                    expect(data.trackChunks) == [track1, track2]
                    
                }
            }
        }
        
        describe("init with header and track chunks") {
            it("provides passed chunks") {
                let data = SMFData(
                    headerChunk: header,
                    trackChunks: [track1, track2]
                )
                expect(data.headerChunk) == header
                expect(data.trackChunks) == [track1, track2]
            }
        }
        
        describe("init from smfBytes") {
            context("smfBytes is valid") {
                it("returns parsed SMFData") {
                    let data = SMFData(headerChunk: header, trackChunks: [track1, track2])
                    expect(try? SMFData<SS>(data.smfBytes)) == data
                }
            }
            context("smfBytes is invalid") {
                it("throws SMFParseError.failedToParse") {
                    // TrackChunk tries to parse as much as possible, so TrackChunk never
                    // fails. UnknownChunk is same. So we use header-less binary as test
                    // data.
                    let binary = Chunk.track(track1).smfBytes
                    expect {
                        _ = try SMFData<SS>(binary)
                    }.to(throwError(SMFParseError.failedToParse))
                }
            }
        }
    }
}

