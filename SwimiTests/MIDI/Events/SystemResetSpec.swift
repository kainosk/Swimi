//
//  SystemReset.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class SystemResetSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = SystemReset()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xFF`") {
                expect(SystemReset().bytes) == [0xFF]
            }
        }
        describe("fromData") {
            context("data length is 1") {
                it("returns an instance regardless of passed data") {
                    expect(SystemReset.fromData([0xFF])) == SystemReset()
                }
            }
            context("data length is not 1") {
                it("assert") {
                    expect {
                        _ = SystemReset.fromData([0x00, 0x11])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
