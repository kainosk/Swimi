//
//  SongSelectSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class SongSelectSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized with song number") {
                _ = SongSelect(songNumber: 120)
            }
            it("returns passed songNumber as is") {
                expect(SongSelect(songNumber: 123).songNumber) == 123
            }
        }
        describe("bytes") {
            it("returns its status byte `0xF3` and song number") {
                expect(SongSelect(songNumber: 123).bytes) == [0xF3, 123]
            }
        }
        describe("fromData") {
            context("data length is 2") {
                it("returns an instance which has second byte as song number") {
                    expect(SongSelect.fromData([0xFF, 0x60]))
                        == SongSelect(songNumber: 0x60)
                }
            }
            context("data length is not 2") {
                it("assert") {
                    expect {
                        _ = SongSelect.fromData([0x00])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
