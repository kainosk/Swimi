//
//  TimecodeQuarterFrameSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class TimecodeQuarterFrameSpec: QuickSpec {
    override func spec() {
        describe("init") {
            let tcqf = TimeCodeQuarterFrame(messageType: .minuteCountLower4bit, value: 10)
            it("can be initialized with type and value") {
                // ommited
            }
            it("returns passed type as is") {
                expect(tcqf.messageType) == .minuteCountLower4bit
            }
            it("returns passed value as is") {
                expect(tcqf.value) == 10
            }
        }
        describe("bytes") {
            it("returns its status byte `0xF1`, and one byte: 2 ~ 4 bit is type, 5 ~ 8 bit is value") {
                let tcqf = TimeCodeQuarterFrame(
                    messageType: .frameCountLower4bit,
                    value: 11
                )
                expect(tcqf.bytes) == [
                    0xF1,
                    tcqf.messageType.rawValue << 4 | 11
                ]
            }
        }
        describe("fromData") {
            context("data length is 2") {
                it("returns an instance which has type as 2 ~ 4 bit, value as 5 ~ 8 bit") {
                    expect(TimeCodeQuarterFrame.fromData([0xFF, 7 << 4 | 6]))
                        == TimeCodeQuarterFrame(messageType: .timeCountUpper4bit, value: 6)
                }
            }
            context("data length is not 2") {
                it("assert") {
                    expect {
                        _ = TimeCodeQuarterFrame.fromData([0xFF, 11, 22, 33])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
