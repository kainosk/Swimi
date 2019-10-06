//
//  StatusTypeSpec.swift
//  SwimiTests
//
//  Created by kai on 2019/10/06.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class StatusTypeSpec: QuickSpec {
    override func spec() {
        
        describe("dataByteSize") {
            it("noteOn: 2") {
                expect(StatusType.noteOn.dataByteSize).to(equal(.fixed(2)))
            }
            it("noteOff: 2") {
                expect(StatusType.noteOff.dataByteSize).to(equal(.fixed(2)))
            }
            it("polyphonicKeyPressure: 2") {
                expect(StatusType.polyphonicKeyPressure.dataByteSize).to(equal(.fixed(2)))
            }
            it("controlChange: 2") {
                expect(StatusType.controlChange.dataByteSize).to(equal(.fixed(2)))
            }
            it("programChange: 1") {
                expect(StatusType.programChange.dataByteSize).to(equal(.fixed(1)))
            }
            it("channelPressure: 1") {
                expect(StatusType.channelPressure.dataByteSize).to(equal(.fixed(1)))
            }
            it("pitchBendChange: 2") {
                expect(StatusType.pitchBendChange.dataByteSize).to(equal(.fixed(2)))
            }
            it("timeCodeQuarterFrame: 1") {
                expect(StatusType.timecodeQuarterFrame.dataByteSize).to(equal(.fixed(1)))
            }
            it("songPositionPointer: 2") {
                expect(StatusType.songPositionPointer.dataByteSize).to(equal(.fixed(2)))
            }
            it("songSelect: 1") {
                expect(StatusType.songSelect.dataByteSize).to(equal(.fixed(1)))
            }
            it("undefinedSystemCommoMessage1: 0") {
                expect(StatusType.undefinedSystemCommonMessage1.dataByteSize).to(equal(.fixed(0)))
            }
            it("undefinedSystemCommoMessage2: 0") {
                expect(StatusType.undefinedSystemCommonMessage2.dataByteSize).to(equal(.fixed(0)))
            }
            it("tuneRequest: 0") {
                expect(StatusType.tuneRequest.dataByteSize).to(equal(.fixed(0)))
            }
            it("endOfExclusive: 0") {
                expect(StatusType.endOfExclusive.dataByteSize).to(equal(.fixed(0)))
            }
            it("timingClock: 0") {
                expect(StatusType.timingClock.dataByteSize).to(equal(.fixed(0)))
            }
            it("undefinedSystemRealTimeMessage1: 0") {
                expect(StatusType.undefinedSystemRealTimeMessage1.dataByteSize).to(equal(.fixed(0)))
            }
            it("undefinedSystemRealTimeMessage2: 0") {
                expect(StatusType.undefinedSystemRealTimeMessage2.dataByteSize).to(equal(.fixed(0)))
            }
            it("start: 0") {
                expect(StatusType.start.dataByteSize).to(equal(.fixed(0)))
            }
            it("continue: 0") {
                expect(StatusType.continue.dataByteSize).to(equal(.fixed(0)))
            }
            it("stop: 0") {
                expect(StatusType.stop.dataByteSize).to(equal(.fixed(0)))
            }
            it("activeSensing: 0") {
                expect(StatusType.activeSensing.dataByteSize).to(equal(.fixed(0)))
            }
            it("systemReset: 0") {
                expect(StatusType.systemReset.dataByteSize).to(equal(.fixed(0)))
            }
            
            it("SystemExclusive: variable") {
                expect(StatusType.systemExclusive.dataByteSize).to(equal(.variable))
            }
        }
        
        describe("isSystemRealTimeMessage") {
            it("timingClock: true") {
                expect(StatusType.timingClock.isSystemRealTimeMessage).to(beTrue())
            }
            it("undefinedSystemRealTimeMessage1: true") {
                expect(StatusType.undefinedSystemRealTimeMessage1.isSystemRealTimeMessage).to(beTrue())
            }
            it("undefinedSystemRealTimeMessage2: true") {
                expect(StatusType.undefinedSystemRealTimeMessage2.isSystemRealTimeMessage).to(beTrue())
            }
            it("start: true") {
                expect(StatusType.start.isSystemRealTimeMessage).to(beTrue())
            }
            it("continue: true") {
                expect(StatusType.continue.isSystemRealTimeMessage).to(beTrue())
            }
            it("stop: true") {
                expect(StatusType.stop.isSystemRealTimeMessage).to(beTrue())
            }
            it("activeSensing: true") {
                expect(StatusType.activeSensing.isSystemRealTimeMessage).to(beTrue())
            }
            it("systemReset: true") {
                expect(StatusType.systemReset.isSystemRealTimeMessage).to(beTrue())
            }
            it("others: false") {
                let realTimeMessages: [StatusType] = [
                    .timingClock,
                    .undefinedSystemRealTimeMessage1,
                    .undefinedSystemRealTimeMessage2,
                    .start,
                    .continue,
                    .stop,
                    .activeSensing,
                    .systemReset
                ]
                
                let result = StatusType.allCases
                    .filter { !realTimeMessages.contains($0) }
                    .map { $0.isSystemRealTimeMessage }
                expect(result).to(allPass(beFalse()))
            }
        }
        
        describe("fromByte") {
            it("0x80: noteOff") {
                expect(StatusType.fromByte(0x80)).to(equal(.noteOff))
            }
            it("0x8A: noteOff") {
                expect(StatusType.fromByte(0x8A)).to(equal(.noteOff))
            }
            it("0x8F: noteOff") {
                expect(StatusType.fromByte(0x8F)).to(equal(.noteOff))
            }
            
            it("0x90: noteOff") {
                expect(StatusType.fromByte(0x90)).to(equal(.noteOn))
            }
            it("0x9A: noteOff") {
                expect(StatusType.fromByte(0x9A)).to(equal(.noteOn))
            }
            it("0x9F: noteOff") {
                expect(StatusType.fromByte(0x9F)).to(equal(.noteOn))
            }
            
            it("0xA0: polyphonicKeyPressure") {
                expect(StatusType.fromByte(0xA0)).to(equal(.polyphonicKeyPressure))
            }
            it("0xAA: polyphonicKeyPressure") {
                expect(StatusType.fromByte(0xAA)).to(equal(.polyphonicKeyPressure))
            }
            it("0xAF: polyphonicKeyPressure") {
                expect(StatusType.fromByte(0xAF)).to(equal(.polyphonicKeyPressure))
            }
            
            
            it("0xB0: controlChange") {
                expect(StatusType.fromByte(0xB0)).to(equal(.controlChange))
            }
            it("0xBA: polyphonicKeyPressure") {
                expect(StatusType.fromByte(0xBA)).to(equal(.controlChange))
            }
            it("0xBF: polyphonicKeyPressure") {
                expect(StatusType.fromByte(0xBF)).to(equal(.controlChange))
            }
            
            it("0xC0: programChange") {
                expect(StatusType.fromByte(0xC0)).to(equal(.programChange))
            }
            it("0xCA: programChange") {
                expect(StatusType.fromByte(0xCA)).to(equal(.programChange))
            }
            it("0xCF: programChange") {
                expect(StatusType.fromByte(0xCF)).to(equal(.programChange))
            }
            
            it("0xD0: channelPressure") {
                expect(StatusType.fromByte(0xD0)).to(equal(.channelPressure))
            }
            it("0xDA: channelPressure") {
                expect(StatusType.fromByte(0xDA)).to(equal(.channelPressure))
            }
            it("0xDF: channelPressure") {
                expect(StatusType.fromByte(0xDF)).to(equal(.channelPressure))
            }
            
            it("0xE0: pitchBendChange") {
                expect(StatusType.fromByte(0xE0)).to(equal(.pitchBendChange))
            }
            it("0xEA: pitchBendChange") {
                expect(StatusType.fromByte(0xEA)).to(equal(.pitchBendChange))
            }
            it("0xEF: pitchBendChange") {
                expect(StatusType.fromByte(0xEF)).to(equal(.pitchBendChange))
            }
            
            it("0xF1: timecodeQuarterFrame") {
                expect(StatusType.fromByte(0xF1)).to(equal(.timecodeQuarterFrame))
            }
            it("0xF2: songPositionPointer") {
                expect(StatusType.fromByte(0xF2)).to(equal(.songPositionPointer))
            }
            it("0xF3: songSelect") {
                expect(StatusType.fromByte(0xF3)).to(equal(.songSelect))
            }
            it("0xF4: undefinedSystemCommonMessage1") {
                expect(StatusType.fromByte(0xF4)).to(equal(.undefinedSystemCommonMessage1))
            }
            it("0xF5: undefinedSystemCommonMessage2") {
                expect(StatusType.fromByte(0xF5)).to(equal(.undefinedSystemCommonMessage2))
            }
            it("0xF6: tuneRequest") {
                expect(StatusType.fromByte(0xF6)).to(equal(.tuneRequest))
            }
            it("0xF7: endOfExclusive") {
                expect(StatusType.fromByte(0xF7)).to(equal(.endOfExclusive))
            }
            it("0xF8: timingClock") {
                expect(StatusType.fromByte(0xF8)).to(equal(.timingClock))
            }
            it("0xF9: undefinedSystemRealTimeMessage1") {
                expect(StatusType.fromByte(0xF9)).to(equal(.undefinedSystemRealTimeMessage1))
            }
            it("0xFA: start") {
                expect(StatusType.fromByte(0xFA)).to(equal(.start))
            }
            it("0xFB: continue") {
                expect(StatusType.fromByte(0xFB)).to(equal(.continue))
            }
            it("0xFC: stop") {
                expect(StatusType.fromByte(0xFC)).to(equal(.stop))
            }
            it("0xFD: undefinedSystemRealTimeMessage2") {
                expect(StatusType.fromByte(0xFD)).to(equal(.undefinedSystemRealTimeMessage2))
            }
            it("0xFE: activeSensing") {
                expect(StatusType.fromByte(0xFE)).to(equal(.activeSensing))
            }
            it("0xFF: systemReset") {
                expect(StatusType.fromByte(0xFF)).to(equal(.systemReset))
            }
            it("0xF0: systemExclusive") {
                expect(StatusType.fromByte(0xF0)).to(equal(.systemExclusive))
            }
            
            it("0x7F: nil") {
                expect(StatusType.fromByte(0x7F)).to(beNil())
            }
            it("0x00: nil") {
                expect(StatusType.fromByte(0x00)).to(beNil())
            }
        }
    }
}
