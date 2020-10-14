//
//  UnknownChunkSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class UnknownChunkSpec: QuickSpec {
    override func spec() {
        describe("init") {
            var chunk: UnknownChunk!
            let data: [UInt8] = [0x00, 0x11, 0x12]
            let type: ChunkType = .unknown("ABCDE")
            beforeEach {
                chunk = UnknownChunk(
                    type: type,
                    data: data
                )
            }
            it("has passed data as is") {
                expect(chunk.data) == data
            }
            it("has passed chunk type as is") {
                expect(chunk.type) == type
            }
        }
    }
}
