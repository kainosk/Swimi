//
//  F0SysExEventSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/08/31.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class F0SysExEventSpec: QuickSpec {
    override func spec() {
        describe("init and smfBytes") {
            let binary: [UInt8] = [0xF0, 0x11, 0x22, 0x7F]
            let smfBytes: [UInt8] = [0xF0, 0x03, 0x11, 0x22, 0x7F]
            let event: F0SysExEvent = F0SysExEvent(dataIncludingFirstF0: binary)
            
            describe("dataIncludingFirstF0") {
                it("can be initialized with data including F0") {
                    expect(F0SysExEvent(dataIncludingFirstF0: binary)) == event
                }
                it("can make smfBytes") {
                    expect(event.smfBytes) == smfBytes
                }
                it("throw assertion if first byte is not F0") {
                    expect {
                        _ = F0SysExEvent(dataIncludingFirstF0: [0x11, 0x22, 0x7F])
                    }.to(throwAssertion())
                }
            }
            describe("dataWithoutFirstF0") {
                
                it("can be initialized with data without first F0") {
                    expect(
                        F0SysExEvent(dataWithoutFirstF0: Array(binary.dropFirst()))
                    ) == event
                }
                it("can make smfBytes") {
                    expect(event.smfBytes) == smfBytes
                }
            }
        }
        
        describe("encode and decode") {
            describe("Success: Simple SysEx length 4") {
                let binary: [UInt8] = [
                    0xF0, 0x03, 0x11, 0x22, 0x7F
                ]
                let correct = F0SysExEvent(
                    dataIncludingFirstF0: [0xF0, 0x11, 0x22, 0x7F]
                )
                it("can parse") {
                    let result = F0SysExEvent.parse(binary[...])
                    expect(result) ==
                        .success(ParseSucceeded(length: 5, component: correct))
                }
                it("can encode") {
                    expect(correct.smfBytes) == binary
                }
            }
            describe("Failure: First byte is not F0") {
                let binary: [UInt8] = [0xF1, 0x03, 0x11, 0x22, 0x7F]
                it("can not parse with failure length 0") {
                    expect(F0SysExEvent.parse(binary[...]))
                        == .failure(ParseFailed(length: 0))
                }
            }
            describe("Failure: Length is not invalid") {
                let binary: [UInt8] = [0xF0, 0xFF, 0xFF, 0xFF]
                it("can not parse with failure") {
                    expect(F0SysExEvent.parse(binary[...])) == .failure(.length(4))
                }
            }
            describe("Failure: Lengh is valid but not enough data") {
                let binary: [UInt8] = [0xF0, 0x03, 0xFF, 0xFF]
                it("can not parse with failure") {
                    expect(F0SysExEvent.parse(binary[...])) == .failure(.length(4))
                }
            }
        }
        describe("data: will set") {
            it("assert if first byte is not F0") {
                var event = F0SysExEvent(dataIncludingFirstF0: [0xF0, 0x11, 0x7F])
                expect {
                    event.data = [0x11, 0x7F]
                }.to(throwAssertion())
            }
        }
    }
}
