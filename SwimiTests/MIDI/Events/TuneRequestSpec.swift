//
//  TuneRequest.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class TuneRequestSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = TuneRequest()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xF6`") {
                expect(TuneRequest().bytes) == [0xF6]
            }
        }
        describe("fromData") {
            context("data length is 1") {
                it("returns an instance regardless of passed data") {
                    expect(TuneRequest.fromData([0xFF])) == TuneRequest()
                }
            }
            context("data length is not 1") {
                it("assert") {
                    expect {
                        _ = TuneRequest.fromData([0x00, 0x11])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
