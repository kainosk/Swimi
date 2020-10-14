//
//  ChunkSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/24.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class ChunkSpec: QuickSpec {
    override func spec() {
        describe("parse") {
            var binary: [UInt8]!
            let execute = {
                Chunk<SS>.parse(binary[...])
            }
            context("smfBytes.count less than 4 (chunk type is not determined)") {
                beforeEach { binary = [0x11, 0x11, 0x11] }
                it("returns failure with length smfBytes.count") {
                    expect(execute()) == .failure(.length(binary.count))
                }
            }
            context("smfBytes has chunk header but length is invalid") {
                beforeEach {
                    binary = ChunkType.track.smfBytes + [0xFF]
                }
                it("returns failure with length smfBytes.count") {
                    expect(execute()) == .failure(.length(binary.count))
                }
            }
            context("smfBytes is header chunk but invalid format (length is not enough)") {
                beforeEach {
                    let headerChunk = HeaderChunk(
                        format: .zero,
                        trackCount: TrackCount(1),
                        deltaTimeFormat: .ticksPerQuarterNote(480)
                    )
                    binary = ChunkType.header.smfBytes +
                        ChunkLength(headerChunk.smfBytes.count).smfBytes +
                        headerChunk.smfBytes.dropLast()
                }
                it("returns failure with length smfBytes.count") {
                    expect(execute()) == .failure(.length(binary.count))
                }
            }
            context("smfBytes is valid header chunk") {
                let headerChunk = HeaderChunk(
                    format: .one,
                    trackCount: TrackCount(10),
                    deltaTimeFormat: .ticksPerQuarterNote(480)
                )
                beforeEach {
                    binary = ChunkType.header.smfBytes
                        + ChunkLength(headerChunk.smfBytes.count).smfBytes
                        + headerChunk.smfBytes
                }
                it("returns success") {
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: binary.count,
                            component: .header(headerChunk)
                        )
                    )
                }
            }
            context("smfBytes is track chunk but invalid format (length is not enough)") {
                beforeEach {
                    let trackChunk = TrackChunk<SS>(events: [
                        .at(0, .midi(.noteOn(channel: 1, note: 2, velocity: 3)))
                    ])
                    binary = ChunkType.track.smfBytes +
                        ChunkLength(trackChunk.smfBytes.count).smfBytes +
                        trackChunk.smfBytes.dropLast()
                }
                it("returns success (TrackChunk.parse is always success. Invalid format is ignored.)") {
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: binary.count,
                            component: .track(TrackChunk(events: []))
                        )
                    )
                }
            }
            context("smfBytes is valid track chunk") {
                let trackChunk = TrackChunk<SS>(events: [
                    .at(0, .midi(.noteOn(channel: 1, note: 2, velocity: 3)))
                ])
                beforeEach {
                    binary = ChunkType.track.smfBytes +
                        ChunkLength(trackChunk.smfBytes.count).smfBytes +
                        trackChunk.smfBytes
                }
                it("returns success") {
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: binary.count,
                            component: .track(trackChunk)
                        )
                    )
                }
            }
            context("smfBytes is unknown chunk") {
                let unknownChunk = UnknownChunk(
                    type: .unknown("MYCH"),
                    data: [0x11, 0x22, 0x33, 0x44]
                )
                let chunk = Chunk<SS>.unknown(unknownChunk)
                beforeEach {
                    binary = chunk.smfBytes
                }
                it("returns success") {
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: binary.count,
                            component: .unknown(unknownChunk)
                        )
                    )
                }
            }
        }
        
        describe("headerChunk") {
            context("chunk is header") {
                it("returns HeaderChunk") {
                    let headerChunk = HeaderChunk(
                        format: .zero,
                        trackCount: TrackCount(1),
                        deltaTimeFormat: .ticksPerQuarterNote(480)
                    )
                    let c: Chunk<SS> = .header(headerChunk)
                    expect(c.headerChunk) == headerChunk
                }
            }
            context("chunk is not header") {
                it("returns nil") {
                    let c: Chunk<SS> = .track(TrackChunk(events: []))
                    expect(c.headerChunk).to(beNil())
                }
            }
        }
        
        describe("trackChunk") {
            context("chunk is track") {
                it("returns TrackChunk") {
                    let trackChunk = TrackChunk<SS>(events: [])
                    let c: Chunk = .track(trackChunk)
                    expect(c.trackChunk) == trackChunk
                }
            }
            context("chunk is not track") {
                it("returns nil") {
                    let c: Chunk<SS> =
                        .unknown(UnknownChunk(type: .unknown("HOGE"), data: [0xFF]))
                    expect(c.trackChunk).to(beNil())
                }
            }
        }
    }
}
