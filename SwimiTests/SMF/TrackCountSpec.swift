//
//  TrackCountSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/16.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class TrackCountSpec: QuickSpec {
    override func spec() {
        describe("init with numberOfTracks") {
            it("returns passed numberOfTracks as is") {
                expect(TrackCount(99).numberOfTracks) == 99
            }
        }
        describe("smfBytes") {
            it("returns numberOfTracks as two byte") {
                expect(TrackCount(0xFFFF).smfBytes) == [0xFF, 0xFF]
                expect(TrackCount(0x0000).smfBytes) == [0x00, 0x00]
                expect(TrackCount(0x1234).smfBytes) == [0x12, 0x34]
            }
        }
        describe("parse") {
            context("smfBytes is less than two bytes") {
                it("returns failure with length of smfBytes") {
                    expect(TrackCount.parse([0x01])) == .failure(.length(1))
                }
            }
            context("smfBytes is greater than two bytes") {
                it("returns success with Int as prefix two bytes") {
                    expect(TrackCount.parse([0x12, 0x34, 0x45])) == .success(
                        ParseSucceeded(length: 2, component: TrackCount(0x1234))
                    )
                }
            }
        }
    }
}
