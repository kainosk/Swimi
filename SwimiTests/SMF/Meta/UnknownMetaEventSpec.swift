//
//  UnknownMetaEventSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class UnknownMetaEventSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("has passed data as is") {
                let event = UnknownMetaEvent(smfBytes: [0x00, 0x11])
                expect(event.smfBytes) == [0x00, 0x11]
            }
        }
        describe("parse") {
            var smfBytes: [UInt8]!
            var result: ParseResult<MetaEvent<SS>>!
            let executeParse: () -> ParseResult<MetaEvent<SS>> = {
                result = UnknownMetaEvent.parse(smfBytes[...])
                return result
            }
            
            context("smfBytes does not have prefix `0xFF`") {
                beforeEach {
                    smfBytes = [0x00, 0x11, 0x22]
                }
                it("returns failure with length 0") {
                    expect(executeParse()) == .failure(.length(0))
                }
            }
            context("smfBytes has prefix `0xFF` but does not have at least 3 bytes") {
                beforeEach {
                    smfBytes = [0xFF, 0x00]
                }
                it("returns failure with length 0") {
                    expect(executeParse()) == .failure(.length(0))
                }
            }
            context("smfBytes has prefix `0xFF` but does not have enough data") {
                beforeEach {
                    smfBytes = [0xFF, 0x60, 0x05, 0x00, 0x11, 0x22, 0x33]
                }
                it("returns failure with same length as smfBytes") {
                    expect(executeParse()) == .failure(.length(smfBytes.count))
                }
            }
            context("smfBytes has invalid length") {
                beforeEach {
                    smfBytes = [0xFF, 0x60, 0xFF, 0xFF]
                }
                it("returns failure with same length as smfBytes") {
                    expect(executeParse()) == .failure(.length(smfBytes.count))
                }
            }
            context("smfBytes has valid data") {
                beforeEach {
                    smfBytes = [
                        0xFF,             // prefix
                        0x60,             // type
                        0x02,             // length
                        0x00, 0x11,       // data
                        0x22              // this is not part of meta event but still valid.
                    ]
                }
                it("returns success with length 5.") {
                    expect(executeParse()) == .success(
                        ParseSucceeded(
                            length: 5,
                            component: .unknown(
                                UnknownMetaEvent(smfBytes: [0xFF, 0x60, 0x02, 0x00, 0x11])
                            )
                        )
                    )
                }
            }
        }
    }
}
