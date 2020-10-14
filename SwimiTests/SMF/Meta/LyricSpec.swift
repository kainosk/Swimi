//
//  LyricSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/11.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class LyricSpec: QuickSpec {
    override func spec() {
        describe("init with data") {
            it("can be initialized any data and it provides smfBytes") {
                let data: [UInt8] = [0xFF, 0xFF, 0xFF]
                let lyric = Lyric(data: data)
                expect(lyric.smfBytes) == [0xFF, 0x05, UInt8(data.count)] + data
            }
        }
        describe("parse") {
            it("Success:") {
                let binary: [UInt8] = [0xFF, 0x05, 0x03, 0xFF, 0xFF, 0xFF]
                let result: ParseResult<MetaEvent<SS>> = Lyric.parse(binary[...])
                expect(result) == .success(
                    ParseSucceeded(length: 6, component: .lyric([0xFF, 0xFF, 0xFF]))
                )
            }
            it("Failure: Prefix is not match") {
                let binary: [UInt8] = [0xFF, 0x04, 0x03, 0xFF, 0xFF, 0xFF]
                let result: ParseResult<MetaEvent<SS>> = Lyric.parse(binary[...])
                expect(result) == .failure(.length(0))
            }
            it("Failure: Length is invalid") {
                let binary: [UInt8] = [0xFF, 0x05, 0xFF, 0xFF, 0xFF, 0xFF]
                let result: ParseResult<MetaEvent<SS>> = Lyric.parse(binary[...])
                expect(result) == .failure(.length(binary.count))
            }
        }
    }
}
