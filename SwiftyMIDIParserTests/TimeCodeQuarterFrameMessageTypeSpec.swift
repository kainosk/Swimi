//
//  TimeCodeQuarterFrameMessageTypeSpec.swift
//  SwiftyMIDIParserTests
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SwiftyMIDIParser

class TimeCodeQuarterFrameMessageTypeSpec: QuickSpec {
    
    override func spec() {
        describe("fromByte") {
            it("0b0000 0000 -> frameCountLower4bit") {
                expect(TimeCodeQuarterFrameMessageType.fromByte(0b00000000))
                    .to(equal(.frameCountLower4bit))
            }
            it("0b0000 1111 -> frameCountLower4bit") {
                expect(TimeCodeQuarterFrameMessageType.fromByte(0b00001111))
                    .to(equal(.frameCountLower4bit))
            }
            it("0b0001 1111 -> frameCountUpper4bit") {
                expect(TimeCodeQuarterFrameMessageType.fromByte(0b00011111))
                    .to(equal(.frameCountUpper4bit))
            }
            it("0b0010 0000 -> secondCountLower4bit") {
                expect(TimeCodeQuarterFrameMessageType.fromByte(0b00100000))
                    .to(equal(.secondCountLower4bit))
            }
            it("0b0011 0000 -> secondCountUpper4bit") {
                expect(TimeCodeQuarterFrameMessageType.fromByte(0b00110000))
                    .to(equal(.secondCountUpper4bit))
            }
            it("0b0100 1111 -> minuteCountLower4bit") {
                expect(TimeCodeQuarterFrameMessageType.fromByte(0b01001111))
                    .to(equal(.minuteCountLower4bit))
            }
            it("0b0101 0000 -> minuteCountUpper4bit") {
                expect(TimeCodeQuarterFrameMessageType.fromByte(0b01010000))
                    .to(equal(.minuteCountUpper4bit))
            }
            it("0b0110 1111 -> timeCountLower4bit") {
                expect(TimeCodeQuarterFrameMessageType.fromByte(0b01101111))
                    .to(equal(.timeCountLower4bit))
            }
            it("0b0111 0000 -> timeCountUpper4bit") {
                expect(TimeCodeQuarterFrameMessageType.fromByte(0b01110000))
                    .to(equal(.timeCountUpper4bit))
            }
        }
    }
}
