//
//  MIDIChannelPrefixSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/11.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class MIDIChannelPrefixSpec: QuickSpec {
    
    override func spec() {
        describe("init with channel") {
            let mcp = MIDIChannelPrefix(channel: 15)
            it("return passed value as is") {
                expect(mcp.channel) == 15
            }
        }
        describe("smfBytes") {
            it("returns 0xFF, 0x20, 0x01, and channel") {
                expect(MIDIChannelPrefix(channel: 7).smfBytes) == [
                    0xFF, 0x20, 0x01,
                    7
                ]
            }
        }
        describe("parse") {
            var result: ParseResult<MetaEvent<SS>>!
            context("smfBytes does not have prefix [0xFF, 0x20, 0x01]") {
                it("returns failure with length 0") {
                    result = MIDIChannelPrefix.parse([0xFF, 0x21, 0x01, 0x00, 0x11])
                    expect(result) == .failure(.length(0))
                }
            }
            context("smfBytes has prefix bytes but has no data") {
                it("returns failure with length smfBytes.count") {
                    result = MIDIChannelPrefix.parse([0xFF, 0x20, 0x01])
                    expect(result) == .failure(.length(3))
                }
            }
            context("smfBytes has prefix and has data (valid)") {
                it("returns success") {
                    result = MIDIChannelPrefix.parse([0xFF, 0x20, 0x01, 15, 0xFF, 0x00])
                    expect(result) == .success(
                        ParseSucceeded(
                            length: 4,
                            component: .midiChannelPrefix(channel: 15)
                        )
                    )
                }
            }
        }
    }
}
