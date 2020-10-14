//
//  DeltaTimeFormatSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/16.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class DeltaTimeFormatSpec: QuickSpec {
    override func spec() {
        describe("smfBytes") {
            it("ticksPerQuarterNote(0x3333) -> 0x33 0x33") {
                expect(DeltaTimeFormat.ticksPerQuarterNote(0x3333).smfBytes) == [0x33, 0x33]
            }
            it("smpte -> fatalError") {
                // Currently SMPTE is not supported.
                expect {
                    _ = DeltaTimeFormat.smpte.smfBytes
                }.to(throwAssertion())
            }
        }
        describe("parse") {
            var binary: [UInt8]!
            let execute = { DeltaTimeFormat.parse(binary[...]) }
            
            context("smfBytes is less than 2 bytes") {
                it("returns failure with length as smfBytes.count") {
                    binary = [0x12]
                    expect(execute()) == .failure(.length(1))
                }
            }
            context("smfBytes is greater than 2 bytes") {
                context("first bytes's msb is 1") {
                    it("returns success with .smpte") {
                        binary = [0b10001111, 0b00000000]
                        expect(execute()) == .success(
                            ParseSucceeded(length: 2, component: .smpte)
                        )
                    }
                }
                context("first bytes's msb is 0") {
                    it("returns success with ticksPerQuarterNote") {
                        binary = [0x12, 0x34]
                        expect(execute()) == .success(
                            ParseSucceeded(
                                length: 2,
                                component: .ticksPerQuarterNote(0x1234)
                            )
                        )
                    }
                }
            }
        }
    }
}
