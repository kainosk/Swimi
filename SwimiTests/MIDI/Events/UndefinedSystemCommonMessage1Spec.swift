//
//  UndefinedSystemCommonMessage1.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class UndefinedSystemCommonMessage1Spec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = UndefinedSystemCommonMessage1()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xF4`") {
                expect(UndefinedSystemCommonMessage1().bytes) == [0xF4]
            }
        }
        describe("fromData") {
            it("returns an instance regardless of passed data") {
                expect(UndefinedSystemCommonMessage1.fromData([0xFF, 0xFF, 0xFF]))
                    == UndefinedSystemCommonMessage1()
            }
        }
    }
}
