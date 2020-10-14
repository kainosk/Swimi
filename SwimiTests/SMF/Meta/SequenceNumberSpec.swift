//
//  SequenceNumberSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/11.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class SequenceNumberSpec: QuickSpec {
    
    override func spec() {
        describe("init with value") {
            let sn = SequenceNumber(1)
            it("return passed value as is") {
                expect(sn.value) == 1
            }
            context("passed value is greater than 0xFFFF") {
                it("fatalError") {
                    expect {
                        _ = SequenceNumber(0xFFFF + 1)
                    }.to(throwAssertion())
                }
            }
        }
        describe("smfBytes") {
            it("returns 0xFF, 0x00, 0x02, and value as two bytes") {
                expect(SequenceNumber(0xFFFF).smfBytes) == [
                    0xFF, 0x00, 0x02,
                    0xFF, 0xFF
                ]
            }
        }
        describe("parse") {
            var result: ParseResult<MetaEvent<SS>>!
            context("smfBytes does not have prefix [0xFF, 0x00, 0x02]") {
                
                it("returns failure with length 0") {
                    result = SequenceNumber.parse([0xFF, 0x01, 0x02, 0x00, 0x11])
                    expect(result) == .failure(.length(0))
                }
            }
            context("smfBytes has prefix bytes but data is less than 2 bytes") {
                it("returns failure with length smfBytes.count") {
                    result = SequenceNumber.parse([0xFF, 0x00, 0x02, 0x00])
                    expect(result) == .failure(.length(4))
                }
            }
            context("smfBytes has prefix and data length is two (valid)") {
                it("returns success") {
                    result = SequenceNumber.parse([0xFF, 0x00, 0x02, 0xFF, 0xFF, 0x00])
                    expect(result) == .success(
                        ParseSucceeded(
                            length: 5,
                            component: .sequenceNumber(0xFFFF)
                        )
                    )
                }
            }
        }
    }
}
