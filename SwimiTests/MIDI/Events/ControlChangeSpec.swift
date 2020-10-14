//
//  ControlChangeSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class ControlChangeSpec: QuickSpec {
    override func spec() {
        describe("init") {
            let cc = ControlChange(
                channel: 6,
                controlNumber: .breathController,
                value: 100
            )
            it("can be initialized with channel, controlNumber and value") {
                // omitted
            }
            it("returns passed channel as is") {
                expect(cc.channel) == 6
            }
            it("returns passed controlNumber as is") {
                expect(cc.controlNumber) == .breathController
            }
        }
        describe("bytes") {
            it("returns (status type B0 | channel), controlNumber and value") {
                let cc = ControlChange(channel: 15, controlNumber: .balance, value: 123)
                expect(cc.bytes) == [
                    UInt8(0xB0 | 0x0F),
                    ControlNumber.balance.rawValue,
                    123
                ]
            }
        }
        describe("fromData") {
            context("data length is 3") {
                it("returns an instance which has 4 ~ 8 bit of first byte as channel, second byte as controlNumber, third byte as value") {
                    // ControlNumber 0x20 is bankSelectLSB
                    let correct = ControlChange(
                        channel: 14,
                        controlNumber: .bankSelectLSB,
                        value: 66
                    )
                    expect(ControlChange.fromData([0xBE, 0x20, 66])) == correct
                }
            }
            context("data length is not 3") {
                it("assert") {
                    expect {
                        _ = ControlChange.fromData([0x00])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
