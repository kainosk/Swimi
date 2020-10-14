//
//  PolyphinicKeyPressureSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class PolyphonicKeyPressureSpec: QuickSpec {
    override func spec() {
        describe("init") {
            let pkp = PolyphonicKeyPressure(channel: 0, note: 55, pressure: 123)
            it("can be initialized with channel, note, pressure") {
                // omitted
            }
            it("returns passed channel as is") {
                expect(pkp.channel) == 0
            }
            it("returns passed note as is") {
                expect(pkp.note) == 55
            }
            it("returns passed pressure as is") {
                expect(pkp.pressure) == 123
            }
        }
        describe("bytes") {
            it("returns (status type A0 | channel), note, pressure") {
                let pkp = PolyphonicKeyPressure(channel: 9, note: 127, pressure: 126)
                expect(pkp.bytes) == [
                    UInt8(0xA0 | 9),
                    127,
                    126
                ]
            }
        }
        describe("fromData") {
            context("data length is 3") {
                it("returns an instance which has 4 ~ 8 bit of first byte as channel, second byte as note, third byte as pressure") {
                    expect(PolyphonicKeyPressure.fromData([0xAF, 0, 0]))
                        == PolyphonicKeyPressure(channel: 0x0F, note: 0, pressure: 0)
                }
            }
            context("data length is not 3") {
                it("assert") {
                    expect {
                        _ = PolyphonicKeyPressure.fromData([0x00])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
