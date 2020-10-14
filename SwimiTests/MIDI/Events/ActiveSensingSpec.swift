//
//  ActiveSensing.swift
//  SwimiTests
//
//  Created by kai on 2020/09/15.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class ActiveSensingSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized without any parameter") {
                _ = ActiveSensing()
            }
        }
        describe("bytes") {
            it("returns its status byte `0xFE`") {
                expect(ActiveSensing().bytes) == [0xFE]
            }
        }
        describe("fromData") {
            context("data length is 1") {
                it("returns an instance regardless of passed data") {
                    expect(ActiveSensing.fromData([0xFF])) == ActiveSensing()
                }
            }
            context("data length is not 1") {
                it("assert") {
                    expect {
                        _ = ActiveSensing.fromData([0x00, 0x11])
                    }.to(throwAssertion())
                }
            } 
        }
    }
}
