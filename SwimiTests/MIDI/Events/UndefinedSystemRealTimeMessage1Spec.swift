//
//  UndefinedSystemRealTimeMessage1.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class UndefinedSystemRealTimeMessage1Spec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = UndefinedSystemRealTimeMessage1()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xF9`") {
                expect(UndefinedSystemRealTimeMessage1().bytes) == [0xF9]
            }
        }
        describe("fromData") {
            it("returns an instance regardless of passed data") {
                expect(UndefinedSystemRealTimeMessage1.fromData([0xFF, 0xFF, 0xFF]))
                    == UndefinedSystemRealTimeMessage1()
            }
        }
    }
}
