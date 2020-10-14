//
//  Stop.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class StopSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = Stop()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xFC`") {
                expect(Stop().bytes) == [0xFC]
            }
        }
        describe("fromData") {
            context("data length is 1") {
                it("returns an instance regardless of passed data") {
                    expect(Stop.fromData([0xFF])) == Stop()
                }
            }
            context("data length is not 1") {
                it("assert") {
                    expect {
                        _ = Stop.fromData([0x00, 0x11])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
