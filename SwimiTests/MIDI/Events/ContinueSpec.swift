//
//  Continue.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class ContinueSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = Continue()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xFB`") {
                expect(Continue().bytes) == [0xFB]
            }
        }
        describe("fromData") {
            context("data length is 1") {
                it("returns an instance regardless of passed data") {
                    expect(Continue.fromData([0xFF])) == Continue()
                }
            }
            context("data length is not 1") {
                it("assert") {
                    expect {
                        _ = Continue.fromData([0x00, 0x11])
                    }.to(throwAssertion())
                }
            }
        }
    }
}

