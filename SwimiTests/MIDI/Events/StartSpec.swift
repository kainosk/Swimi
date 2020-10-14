//
//  Start.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class StartSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = Start()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xFA`") {
                expect(Start().bytes) == [0xFA]
            }
        }
        describe("fromData") {
            context("data length is 1") {
                it("returns an instance regardless of passed data") {
                    expect(Start.fromData([0xFF])) == Start()
                }
            }
            context("data length is not 1") {
                it("assert") {
                    expect {
                        _ = Start.fromData([0x00, 0x11])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
