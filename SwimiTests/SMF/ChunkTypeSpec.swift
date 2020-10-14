//
//  ChunkTypeSpec.swift
//  SwimiTests
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class ChunkTypeSpec: QuickSpec {
    override func spec() {
        describe("init") {
            context("passed string's length is not 4") {
                it("throw fatalError") {
                    expect {
                        _ = ChunkType("12345")
                    }.to(throwAssertion())
                }
            }
            context("passed string's length is 4") {
                context("string is MThd") {
                    it("returns header") {
                        expect(ChunkType("MThd")) == .header
                    }
                }
                context("string is MTrk") {
                    it("returns track") {
                        expect(ChunkType("MTrk")) == .track
                    }
                }
                context("others") {
                    it("returns unknown with passed string") {
                        expect(ChunkType("MYCH")) == .unknown("MYCH")
                    }
                }
            }
        }
        describe("parse") {
            it("[0x4D, 0x54, 0x68, 0x64] -> .header") {
                expect(ChunkType.parse([0x4D, 0x54, 0x68, 0x64])) == .success(
                    ParseSucceeded(length: 4, component: .header)
                )
            }
            it("[0x4D, 0x54, 0x72, 0x6B] -> .track") {
                expect(ChunkType.parse([0x4D, 0x54, 0x72, 0x6B])) == .success(
                    ParseSucceeded(length: 4, component: .track)
                )
            }
            it("[0x58, 0x46, 0x49, 0x48] -> .unknown(XFIH)") {
                expect(ChunkType.parse([0x58, 0x46, 0x49, 0x48])) == .success(
                    ParseSucceeded(length: 4, component: .unknown("XFIH"))
                )
            }
        }
        describe("smfBytes") {
            it(".header -> [0x4D, 0x54, 0x68, 0x64]") {
                // MThd
                expect(ChunkType.header.smfBytes) == [0x4D, 0x54, 0x68, 0x64]
            }
            it(".track -> [0x4D, 0x54, 0x72, 0x6B]") {
                // MTrk
                expect(ChunkType.track.smfBytes) == [0x4D, 0x54, 0x72, 0x6B]
            }
            it(".unknown(XFIH) -> [0x58, 0x46, 0x49, 0x48]") {
                expect(ChunkType.unknown("XFIH").smfBytes) == [0x58, 0x46, 0x49, 0x48]
            }
        }
    }
}

