//
//  HeaderChunkSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/17.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class HeaderChunkSpec: QuickSpec {
    override func spec() {
        describe("init") {
            let c = HeaderChunk(
                format: .two,
                trackCount: TrackCount(10),
                deltaTimeFormat: .ticksPerQuarterNote(999)
            )
            it("returns passed format as is") {
                expect(c.format) == .two
            }
            it("returns passed trackCount as is") {
                expect(c.trackCount) == TrackCount(10)
            }
            it("returns passed deltaTimeFormat as is") {
                expect(c.deltaTimeFormat) == .ticksPerQuarterNote(999)
            }
        }
        describe("parse") {
            var binary: [UInt8]!
            let execute = { HeaderChunk.parse(binary[...]) }
            context("smfBytes.count is not larger than 6 (1)") {
                it("returns failure with length 1") {
                    binary = [0x01]
                    expect(execute()) == .failure(.length(1))
                }
            }
            context("smfBytes.count is not larger than 6 (2)") {
                it("returns failure with length 2") {
                    binary = [0x01, 0x01]
                    expect(execute()) == .failure(.length(2))
                }
            }
            context("smfBytes.count is not larger than 6 (3)") {
                it("returns failure with length 3") {
                    binary = [0x01, 0x01, 0x01]
                    expect(execute()) == .failure(.length(3))
                }
            }
            context("smfBytes.count is not larger than 6 (4)") {
                it("returns failure with length 4") {
                    binary = [0x01, 0x01, 0x01, 0x01]
                    expect(execute()) == .failure(.length(4))
                }
            }
            context("smfBytes.count is not larger than 6 (5)") {
                it("returns failure with length 5") {
                    binary = [0x01, 0x01, 0x01, 0x01, 0x01]
                    expect(execute()) == .failure(.length(5))
                }
            }
            context("smfBytes.count is larger than 6") {
                it("returns success with HeaderChunk") {
                    binary = [
                        0x00, 0x01,  // format is one
                        0x11, 0x11,  // track count is 0x1111
                        0x12, 0x34,  // delta time format is ticksPerQuarterNote(0x9999)
                    ]
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: 6,
                            component: HeaderChunk(
                                format: .one,
                                trackCount: TrackCount(0x1111),
                                deltaTimeFormat: .ticksPerQuarterNote(0x1234)
                            )
                        )
                    )
                }
            }
        }
    }
}
