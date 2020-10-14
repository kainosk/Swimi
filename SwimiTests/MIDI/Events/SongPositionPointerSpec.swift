//
//  SongPositionPointerSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class SongPositionPointerSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized with lsb and msb") {
                _ = SongPositionPointer(lsb: 10, msb: 20)
            }
            it("returns passed lsb as is") {
                expect(SongPositionPointer(lsb: 10, msb: 20).lsb) == 10
            }
            it("returns passed msb as is") {
                expect(SongPositionPointer(lsb: 10, msb: 20).msb) == 20
            }
        }
        describe("bytes") {
            it("returns its status byte `0xF2` and lsb, msb") {
                expect(SongPositionPointer(lsb: 10, msb: 20).bytes) == [0xF2, 10, 20]
            }
        }
        describe("fromData") {
            context("data length is 3") {
                it("returns an instance which has second byte as lsb, third byte as msb") {
                    expect(SongPositionPointer.fromData([0xFF, 11, 22]))
                        == SongPositionPointer(lsb: 11, msb: 22)
                }
            }
            context("data length is not 3") {
                it("assert") {
                    expect {
                        _ = SongPositionPointer.fromData([0xFF, 11, 22, 33])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
