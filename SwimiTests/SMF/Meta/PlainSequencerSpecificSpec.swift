//
//  PlainSequencerSpecificSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/16.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class PlainSequencerSpecificSpec: QuickSpec {
    override func spec() {
        describe("init with dataWithoutPrefix") {
            it("returns passed data as is") {
                expect(PlainSequencerSpecific(dataWithoutPrefix: [0x00, 0x11]).data)
                    == [0x00, 0x11]
            }
        }
        
        describe("smfBytes") {
            it("returns prefix 0xFF, 0x7F, data length, data ") {
                expect(
                    PlainSequencerSpecific(dataWithoutPrefix: [0x00, 0x11, 0x22]).smfBytes
                ) == [0xFF, 0x7F, 0x03, 0x00, 0x11, 0x22]
            }
        }
        describe("parse") {
            var binary: [UInt8]!
            let execute: () -> ParseResult<PlainSequencerSpecific> = {
                PlainSequencerSpecific.parse(binary[...])
            }
            context("smfBytes does not have prefix 0xFF 0x7F") {
                it("returns failure with length 0") {
                    binary = [0xFF, 0x7E, 0x02, 0x11, 0x22]
                    expect(execute()) == .failure(.length(0))
                }
            }
            context("smfBytes has prefix 0xFF 0x7F") {
                context("invalid length") {
                    it("returns failure with length of smfBytes.count") {
                        binary = [0xFF, 0x7F, 0xFF, 0xFF]
                        expect(execute()) == .failure(.length(binary.count))
                    }
                }
                context("valid length") {
                    context("but has not enough data") {
                        it("returns failure with length of smfBytes.count") {
                            binary = [0xFF, 0x7F, 0x02, 0xFF]
                            expect(execute()) == .failure(.length(binary.count))
                        }
                    }
                    context("has enough data") {
                        it("returns success") {
                            binary = [0xFF, 0x7F, 0x03, 0x00, 0x11, 0x22]
                            expect(execute()) == .success(
                                ParseSucceeded(
                                    length: 6,
                                    component: PlainSequencerSpecific(
                                        dataWithoutPrefix: [0x00, 0x11, 0x22]
                                    )
                                )
                            )
                        }
                    }
                }
            }
        }
    }
}
