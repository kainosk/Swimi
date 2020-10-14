//
//  TimingClock.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class TimingClockSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = TimingClock()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xF8`") {
                expect(TimingClock().bytes) == [0xF8]
            }
        }
        describe("fromData") {
            context("data length is 1") {
                it("returns an instance regardless of passed data") {
                    expect(TimingClock.fromData([0xFF])) == TimingClock()
                }
            }
            context("data length is not 1") {
                it("assert") {
                    expect {
                        _ = TimingClock.fromData([0x00, 0x11])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
