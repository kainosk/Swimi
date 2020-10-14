//
//  F7SysExEventSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/08/31.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class F7SysExEventSpec: QuickSpec {
    override func spec() {
        describe("init and smfBytes") {
            let binary: [UInt8] = [0x00, 0x11, 0x22, 0x33]
            let smfBytes: [UInt8] = [0xF7, 0x04, 0x00, 0x11, 0x22, 0x33]
            let event: F7SysExEvent = F7SysExEvent(data: binary)
            
            
            it("can be initialized with any data") {
                expect(F7SysExEvent(data: binary)) == event
            }
            it("can make smfBytes: (F7, length, data)") {
                expect(event.smfBytes) == smfBytes
            }
        }
        
        describe("encode and decode") {
            describe("Success: Simple bytes length 4") {
                let binary: [UInt8] = [
                    0xF7, 0x03, 0x11, 0x22, 0x33
                ]
                let correct = F7SysExEvent(
                    data: [0x11, 0x22, 0x33]
                )
                it("can parse") {
                    let result = F7SysExEvent.parse(binary[...])
                    expect(result) ==
                        .success(ParseSucceeded(length: 5, component: correct))
                }
                it("can encode") {
                    expect(correct.smfBytes) == binary
                }
            }
            describe("Failure: Length is not invalid") {
                let binary: [UInt8] = [0xF7, 0xFF, 0xFF, 0xFF]
                it("can not parse with failure") {
                    expect(F7SysExEvent.parse(binary[...])) == .failure(.length(4))
                }
            }
            describe("Failure: First bytes is not F7") {
                let binary: [UInt8] = [0xF0, 0xFF, 0xFF, 0xFF]
                it("can not parse with failure") {
                    expect(F7SysExEvent.parse(binary[...])) == .failure(.length(0))
                }
            }
        }
    }
}
