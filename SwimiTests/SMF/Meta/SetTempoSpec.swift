//
//  SetTempoSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/11.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class SetTempoSpec: QuickSpec {
    
    override func spec() {
        describe("init with bpm") {
            let t = SetTempo(bpm: 120)
            it("returns passed bpm as is") {
                expect(t.bpm) == 120
            }
            it("returns microsecondsPerQuarterNote from bpm") {
                expect(t.microsecondsPerQuarterNote) == 500_000 // 60 / 120 * 1000000
            }
        }
        describe("init with microsecondsPerQuarterNote") {
            let t = SetTempo(microsecondsPerQuarterNote: 500_000)
            it("returns passed microsecondsPerQuarterNote as is") {
                expect(t.microsecondsPerQuarterNote) == 500_000
            }
            it("returns bpm from microsecondsPerQuarterNote") {
                expect(t.bpm).to(beCloseTo(120, within: 0.000001))
            }
        }
        
        describe("smfBytes") {
            it("returns 0xFF, 0x51, 0x03, and value as 3 bytes") {
                expect(SetTempo(microsecondsPerQuarterNote: 0xFFFFFF).smfBytes) == [
                    0xFF, 0x51, 0x03,
                    0xFF, 0xFF, 0xFF
                ]
            }
        }
        describe("parse") {
            var result: ParseResult<MetaEvent<SS>>!
            context("smfBytes does not have prefix [0xFF, 0x51, 0x03]") {
                
                it("returns failure with length 0") {
                    result = SetTempo.parse([0xFF, 0x52, 0x03, 0x00, 0x11, 0x22])
                    expect(result) == .failure(.length(0))
                }
            }
            context("smfBytes has prefix bytes but data is less than 3 bytes") {
                it("returns failure with length smfBytes.count") {
                    result = SetTempo.parse([0xFF, 0x51, 0x03, 0x00, 0x01])
                    expect(result) == .failure(.length(5))
                }
            }
            context("smfBytes has prefix and data length greater than 3 (valid)") {
                it("returns success") {
                    result = SetTempo.parse([0xFF, 0x51, 0x03, 0x11, 0x22, 0x33, 0x44])
                    expect(result) == .success(
                        ParseSucceeded(
                            length: 6,
                            component: .setTempo(
                                SetTempo(microsecondsPerQuarterNote: 0x11_22_33)
                            )
                        )
                    )
                }
            }
        }
    }
}
