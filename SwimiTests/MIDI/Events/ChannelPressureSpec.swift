//
//  ChannelPressureSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class ChannelPressureSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized with channel and pressure") {
                _ = ChannelPressure(channel: 0, pressure: 123)
            }
            it("returns passed channel as is") {
                expect(ChannelPressure(channel: 0, pressure: 123).channel) == 0
            }
            it("returns passed pressure as is") {
                expect(ChannelPressure(channel: 5, pressure: 99).pressure) == 99
            }
        }
        describe("bytes") {
            it("returns (status type D0 | channel), pressure") {
                expect(ChannelPressure(channel: 9, pressure: 126).bytes) == [
                    0xD0 | 9,
                    126
                ]
            }
        }
        describe("fromData") {
            context("data length is 2") {
                it("returns an instance which has second byte as song number") {
                    expect(ChannelPressure.fromData([0xDF, 0x60]))
                        == ChannelPressure(channel: 0x0F, pressure: 0x60)
                }
            }
            context("data length is not 2") {
                it("assert") {
                    expect {
                        _ = ChannelPressure.fromData([0x00])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
