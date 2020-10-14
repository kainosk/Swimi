//
//  PolyphinicKeyvelocitySpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class NoteOnSpec: QuickSpec {
    override func spec() {
        describe("init") {
            let pkp = NoteOn(channel: 0, note: 55, velocity: 123)
            it("can be initialized with channel, note, velocity") {
                // omitted
            }
            it("returns passed channel as is") {
                expect(pkp.channel) == 0
            }
            it("returns passed note as is") {
                expect(pkp.note) == 55
            }
            it("returns passed velocity as is") {
                expect(pkp.velocity) == 123
            }
        }
        describe("bytes") {
            it("returns (status type 90 | channel), note, velocity") {
                let pkp = NoteOn(channel: 9, note: 127, velocity: 126)
                expect(pkp.bytes) == [
                    UInt8(0x90 | 9),
                    127,
                    126
                ]
            }
        }
        describe("fromData") {
            context("data length is 3") {
                it("returns an instance which has 4 ~ 8 bit of first byte as channel, second byte as note, third byte as velocity") {
                    expect(NoteOn.fromData([0x9F, 0, 0]))
                        == NoteOn(channel: 0x0F, note: 0, velocity: 0)
                }
            }
            context("data length is not 3") {
                it("assert") {
                    expect {
                        _ = NoteOn.fromData([0x00])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
