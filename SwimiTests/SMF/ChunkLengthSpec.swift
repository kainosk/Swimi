//
//  ChunkLengthSpec.swift
//  SwimiTests
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class ChunkLengthSpec: QuickSpec {
    override func spec() {
        describe("parse") {
            // hex
            it("00 00 00 00 -> 0") {
                expect(ChunkLength.parse([0x00, 0x00, 0x00, 0x00])) == .success(
                    ParseSucceeded(length: 4,  component: ChunkLength(0x0))
                )
            }
            it("00 00 00 10 -> 10") {
                expect(ChunkLength.parse([0x00, 0x00, 0x00, 0x10])) == .success(
                    ParseSucceeded(length: 4,  component: ChunkLength(0x10))
                )
            }
            it("00 00 11 11 -> 1111") {
                expect(ChunkLength.parse([0x00, 0x00, 0x11, 0x11])) == .success(
                    ParseSucceeded(length: 4,  component: ChunkLength(0x1111))
                )
            }
            it("00 11 11 11 -> 111111") {
                expect(ChunkLength.parse([0x00, 0x11, 0x11, 0x11])) == .success(
                    ParseSucceeded(length: 4,  component: ChunkLength(0x111111))
                )
            }
            it("11 11 11 11 -> 11111111") {
                expect(ChunkLength.parse([0x11, 0x11, 0x11, 0x11])) == .success(
                    ParseSucceeded(length: 4,  component: ChunkLength(0x11111111))
                )
            }
            it("FF FF FF FF -> FFFFFFFF") {
                expect(ChunkLength.parse([0xFF, 0xFF, 0xFF, 0xFF])) == .success(
                    ParseSucceeded(length: 4,  component: ChunkLength(0xFFFFFFFF))
                )
            }
            context("smfBytes is less than 4 bytes") {
                it("returns failure with length of smfBytes (3)") {
                    expect(ChunkLength.parse([0xFF, 0xFF, 0xFF])) == .failure(.length(3))
                }
                it("returns failure with length of smfBytes (2)") {
                    expect(ChunkLength.parse([0xFF, 0xFF])) == .failure(.length(2))
                }
                it("returns failure with length of smfBytes (1)") {
                    expect(ChunkLength.parse([0xFF])) == .failure(.length(1))
                }
                it("returns failure with length of smfBytes (0)") {
                    expect(ChunkLength.parse([])) == .failure(.length(0))
                }
            }
        }
        describe("smfBytes") {
            // hex
            it("0 -> 00 00 00 00") {
                expect(ChunkLength(0x0).smfBytes) == [0x00, 0x00, 0x00, 0x00]
            }
            it("10 -> 00 00 00 10") {
                expect(ChunkLength(0x10).smfBytes) == [0x00, 0x00, 0x00, 0x10]
            }
            it("1111 -> 00 00 11 11") {
                expect(ChunkLength(0x1111).smfBytes) == [0x00, 0x00, 0x11, 0x11]
            }
        }
    }
}
