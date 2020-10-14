//
//  PitchBendChangeSpec.swift
//  SwimiTests
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class PitchBendChangeSpec: QuickSpec {
    override func spec() {
        describe("value") {
            var lsb: UInt8!
            var msb: UInt8!
            context("minimum lsb") {
                beforeEach {
                    lsb = 0
                }
                context("minimum msb") {
                    beforeEach {
                        msb = 0
                    }
                    it("0") {
                        let subject = PitchBendChange(channel: 5, lsb: lsb, msb: msb)
                        expect(subject.value).to(equal(0))
                    }
                }
                context("maximum msb") {
                    beforeEach {
                        msb = 0b01111111
                    }
                    it("16256") {
                        let subject = PitchBendChange(channel: 5, lsb: lsb, msb: msb)
                        expect(subject.value).to(equal(16256))
                    }
                }
            }
            context("maximum lsb") {
                beforeEach {
                    lsb = 0b01111111
                }
                context("minimum msb") {
                    beforeEach {
                        msb = 0
                    }
                    it("127") {
                        let subject = PitchBendChange(channel: 5, lsb: lsb, msb: msb)
                        expect(subject.value).to(equal(127))
                    }
                }
                context("maximum msb") {
                    beforeEach {
                        msb = 0b01111111
                    }
                    it("16383") {
                        let subject = PitchBendChange(channel: 5, lsb: lsb, msb: msb)
                        expect(subject.value).to(equal(16383))
                    }
                }
            }
        }
        describe("bytes") {
            it("returns its (status byte E0 | channel), lsb and msb") {
                expect(PitchBendChange(channel: 15, lsb: 10, msb: 20).bytes)
                    == [
                        0xE0 | 15,
                        10,
                        20
                ]
            }
        }
        describe("fromData") {
            context("data length is 3") {
                it("returns an instance: channel as 4 ~ 8 bit of first byte, lsb as second byte, msb as third byte") {
                    expect(PitchBendChange.fromData([0xEE, 11, 22]))
                        == PitchBendChange(channel: 14, lsb: 11, msb: 22)
                }
            }
            context("data length is not 3") {
                it("assert") {
                    expect {
                        _ = PitchBendChange.fromData([0x00, 0x00, 0x00, 0x00])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
