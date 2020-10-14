//
//  SysExEventSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/17.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class SMFSysExEventSpec: QuickSpec {
    override func spec() {
        describe("parse") {
            var binary: [UInt8]!
            let execute = { SMFSysExEvent.parse(binary[...]) }
            context("smfBytes is F0 style") {
                it("returns success with F0SysExEvent") {
                    binary = [0xF0, 0x02, 0x33, 0x7F]
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: 4,
                            component: .f0Style(
                                F0SysExEvent(dataWithoutFirstF0: [0x33, 0x7F])
                            )
                        )
                    )
                }
            }
            context("smfBytes is F7 style") {
                it("returns success with F7SysExEvent") {
                    binary = [0xF7, 0x02, 0x44, 0x55]
                    expect(execute()) == .success(
                        ParseSucceeded(
                            length: 4,
                            component: .f7([0x44, 0x55])
                        )
                    )
                }
            }
            context("smfBytes is not SysEx Event") {
                it("returns failure with length 0") {
                    binary = [0x01, 0x02, 0x03]
                    expect(execute()) == .failure(ParseFailed(length: 0))
                }
            }
            context("smfBytes is F0 style but invalid") {
                it("returns failure with F0SysEx's failure length") {
                    binary = [0xF0, 0x03, 0x11, 0x22]
                    expect(execute()) == .failure(.length(4))
                }
            }
            context("smfBytes is F7 style but invalid") {
                it("returns failure with F7SysEx's failure length") {
                    binary = [0xF7, 0x03, 0x11, 0x22]
                    expect(execute()) == .failure(.length(4))
                }
            }
        }
        describe("smfBytes") {
            context("F0 style") {
                it("returns F0SysExEvent's smfBytes as is") {
                    let f0 = F0SysExEvent(dataWithoutFirstF0: [0x11, 0x22])
                    expect(SMFSysExEvent.f0Style(f0).smfBytes) == f0.smfBytes
                }
            }
            context("F7 style") {
                it("returns F7SysExEvent's smfBytes as is") {
                    let f7 = F7SysExEvent(data: [0x11, 0x22])
                    expect(SMFSysExEvent.f7Style(f7).smfBytes) == f7.smfBytes
                }
            }
        }
        describe("data") {
            context("F0 style") {
                it("returns F0SysExEvent's data as is") {
                    let f0 = F0SysExEvent(dataWithoutFirstF0: [0x11, 0x22])
                    expect(SMFSysExEvent.f0Style(f0).data) == f0.data
                }
            }
            context("F7 style") {
                it("returns F7SysExEvent's data as is") {
                    let f7 = F7SysExEvent(data: [0x11, 0x22])
                    expect(SMFSysExEvent.f7Style(f7).data) == f7.data
                }
            }
        }
        describe("convenience method") {
            it("f0 dataWithoutFirstF0") {
                let a: SMFSysExEvent = .f0Style(F0SysExEvent(dataWithoutFirstF0: [0x11]))
                let b: SMFSysExEvent = .f0(dataWithoutFirstF0: [0x11])
                expect(a) == b
            }
            it("f0 dataIncludingFirstF0") {
                let a: SMFSysExEvent =
                    .f0Style(F0SysExEvent(dataIncludingFirstF0: [0xF0, 0x11]))
                let b: SMFSysExEvent = .f0(dataIncludingFirstF0: [0xF0, 0x11])
                expect(a) == b
            }
            it("f7") {
                let a: SMFSysExEvent = .f7Style(F7SysExEvent(data: [0x11]))
                let b: SMFSysExEvent = .f7([0x11])
                expect(a) == b
            }
        }
    }
}
