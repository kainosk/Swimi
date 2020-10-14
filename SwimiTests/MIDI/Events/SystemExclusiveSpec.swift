//
//  SystemExclusiveSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class SystemExclusiveSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized with any data") {
                _ = SystemExclusive(rawData: [0xF0, 0xFF, 0xFF, 0x7F])
            }
            it("returns rawData as is") {
                expect(SystemExclusive(rawData: [0xFF, 0xFF, 0xFF]).rawData)
                    == [0xFF, 0xFF, 0xFF]
            }
        }
        describe("fromData") {
            it("returns an instance which has rawData as is") {
                expect(SystemExclusive.fromData([0xFF, 0xFF, 0xFF]))
                    == SystemExclusive(rawData: [0xFF, 0xFF, 0xFF])
            }
        }
    }
}
