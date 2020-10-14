//
//  ProgramChangeSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class ProgramChangeSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized with channel and program") {
                _ = ProgramChange(channel: 0, program: 123)
            }
            it("returns passed channel as is") {
                expect(ProgramChange(channel: 0, program: 123).channel) == 0
            }
            it("returns passed program as is") {
                expect(ProgramChange(channel: 5, program: 99).program) == 99
            }
        }
        describe("bytes") {
            it("returns (status type C0 | channel), program") {
                expect(ProgramChange(channel: 9, program: 126).bytes) == [
                    0xC0 | 9,
                    126
                ]
            }
        }
        describe("fromData") {
            context("data length is 2") {
                it("returns an instance which has second byte as song number") {
                    expect(ProgramChange.fromData([0xCF, 0x60]))
                        == ProgramChange(channel: 0x0F, program: 0x60)
                }
            }
            context("data length is not 2") {
                it("assert") {
                    expect {
                        _ = ProgramChange.fromData([0x00])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
