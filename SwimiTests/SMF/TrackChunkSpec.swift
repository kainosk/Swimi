//
//  TrackChunkSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/17.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class TrackChunkSpec: QuickSpec {
    override func spec() {
        describe("parse") {
            let noteOn = SMFMIDIEvent.noteOn(channel: 1, note: 2, velocity: 3)
            var binary: [UInt8]!
            let execute = {
                TrackChunk<SS>.parse(binary[...])
            }
            context("invalid binary: empty after delta time") {
                
                beforeEach {
                    binary =
                        VInt(100).smfBytes + noteOn.smfBytes +
                        VInt(200).smfBytes
                }
                it("returns success without invalid event. Length is always zero") {
                    expect(execute()) == ParseSucceeded(
                        length: 0,
                        component: TrackChunk<SS>(events: [.at(100, .midi(noteOn))])
                    )
                }
            }
            context("invalid binary: incomplete meta event") {
                beforeEach {
                    binary =
                        VInt(100).smfBytes + noteOn.smfBytes +
                        VInt(200).smfBytes + [0xFF, 0x01, 0x01]
                }
                it("returns success without invalid event. Length is always zero") {
                    expect(execute()) == ParseSucceeded(
                        length: 0,
                        component: TrackChunk<SS>(events: [.at(100, .midi(noteOn))])
                    )
                }
            }
            context("invalid binary: imcomplete sysex event") {
                beforeEach {
                    binary =
                        VInt(100).smfBytes + noteOn.smfBytes +
                        VInt(200).smfBytes + [0xF7, 0x02, 0x11]
                }
                it("returns success without invalid event. Length is always zero") {
                    expect(execute()) == ParseSucceeded(
                        length: 0,
                        component: TrackChunk<SS>(events: [.at(100, .midi(noteOn))])
                    )
                }
            }
        }
        
        describe("firstTimeSignature") {
            context("events does not have TimeSignature event") {
                it("returns nil") {
                    let trackChunk = TrackChunk<SS>(events: [
                        .at(100, .midi(.noteOn(channel: 1, note: 2, velocity: 3)))
                    ])
                    
                    expect(trackChunk.firstTimeSignature).to(beNil())
                }
            }
            context("events has TimeSignature event") {
                it("returns first TimeSignature event") {
                    let trackChunk = TrackChunk<SS>(events: [
                        .at(100, .midi(.noteOn(channel: 1, note: 2, velocity: 3))),
                        .at(200, .meta(.timeSignature(.standardFourFour))),
                        .at(300, .meta(.timeSignature(.standardThreeFour)))
                    ])
                    
                    expect(trackChunk.firstTimeSignature) == .standardFourFour
                }
            }
        }
    }
}
