//
//  UndefinedSystemCommonMessage2.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class UndefinedSystemCommonMessage2Spec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = UndefinedSystemCommonMessage2()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xF5`") {
                expect(UndefinedSystemCommonMessage2().bytes) == [0xF5]
            }
        }
        describe("fromData") {
            it("returns an instance regardless of passed data") {
                expect(UndefinedSystemCommonMessage2.fromData([0xFF, 0xFF, 0xFF]))
                    == UndefinedSystemCommonMessage2()
            }
        }
    }
}
