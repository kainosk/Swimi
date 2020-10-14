//
//  FormatSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/16.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class FormatSpec: QuickSpec {
    override func spec() {
        describe("init from smf byte") {
            it("0 -> zero") {
                expect(Format(0)) == .zero
            }
            it("1 -> one") {
                expect(Format(1)) == .one
            }
            it("2 -> two") {
                expect(Format(2)) == .two
            }
            it("greater than two -> others(value)") {
                expect(Format(3)) == .others(3)
                expect(Format(0xFFFF)) == .others(0xFFFF)
            }
            context("value is larger than 0xFFFF") {
                it("fatalError: value must be represented as 2 bytes") {
                    expect {
                        _ = Format(0xFFFF + 1)
                    }.to(throwAssertion())
                }
            }
        }
        describe("smfBytes") {
            it("zero -> 0x00 0x00") {
                expect(Format.zero.smfBytes) == [0x00, 0x00]
            }
            it("one -> 0x00 0x01") {
                expect(Format.one.smfBytes) == [0x00, 0x01]
            }
            it("two -> 0x00 0x02") {
                expect(Format.two.smfBytes) == [0x00, 0x02]
            }
            it("others -> represent in 2 bytes") {
                expect(Format.others(0x0000).smfBytes) == [0x00, 0x00]
                expect(Format.others(0x5432).smfBytes) == [0x54, 0x32]
                expect(Format.others(0xFFFF).smfBytes) == [0xFF, 0xFF]
            }
        }
        describe("parse") {
            var binary: [UInt8]!
            let execute = { Format.parse(binary[...]) }
            
            context("smfBytes is less than 2 bytes") {
                it("returns failure with length as smfBytes.count") {
                    binary = [0x12]
                    expect(execute()) == .failure(.length(1))
                }
            }
            context("smfBytes is greater than 2 bytes") {
                it("returns success: pattern zero") {
                    binary = [0x00, 0x00, 0xFF]
                    expect(execute()) == .success(
                        ParseSucceeded(length: 2, component: .zero)
                    )
                }
                it("returns success: pattern one") {
                    binary = [0x00, 0x01, 0xFF]
                    expect(execute()) == .success(
                        ParseSucceeded(length: 2, component: .one)
                    )
                }
                it("returns success: pattern two") {
                    binary = [0x00, 0x02, 0xFF]
                    expect(execute()) == .success(
                        ParseSucceeded(length: 2, component: .two)
                    )
                }
                it("returns success: pattern others 1") {
                    binary = [0x00, 0x03, 0xFF]
                    expect(execute()) == .success(
                        ParseSucceeded(length: 2, component: .others(3))
                    )
                }
                it("returns success: pattern others 2") {
                    binary = [0xAB, 0xCD, 0xFF]
                    expect(execute()) == .success(
                        ParseSucceeded(length: 2, component: .others(0xABCD))
                    )
                }
            }
        }
    }
}
