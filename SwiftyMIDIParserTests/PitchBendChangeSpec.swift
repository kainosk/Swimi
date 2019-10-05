//
//  PitchBendChangeSpec.swift
//  SwiftyMIDIParserTests
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SwiftyMIDIParser

class PitchBendChangeSpec: QuickSpec {
    override func spec() {
        describe("value") {
            var lsb: UInt8!
            var msb: UInt8!
            context("minimum lsb") {
                beforeEach {
                    lsb = 0
                }
                context("minimum msb") {
                    beforeEach {
                        msb = 0
                    }
                    it("0") {
                        let subject = PitchBendChange(channel: 5, lsb: lsb, msb: msb)
                        expect(subject.value).to(equal(0))
                    }
                }
                context("maximum msb") {
                    beforeEach {
                        msb = 0b01111111
                    }
                    it("16256") {
                        let subject = PitchBendChange(channel: 5, lsb: lsb, msb: msb)
                        expect(subject.value).to(equal(16256))
                    }
                }
            }
            context("maximum lsb") {
                beforeEach {
                    lsb = 0b01111111
                }
                context("minimum msb") {
                    beforeEach {
                        msb = 0
                    }
                    it("127") {
                        let subject = PitchBendChange(channel: 5, lsb: lsb, msb: msb)
                        expect(subject.value).to(equal(127))
                    }
                }
                context("maximum msb") {
                    beforeEach {
                        msb = 0b01111111
                    }
                    it("16383") {
                        let subject = PitchBendChange(channel: 5, lsb: lsb, msb: msb)
                        expect(subject.value).to(equal(16383))
                    }
                }
            }
        }
    }
}
