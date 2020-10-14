//
//  UndefinedSystemRealTimeMessage2.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class UndefinedSystemRealTimeMessage2Spec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = UndefinedSystemRealTimeMessage2()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xFD`") {
                expect(UndefinedSystemRealTimeMessage2().bytes) == [0xFD]
            }
        }
        describe("fromData") {
            it("returns an instance regardless of passed data") {
                expect(UndefinedSystemRealTimeMessage2.fromData([0xFF, 0xFF, 0xFF]))
                    == UndefinedSystemRealTimeMessage2()
            }
        }
    }
}
