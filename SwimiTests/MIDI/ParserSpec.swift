//
//  ParserSpec.swift
//  SwimiTests
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class ParserSpec: QuickSpec {
    // In this test cases, we use `MIDIEvent.xxxx()` style because compiler can not infer
    // type in reasonable time. I know it is ugly workaround but I don't know better way...
    
    override func spec() {
        var subject: Parser!
        
        var parsedEvents: [MIDIEvent]!
        
        beforeEach {
            subject = Parser()
            parsedEvents = []
            subject.notifier.eventParsed = { parsedEvents.append($0) }
        }
        
        // MARK: Note On
        describe("noteOn") {
            it("parse messages even if it contains RunningStatus") {
                let data: [UInt8] = [
                    0x95,   1,    1,
                    0x95,   3,    3,
                    7,    7, // Running Status
                    15,   15, // Running Status
                    0x95,  31,   31,
                    0xF0,  11, 0xF7, // System Exclusive
                    0x95,  63,   63,
                    127,  127, // Running Status
                    0xF0,  22, 0xF7, // System Exclusive
                    0x95,   0,    0,
                ]
                subject.input(data: data)
                
                expect(parsedEvents).to(equal([
                    MIDIEvent.noteOn(channel: 5, note:   1, velocity:   1),
                    MIDIEvent.noteOn(channel: 5, note:   3, velocity:   3),
                    MIDIEvent.noteOn(channel: 5, note:   7, velocity:   7),
                    MIDIEvent.noteOn(channel: 5, note:  15, velocity:  15),
                    MIDIEvent.noteOn(channel: 5, note:  31, velocity:  31),
                    MIDIEvent.sysEx([0xF0, 11, 0xF7]),
                    MIDIEvent.noteOn(channel: 5, note:  63, velocity:  63),
                    MIDIEvent.noteOn(channel: 5, note: 127, velocity: 127),
                    MIDIEvent.sysEx([0xF0, 22, 0xF7]),
                    MIDIEvent.noteOn(channel: 5, note:   0, velocity:   0),
                ]))
            }
            context("real time message interrupt") {
                beforeEach {
                    // 5 times NoteOn will be interrupt by 13 times "TimingClock"
                    let data: [UInt8] = [
                        0x99,         // 1st noteOn
                        0xF8,
                        1,
                        0xF8,
                        1,
                        0xF8,
                        0x99,         // 2nd noteOn
                        0xF8,
                        1,
                        0xF8,
                        1,
                        0xF8,
                        1,     // 3rd noteOn (running status)
                        0xF8,
                        1,
                        0xF8,
                        1,     // 4th noteOn (running status)
                        0xF8,
                        1,
                        0xF8,
                        0x99,         // 5th noteOn
                        0xF8,
                        1,
                        0xF8,
                        1,
                        0xF8
                    ]
                    subject.input(data: data)
                }
                it("can parse noteOn correctly") {
                    expect(parsedEvents).to(equal([
                        .timingClock(),
                        .timingClock(),
                        .noteOn(channel: 9, note: 1, velocity: 1),
                        .timingClock(),
                        .timingClock(),
                        .timingClock(),
                        .noteOn(channel: 9, note: 1, velocity: 1),
                        .timingClock(),
                        .timingClock(),
                        .noteOn(channel: 9, note: 1, velocity: 1),
                        .timingClock(),
                        .timingClock(),
                        .noteOn(channel: 9, note: 1, velocity: 1),
                        .timingClock(),
                        .timingClock(),
                        .timingClock(),
                        .noteOn(channel: 9, note: 1, velocity: 1),
                        .timingClock(),
                    ]))
                }
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x9F, 64, 64])
                        expect(parsedEvents).to(equal([
                            .noteOn(channel: 15, note: 64, velocity: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x90, 64, 64])
                        expect(parsedEvents).to(equal([
                            .noteOn(channel: 0, note: 64, velocity: 64)
                        ]))
                    }
                }
                context("note maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x95, 127, 64])
                        expect(parsedEvents).to(equal([
                            .noteOn(channel: 5, note: 127, velocity: 64)
                        ]))
                    }
                }
                context("note minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x95, 0, 64])
                        expect(parsedEvents).to(equal([
                            .noteOn(channel: 5, note: 0, velocity: 64)
                        ]))
                    }
                }
                context("velocity maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x95, 64, 127])
                        expect(parsedEvents).to(equal([
                            .noteOn(channel: 5, note: 64, velocity: 127)
                        ]))
                    }
                }
                context("velocity minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x95, 64, 0])
                        expect(parsedEvents).to(equal([
                            .noteOn(channel: 5, note: 64, velocity: 0)
                        ]))
                    }
                }
            }
        }
        
        // MARK: Note Off
        describe("noteOff") {
            it("parse messages even if it contains RunningStatus") {
                let data: [UInt8] = [
                    0x86,   1,    1,
                    0x86,   3,    3,
                    7,    7, // Running Status
                    15,   15, // Running Status
                    0x86,  31,   31,
                    0xF0,  11, 0xF7, // System Exclusive
                    0x86,  63,   63,
                    127,  127, // Running Status
                    0xF0,  22, 0xF7, // System Exclusive
                    0x86,   0,    0,
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    MIDIEvent.noteOff(channel: 6, note:   1, velocity:   1),
                    .noteOff(channel: 6, note:   3, velocity:   3),
                    .noteOff(channel: 6, note:   7, velocity:   7),
                    .noteOff(channel: 6, note:  15, velocity:  15),
                    .noteOff(channel: 6, note:  31, velocity:  31),
                    .sysEx([0xF0, 11, 0xF7]),
                    .noteOff(channel: 6, note:  63, velocity:  63),
                    .noteOff(channel: 6, note: 127, velocity: 127),
                    .sysEx([0xF0, 22, 0xF7]),
                    .noteOff(channel: 6, note:   0, velocity:   0),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 5 times NoteOff will be interrupt by 13 times "ActiveSensing"
                    let data: [UInt8] = [
                        0x8F,         // 1st noteOff
                        0xFE,
                        1,
                        0xFE,
                        1,
                        0xFE,
                        0x8F,         // 2nd noteOff
                        0xFE,
                        1,
                        0xFE,
                        1,
                        0xFE,
                        1,     // 3rd noteOff (running status)
                        0xFE,
                        1,
                        0xFE,
                        1,     // 4th noteOff (running status)
                        0xFE,
                        1,
                        0xFE,
                        0x8F,         // 5th noteOff
                        0xFE,
                        1,
                        0xFE,
                        1,
                        0xFE
                    ]
                    subject.input(data: data)
                }
                it("can parse noteOff correctly") {
                    expect(parsedEvents).to(equal([
                        .activeSensing(),
                        .activeSensing(),
                        .noteOff(channel: 15, note: 1, velocity: 1),
                        .activeSensing(),
                        .activeSensing(),
                        .activeSensing(),
                        .noteOff(channel: 15, note: 1, velocity: 1),
                        .activeSensing(),
                        .activeSensing(),
                        .noteOff(channel: 15, note: 1, velocity: 1),
                        .activeSensing(),
                        .activeSensing(),
                        .noteOff(channel: 15, note: 1, velocity: 1),
                        .activeSensing(),
                        .activeSensing(),
                        .activeSensing(),
                        .noteOff(channel: 15, note: 1, velocity: 1),
                        .activeSensing(),
                    ]))
                }
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x8F, 64, 64])
                        expect(parsedEvents).to(equal([
                            .noteOff(channel: 15, note: 64, velocity: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x80, 64, 64])
                        expect(parsedEvents).to(equal([
                            .noteOff(channel: 0, note: 64, velocity: 64)
                        ]))
                    }
                }
                context("note maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x85, 127, 64])
                        expect(parsedEvents).to(equal([
                            .noteOff(channel: 5, note: 127, velocity: 64)
                        ]))
                    }
                }
                context("note minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x85, 0, 64])
                        expect(parsedEvents).to(equal([
                            .noteOff(channel: 5, note: 0, velocity: 64)
                        ]))
                    }
                }
                context("velocity maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x85, 64, 127])
                        expect(parsedEvents).to(equal([
                            .noteOff(channel: 5, note: 64, velocity: 127)
                        ]))
                    }
                }
                context("velocity minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x85, 64, 0])
                        expect(parsedEvents).to(equal([
                            .noteOff(channel: 5, note: 64, velocity: 0)
                        ]))
                    }
                }
            }
        }
        
        // MARK: Polyphonic Key Pressure
        describe("polyphonicKeyPressure") {
            it("parse messages even if it contains RunningStatus") {
                let data: [UInt8] = [
                    0xA5,   1,    1,
                    0xA5,   3,    3,
                    7,    7, // Running Status
                    15,   15, // Running Status
                    0xA5,  31,   31,
                    0xF0,  11, 0xF7, // System Exclusive
                    0xA5,  63,   63,
                    127,  127, // Running Status
                    0xF0,  22, 0xF7, // System Exclusive
                    0xA5,   0,    0,
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    MIDIEvent.polyphonicKeyPressure(channel: 5, note:   1, pressure:   1),
                    .polyphonicKeyPressure(channel: 5, note:   3, pressure:   3),
                    .polyphonicKeyPressure(channel: 5, note:   7, pressure:   7),
                    .polyphonicKeyPressure(channel: 5, note:  15, pressure:  15),
                    .polyphonicKeyPressure(channel: 5, note:  31, pressure:  31),
                    .sysEx([0xF0, 11, 0xF7]),
                    .polyphonicKeyPressure(channel: 5, note:  63, pressure:  63),
                    .polyphonicKeyPressure(channel: 5, note: 127, pressure: 127),
                    .sysEx([0xF0, 22, 0xF7]),
                    .polyphonicKeyPressure(channel: 5, note:   0, pressure:   0),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 5 times "PolyphonicKeyPressure" will be interrupt by 13 times "Start"
                    let data: [UInt8] = [
                        0xAA,         // 1st polyphonicKeyPressure
                        0xFA,
                        1,
                        0xFA,
                        1,
                        0xFA,
                        0xAA,         // 2nd polyphonicKeyPressure
                        0xFA,
                        1,
                        0xFA,
                        1,
                        0xFA,
                        1,     // 3rd polyphonicKeyPressure (running status)
                        0xFA,
                        1,
                        0xFA,
                        1,     // 4th polyphonicKeyPressure (running status)
                        0xFA,
                        1,
                        0xFA,
                        0xAA,         // 5th polyphonicKeyPressure
                        0xFA,
                        1,
                        0xFA,
                        1,
                        0xFA
                    ]
                    subject.input(data: data)
                }
                it("can parse polyphonicKeyPressure correctly") {
                    expect(parsedEvents).to(equal([
                        .start(),
                        .start(),
                        .polyphonicKeyPressure(channel: 10, note: 1, pressure: 1),
                        .start(),
                        .start(),
                        .start(),
                        .polyphonicKeyPressure(channel: 10, note: 1, pressure: 1),
                        .start(),
                        .start(),
                        .polyphonicKeyPressure(channel: 10, note: 1, pressure: 1),
                        .start(),
                        .start(),
                        .polyphonicKeyPressure(channel: 10, note: 1, pressure: 1),
                        .start(),
                        .start(),
                        .start(),
                        .polyphonicKeyPressure(channel: 10, note: 1, pressure: 1),
                        .start(),
                    ]))
                }
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xAF, 64, 64])
                        expect(parsedEvents).to(equal([
                            .polyphonicKeyPressure(channel: 15, note: 64, pressure: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xA0, 64, 64])
                        expect(parsedEvents).to(equal([
                            .polyphonicKeyPressure(channel: 0, note: 64, pressure: 64)
                        ]))
                    }
                }
                context("note maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xA5, 127, 64])
                        expect(parsedEvents).to(equal([
                            .polyphonicKeyPressure(channel: 5, note: 127, pressure: 64)
                        ]))
                    }
                }
                context("note minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xA5, 0, 64])
                        expect(parsedEvents).to(equal([
                            .polyphonicKeyPressure(channel: 5, note: 0, pressure: 64)
                        ]))
                    }
                }
                context("pressure maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xA5, 64, 127])
                        expect(parsedEvents).to(equal([
                            .polyphonicKeyPressure(channel: 5, note: 64, pressure: 127)
                        ]))
                    }
                }
                context("pressure minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xA5, 64, 0])
                        expect(parsedEvents).to(equal([
                            .polyphonicKeyPressure(channel: 5, note: 64, pressure: 0)
                        ]))
                    }
                }
            }
        }
        
        // MARK: Control Change
        describe("controlChange") {
            // We will omit cases for all "Control Numbers".
            // Delegate these cases to ControlNumber enum's tests.
            it("parse messages even if it contains RunningStatus") {
                let data: [UInt8] = [
                    0xB5,   1,    1,
                    0xB5,   3,    3,
                    7,    7, // Running Status
                    15,   15, // Running Status
                    0xB5,  31,   31,
                    0xF0,  11, 0xF7, // System Exclusive
                    0xB5,  63,   63,
                    127,  127, // Running Status
                    0xF0,  22, 0xF7, // System Exclusive
                    0xB5,   0,    0,
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    MIDIEvent.controlChange(channel: 5, controlNumber: ControlNumber(rawValue:    1)!, value:   1),
                    .controlChange(channel: 5, controlNumber: ControlNumber(rawValue:    3)!, value:   3),
                    .controlChange(channel: 5, controlNumber: ControlNumber(rawValue:    7)!, value:   7),
                    .controlChange(channel: 5, controlNumber: ControlNumber(rawValue:   15)!, value:  15),
                    .controlChange(channel: 5, controlNumber: ControlNumber(rawValue:   31)!, value:  31),
                    .sysEx([0xF0, 11, 0xF7]),
                    .controlChange(channel: 5, controlNumber: ControlNumber(rawValue:   63)!, value:  63),
                    .controlChange(channel: 5, controlNumber: ControlNumber(rawValue:  127)!, value: 127),
                    .sysEx([0xF0, 22, 0xF7]),
                    .controlChange(channel: 5, controlNumber: ControlNumber(rawValue:    0)!, value:   0),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 5 times ControlChange will be interrupt by 13 times "Continue"
                    let data: [UInt8] = [
                        0xB5,         // 1st controlChange
                        0xFB,
                        1,
                        0xFB,
                        1,
                        0xFB,
                        0xB5,         // 2nd controlChange
                        0xFB,
                        1,
                        0xFB,
                        1,
                        0xFB,
                        1,     // 3rd controlChange (running status)
                        0xFB,
                        1,
                        0xFB,
                        1,     // 4th controlChange (running status)
                        0xFB,
                        1,
                        0xFB,
                        0xB5,         // 5th controlChange
                        0xFB,
                        1,
                        0xFB,
                        1,
                        0xFB
                    ]
                    subject.input(data: data)
                }
                it("can parse controlChange correctly") {
                    expect(parsedEvents).to(equal([
                        .continue(),
                        .continue(),
                        .controlChange(channel: 5, controlNumber: .modulationWheel, value: 1),
                        .continue(),
                        .continue(),
                        .continue(),
                        .controlChange(channel: 5, controlNumber: .modulationWheel, value: 1),
                        .continue(),
                        .continue(),
                        .controlChange(channel: 5, controlNumber: .modulationWheel, value: 1),
                        .continue(),
                        .continue(),
                        .controlChange(channel: 5, controlNumber: .modulationWheel, value: 1),
                        .continue(),
                        .continue(),
                        .continue(),
                        .controlChange(channel: 5, controlNumber: .modulationWheel, value: 1),
                        .continue(),
                    ]))
                }
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xBF, 64, 64])
                        expect(parsedEvents).to(equal([
                            .controlChange(channel: 15, controlNumber: .damperPedal, value: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xB0, 64, 64])
                        expect(parsedEvents).to(equal([
                            .controlChange(channel: 0, controlNumber: .damperPedal, value: 64)
                        ]))
                    }
                }
                context("control number maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xB5, 127, 64])
                        expect(parsedEvents).to(equal([
                            .controlChange(channel: 5, controlNumber: .polyModeOn, value: 64)
                        ]))
                    }
                }
                context("control number minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xB5, 0, 64])
                        expect(parsedEvents).to(equal([
                            .controlChange(channel: 5, controlNumber: .bankSelectMSB, value: 64)
                        ]))
                    }
                }
                context("value maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xB5, 64, 127])
                        expect(parsedEvents).to(equal([
                            .controlChange(channel: 5, controlNumber: .damperPedal, value: 127)
                        ]))
                    }
                }
                context("value minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xB5, 64, 0])
                        expect(parsedEvents).to(equal([
                            .controlChange(channel: 5, controlNumber: .damperPedal, value: 0)
                        ]))
                    }
                }
            }
        }
        
        // MARK: Program Change
        describe("ProgramChange") {
            it("parse messages even if it contains RunningStatus") {
                let data: [UInt8] = [
                    0xC5,   1,
                    0xC5,   3,
                    7,       // Running Status
                    15,       // Running Status
                    0xC5,  31,
                    0xF0,  11, 0xF7, // System Exclusive
                    0xC5,  63,
                    127,       // Running Status
                    0xF0,  22, 0xF7, // System Exclusive
                    0xC5,   0,
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    MIDIEvent.programChange(channel: 5,  program:   1),
                    .programChange(channel: 5,  program:   3),
                    .programChange(channel: 5,  program:   7),
                    .programChange(channel: 5,  program:  15),
                    .programChange(channel: 5,  program:  31),
                    .sysEx([0xF0, 11, 0xF7]),
                    .programChange(channel: 5,  program:  63),
                    .programChange(channel: 5,  program: 127),
                    .sysEx([0xF0, 22, 0xF7]),
                    .programChange(channel: 5,  program:   0),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 5 times "ProgramChange" will be interrupt by 8 times "SystemReset"
                    let data: [UInt8] = [
                        0xC5,         // 1st programChange
                        0xFF,
                        1,
                        0xFF,
                        0xC5,         // 2nd programChange
                        0xFF,
                        1,
                        0xFF,
                        1,     // 3rd programChange (running status)
                        0xFF,
                        1,     // 4th programChange (running status)
                        0xFF,
                        0xC5,         // 5th programChange
                        0xFF,
                        1,
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse programChange correctly") {
                    expect(parsedEvents).to(equal([
                        .systemReset(),
                        .programChange(channel: 5, program: 1),
                        .systemReset(),
                        .systemReset(),
                        .programChange(channel: 5, program: 1),
                        .systemReset(),
                        .programChange(channel: 5, program: 1),
                        .systemReset(),
                        .programChange(channel: 5, program: 1),
                        .systemReset(),
                        .systemReset(),
                        .programChange(channel: 5, program: 1),
                        .systemReset(),
                    ]))
                }
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xCF, 64])
                        expect(parsedEvents).to(equal([
                            .programChange(channel: 15,  program: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xC0, 64])
                        expect(parsedEvents).to(equal([
                            .programChange(channel: 0,  program: 64)
                        ]))
                    }
                }
                context("program number maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xC5, 127])
                        expect(parsedEvents).to(equal([
                            .programChange(channel: 5,  program: 127)
                        ]))
                    }
                }
                context("program number minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xC5, 0])
                        expect(parsedEvents).to(equal([
                            .programChange(channel: 5,  program: 0)
                        ]))
                    }
                }
            }
        }
        
        // MARK: Channel Pressure
        describe("ChannelPressure") {
            it("parse messages even if it contains RunningStatus") {
                let data: [UInt8] = [
                    0xD5,   1,
                    0xD5,   3,
                    7,       // Running Status
                    15,       // Running Status
                    0xD5,  31,
                    0xF0,  11, 0xF7, // System Exclusive
                    0xD5,  63,
                    127,       // Running Status
                    0xF0,  22, 0xF7, // System Exclusive
                    0xD5,   0,
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    MIDIEvent.channelPressure(channel: 5,  pressure:   1),
                    .channelPressure(channel: 5,  pressure:   3),
                    .channelPressure(channel: 5,  pressure:   7),
                    .channelPressure(channel: 5,  pressure:  15),
                    .channelPressure(channel: 5,  pressure:  31),
                    .sysEx([0xF0, 11, 0xF7]),
                    .channelPressure(channel: 5,  pressure:  63),
                    .channelPressure(channel: 5,  pressure: 127),
                    .sysEx([0xF0, 22, 0xF7]),
                    .channelPressure(channel: 5,  pressure:   0),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 5 times "ChannelPressure" will be interrupt by 8 times "UndefinedSystemRealTimeMessage1"
                    let data: [UInt8] = [
                        0xD5,         // 1st channelPressure
                        0xF9,
                        1,
                        0xF9,
                        0xD5,         // 2nd channelPressure
                        0xF9,
                        1,
                        0xF9,
                        1,     // 3rd channelPressure (running status)
                        0xF9,
                        1,     // 4th channelPressure (running status)
                        0xF9,
                        0xD5,         // 5th channelPressure
                        0xF9,
                        1,
                        0xF9,
                    ]
                    subject.input(data: data)
                }
                it("can parse channelPressure correctly") {
                    expect(parsedEvents).to(equal([
                        MIDIEvent.undefinedSystemRealTimeMessage1(),
                        .channelPressure(channel: 5, pressure: 1),
                        .undefinedSystemRealTimeMessage1(),
                        .undefinedSystemRealTimeMessage1(),
                        .channelPressure(channel: 5, pressure: 1),
                        .undefinedSystemRealTimeMessage1(),
                        .channelPressure(channel: 5, pressure: 1),
                        .undefinedSystemRealTimeMessage1(),
                        .channelPressure(channel: 5, pressure: 1),
                        .undefinedSystemRealTimeMessage1(),
                        .undefinedSystemRealTimeMessage1(),
                        .channelPressure(channel: 5, pressure: 1),
                        .undefinedSystemRealTimeMessage1(),
                    ]))
                }
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xDF, 64])
                        expect(parsedEvents).to(equal([
                            .channelPressure(channel: 15,  pressure: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xD0, 64])
                        expect(parsedEvents).to(equal([
                            .channelPressure(channel: 0,  pressure: 64)
                        ]))
                    }
                }
                context("pressure maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xD5, 127])
                        expect(parsedEvents).to(equal([
                            .channelPressure(channel: 5,  pressure: 127)
                        ]))
                    }
                }
                context("pressure minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xD5, 0])
                        expect(parsedEvents).to(equal([
                            .channelPressure(channel: 5,  pressure: 0)
                        ]))
                    }
                }
            }
        }
        
        // MARK: Pitch Bend Change
        describe("PitchBendChange") {
            it("parse messages even if it contains RunningStatus") {
                let data: [UInt8] = [
                    0xE5,   1,    1,
                    0xE5,   3,    3,
                    7,    7, // Running Status
                    15,   15, // Running Status
                    0xE5,  31,   31,
                    0xF0,  11, 0xF7, // System Exclusive
                    0xE5,  63,   63,
                    127,  127, // Running Status
                    0xF0,  22, 0xF7, // System Exclusive
                    0xE5,   0,    0,
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    MIDIEvent.pitchBendChange(channel: 5, lsb:   1, msb:   1),
                    MIDIEvent.pitchBendChange(channel: 5, lsb:   3, msb:   3),
                    MIDIEvent.pitchBendChange(channel: 5, lsb:   7, msb:   7),
                    MIDIEvent.pitchBendChange(channel: 5, lsb:  15, msb:  15),
                    MIDIEvent.pitchBendChange(channel: 5, lsb:  31, msb:  31),
                    MIDIEvent.sysEx([0xF0, 11, 0xF7]),
                    MIDIEvent.pitchBendChange(channel: 5, lsb:  63, msb:  63),
                    MIDIEvent.pitchBendChange(channel: 5, lsb: 127, msb: 127),
                    MIDIEvent.sysEx([0xF0, 22, 0xF7]),
                    MIDIEvent.pitchBendChange(channel: 5, lsb:   0, msb:   0),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 5 times "PitchBendChange" will be interrupt by 13 times "UndefinedSystemRealTimeMessage2"
                    let data: [UInt8] = [
                        0xE5,         // 1st pitchBendChange
                        0xFD,
                        1,
                        0xFD,
                        1,
                        0xFD,
                        0xE5,         // 2nd pitchBendChange
                        0xFD,
                        1,
                        0xFD,
                        1,
                        0xFD,
                        1,     // 3rd pitchBendChange (running status)
                        0xFD,
                        1,
                        0xFD,
                        1,     // 4th pitchBendChange (running status)
                        0xFD,
                        1,
                        0xFD,
                        0xE5,         // 5th pitchBendChange
                        0xFD,
                        1,
                        0xFD,
                        1,
                        0xFD
                    ]
                    subject.input(data: data)
                }
                it("can parse pitchBendChange correctly") {
                    expect(parsedEvents).to(equal([
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .pitchBendChange(channel: 5, lsb: 1, msb: 1),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .pitchBendChange(channel: 5, lsb: 1, msb: 1),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .pitchBendChange(channel: 5, lsb: 1, msb: 1),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .pitchBendChange(channel: 5, lsb: 1, msb: 1),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .pitchBendChange(channel: 5, lsb: 1, msb: 1),
                        .undefinedSystemRealTimeMessage2(),
                    ]))
                }
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xEF, 64, 64])
                        expect(parsedEvents).to(equal([
                            .pitchBendChange(channel: 15, lsb: 64, msb: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xE0, 64, 64])
                        expect(parsedEvents).to(equal([
                            .pitchBendChange(channel: 0, lsb: 64, msb: 64)
                        ]))
                    }
                }
                context("lsb maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xE5, 127, 64])
                        expect(parsedEvents).to(equal([
                            .pitchBendChange(channel: 5, lsb: 127, msb: 64)
                        ]))
                    }
                }
                context("lsb minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xE5, 0, 64])
                        expect(parsedEvents).to(equal([
                            .pitchBendChange(channel: 5, lsb: 0, msb: 64)
                        ]))
                    }
                }
                context("msb maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xE5, 64, 127])
                        expect(parsedEvents).to(equal([
                            .pitchBendChange(channel: 5, lsb: 64, msb: 127)
                        ]))
                    }
                }
                context("msb minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xE5, 64, 0])
                        expect(parsedEvents).to(equal([
                            .pitchBendChange(channel: 5, lsb: 64, msb: 0)
                        ]))
                    }
                }
            }
        }
        
        // MARK: Time Code Quarter Frame
        describe("TimeCodeQuarterFrame") {
            // Cases for all ranges will be tested in
            // TimeCodeQuarterFrameMessageTypeSpec &
            // TimeCodeQuarterFrameSpec
            it("parse messages even if it contains RunningStatus") {
                let data: [UInt8] = [
                    0xF1,   0b00000001,
                    0xF1,   0b00000011,
                    0b00000111, // Running Status
                    0b00001111, // Running Status
                    0xF1,   0b00011111,
                    0xF0,     11, 0xF7, // System Exclusive
                    0xF1,   0b00111111,
                    0b01111111, // Running Status
                    0xF0,     22, 0xF7, // System Exclusive
                    0xF1,   0b01111111,
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    MIDIEvent.timeCodeQuarterFrame(type: .frameCountLower4bit,  value:  1),
                    MIDIEvent.timeCodeQuarterFrame(type: .frameCountLower4bit,  value:  3),
                    MIDIEvent.timeCodeQuarterFrame(type: .frameCountLower4bit,  value:  7),
                    MIDIEvent.timeCodeQuarterFrame(type: .frameCountLower4bit,  value: 15),
                    MIDIEvent.timeCodeQuarterFrame(type: .frameCountUpper4bit,  value: 15),
                    MIDIEvent.sysEx([0xF0, 11, 0xF7]),
                    MIDIEvent.timeCodeQuarterFrame(type: .secondCountUpper4bit, value: 15),
                    MIDIEvent.timeCodeQuarterFrame(type: .timeCountUpper4bit,   value: 15),
                    MIDIEvent.sysEx([0xF0, 22, 0xF7]),
                    MIDIEvent.timeCodeQuarterFrame(type: .timeCountUpper4bit,   value: 15),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 5 times "TimeCodeQuarterFrame" will be interrupt by 8 times "SystemReset"
                    let data: [UInt8] = [
                        0xF1,         // 1st timeCodeQuarterFrame
                        0xFF,
                        0x11,
                        0xFF,
                        0xF1,         // 2nd timeCodeQuarterFrame
                        0xFF,
                        0x11,
                        0xFF,
                        0x11,  // 3rd timeCodeQuarterFrame (running status)
                        0xFF,
                        0x11,  // 4th timeCodeQuarterFrame (running status)
                        0xFF,
                        0xF1,         // 5th timeCodeQuarterFrame
                        0xFF,
                        0x11,
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse timeCodeQuarterFrame correctly") {
                    expect(parsedEvents).to(equal([
                        MIDIEvent.systemReset(),
                        MIDIEvent.timeCodeQuarterFrame(type: .frameCountUpper4bit, value: 1),
                        MIDIEvent.systemReset(),
                        MIDIEvent.systemReset(),
                        MIDIEvent.timeCodeQuarterFrame(type: .frameCountUpper4bit, value: 1),
                        MIDIEvent.systemReset(),
                        MIDIEvent.timeCodeQuarterFrame(type: .frameCountUpper4bit, value: 1),
                        MIDIEvent.systemReset(),
                        MIDIEvent.timeCodeQuarterFrame(type: .frameCountUpper4bit, value: 1),
                        MIDIEvent.systemReset(),
                        MIDIEvent.systemReset(),
                        MIDIEvent.timeCodeQuarterFrame(type: .frameCountUpper4bit, value: 1),
                        MIDIEvent.systemReset(),
                    ]))
                }
            }
            describe("range") {
                context("messageType maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF1, 0b01110000])
                        expect(parsedEvents).to(equal([
                            MIDIEvent.timeCodeQuarterFrame(type: .timeCountUpper4bit, value: 0)
                        ]))
                    }
                }
                context("messageType minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF1, 0b00001111])
                        expect(parsedEvents).to(equal([
                            MIDIEvent.timeCodeQuarterFrame(type: .frameCountLower4bit, value: 15)
                        ]))
                    }
                }
                context("value maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF1, 0b00001111])
                        expect(parsedEvents).to(equal([
                            MIDIEvent.timeCodeQuarterFrame(type: .frameCountLower4bit, value: 15)
                        ]))
                    }
                }
                context("value minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF1, 0b00000000])
                        expect(parsedEvents).to(equal([
                            MIDIEvent.timeCodeQuarterFrame(type: .frameCountLower4bit, value: 0)
                        ]))
                    }
                }
            }
        }
        
        // MARK: Song Position Pointer
        describe("SongPositionPointer") {
            it("parse messages even if it contains RunningStatus") {
                let data: [UInt8] = [
                    0xF2,   1,    1,
                    0xF2,   3,    3,
                    7,    7, // Running Status
                    15,   15, // Running Status
                    0xF2,  31,   31,
                    0xF0,  11, 0xF7, // System Exclusive
                    0xF2,  63,   63,
                    127,  127, // Running Status
                    0xF0,  22, 0xF7, // System Exclusive
                    0xF2,   0,    0,
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    MIDIEvent.songPositionPointer(lsb:   1, msb:   1),
                    .songPositionPointer(lsb:   3, msb:   3),
                    .songPositionPointer(lsb:   7, msb:   7),
                    .songPositionPointer(lsb:  15, msb:  15),
                    .songPositionPointer(lsb:  31, msb:  31),
                    .sysEx([0xF0, 11, 0xF7]),
                    .songPositionPointer(lsb:  63, msb:  63),
                    .songPositionPointer(lsb: 127, msb: 127),
                    .sysEx([0xF0, 22, 0xF7]),
                    .songPositionPointer(lsb:   0, msb:   0),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 5 times "SongPositionPointer" will be interrupt by 13 times "UndefinedSystemRealTimeMessage2"
                    let data: [UInt8] = [
                        0xF2,         // 1st songPositionPointer
                        0xFD,
                        1,
                        0xFD,
                        1,
                        0xFD,
                        0xF2,         // 2nd songPositionPointer
                        0xFD,
                        1,
                        0xFD,
                        1,
                        0xFD,
                        1,     // 3rd songPositionPointer (running status)
                        0xFD,
                        1,
                        0xFD,
                        1,     // 4th songPositionPointer (running status)
                        0xFD,
                        1,
                        0xFD,
                        0xF2,         // 5th songPositionPointer
                        0xFD,
                        1,
                        0xFD,
                        1,
                        0xFD
                    ]
                    subject.input(data: data)
                }
                it("can parse songPositionPointer correctly") {
                    expect(parsedEvents).to(equal([
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .songPositionPointer(lsb: 1, msb: 1),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .songPositionPointer(lsb: 1, msb: 1),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .songPositionPointer(lsb: 1, msb: 1),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .songPositionPointer(lsb: 1, msb: 1),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .undefinedSystemRealTimeMessage2(),
                        .songPositionPointer(lsb: 1, msb: 1),
                        .undefinedSystemRealTimeMessage2(),
                    ]))
                }
            }
            describe("range") {
                context("lsb maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF2, 127, 64])
                        expect(parsedEvents).to(equal([
                            .songPositionPointer(lsb: 127, msb: 64)
                        ]))
                    }
                }
                context("lsb minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF2, 0, 64])
                        expect(parsedEvents).to(equal([
                            .songPositionPointer(lsb: 0, msb: 64)
                        ]))
                    }
                }
                context("msb maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF2, 64, 127])
                        expect(parsedEvents).to(equal([
                            .songPositionPointer(lsb: 64, msb: 127)
                        ]))
                    }
                }
                context("msb minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF2, 64, 0])
                        expect(parsedEvents).to(equal([
                            .songPositionPointer(lsb: 64, msb: 0)
                        ]))
                    }
                }
            }
        }
        
        // MARK: Song Select
        describe("SongSelect") {
            it("parse messages even if it contains RunningStatus") {
                let data: [UInt8] = [
                    0xF3,   1,
                    0xF3,   3,
                    7,       // Running Status
                    15,       // Running Status
                    0xF3,  31,
                    0xF0,  11, 0xF7, // System Exclusive
                    0xF3,  63,
                    127,       // Running Status
                    0xF0,  22, 0xF7, // System Exclusive
                    0xF3,   0,
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    MIDIEvent.songSelect(1),
                    .songSelect(3),
                    .songSelect(7),
                    .songSelect(15),
                    .songSelect(31),
                    .sysEx([0xF0, 11, 0xF7]),
                    .songSelect(63),
                    .songSelect(127),
                    .sysEx([0xF0, 22, 0xF7]),
                    .songSelect(0),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 5 times "SongSelect" will be interrupt by 8 times "SystemReset"
                    let data: [UInt8] = [
                        0xF3,         // 1st songSelect
                        0xFF,
                        1,
                        0xFF,
                        0xF3,         // 2nd songSelect
                        0xFF,
                        1,
                        0xFF,
                        1,     // 3rd songSelect (running status)
                        0xFF,
                        1,     // 4th songSelect (running status)
                        0xFF,
                        0xF3,         // 5th songSelect
                        0xFF,
                        1,
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse songSelect correctly") {
                    expect(parsedEvents).to(equal([
                        .systemReset(),
                        .songSelect(1),
                        .systemReset(),
                        .systemReset(),
                        .songSelect(1),
                        .systemReset(),
                        .songSelect(1),
                        .systemReset(),
                        .songSelect(1),
                        .systemReset(),
                        .systemReset(),
                        .songSelect(1),
                        .systemReset(),
                    ]))
                }
            }
            describe("range") {
                context("songNumber number maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF3, 127])
                        expect(parsedEvents).to(equal([
                            .songSelect(127)
                        ]))
                    }
                }
                context("songNumber number minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF3, 0])
                        expect(parsedEvents).to(equal([
                            .songSelect(0)
                        ]))
                    }
                }
            }
        }
        
        // MARK: Undefined System Common Message 1
        describe("UndefinedSystemCommonMessage1") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xF4,
                    0xF4,
                    0xF3,   0,
                    0xF4,
                    0xF3,   0,
                    0,
                    0xF4
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .undefinedSystemCommonMessage1(),
                    .undefinedSystemCommonMessage1(),
                    .songSelect(0),
                    .undefinedSystemCommonMessage1(),
                    .songSelect(0),
                    .songSelect(0),
                    .undefinedSystemCommonMessage1(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "UndefinedSystemCommonMessage1" will be interrupt by 3 times "SystemReset"
                    let data: [UInt8] = [
                        0xF4,         // 1st undefinedSystemCommonMessage1
                        0xFF,
                        0xF4,         // 2nd undefinedSystemCommonMessage1
                        0xFF,
                        0xF4,         // 5th undefinedSystemCommonMessage1
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse undefinedSystemCommonMessage correctly") {
                    expect(parsedEvents).to(equal([
                        .undefinedSystemCommonMessage1(),
                        .systemReset(),
                        .undefinedSystemCommonMessage1(),
                        .systemReset(),
                        .undefinedSystemCommonMessage1(),
                        .systemReset(),
                    ]))
                }
            }
        }
        
        // MARK: Undefined System Common Message 2
        describe("UndefinedSystemCommonMessage2") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xF5,
                    0xF5,
                    0xF3,   0,
                    0xF5,
                    0xF3,   0,
                    0,
                    0xF5
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .undefinedSystemCommonMessage2(),
                    .undefinedSystemCommonMessage2(),
                    .songSelect(0),
                    .undefinedSystemCommonMessage2(),
                    .songSelect(0),
                    .songSelect(0),
                    .undefinedSystemCommonMessage2(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "UndefinedSystemCommonMessage2" will be interrupt by 3 times "SystemReset"
                    let data: [UInt8] = [
                        0xF5,         // 1st undefinedSystemCommonMessage2
                        0xFF,
                        0xF5,         // 2nd undefinedSystemCommonMessage2
                        0xFF,
                        0xF5,         // 5th undefinedSystemCommonMessage2
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse undefinedSystemCommonMessage correctly") {
                    expect(parsedEvents).to(equal([
                        .undefinedSystemCommonMessage2(),
                        .systemReset(),
                        .undefinedSystemCommonMessage2(),
                        .systemReset(),
                        .undefinedSystemCommonMessage2(),
                        .systemReset(),
                    ]))
                }
            }
        }
        
        // MARK: Tune Request
        describe("TuneRequest") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xF6,
                    0xF6,
                    0xF3,   0,
                    0xF6,
                    0xF3,   0,
                    0,
                    0xF6
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .tuneRequest(),
                    .tuneRequest(),
                    .songSelect(0),
                    .tuneRequest(),
                    .songSelect(0),
                    .songSelect(0),
                    .tuneRequest(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "TuneRequest" will be interrupt by 3 times "SystemReset"
                    let data: [UInt8] = [
                        0xF6,         // 1st tuneRequest
                        0xFF,
                        0xF6,         // 2nd tuneRequest
                        0xFF,
                        0xF6,         // 5th tuneRequest
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse undefinedSystemCommonMessage correctly") {
                    expect(parsedEvents).to(equal([
                        .tuneRequest(),
                        .systemReset(),
                        .tuneRequest(),
                        .systemReset(),
                        .tuneRequest(),
                        .systemReset(),
                    ]))
                }
            }
        }
        
        // MARK: Timing Clock
        describe("TimingClock") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xF8,
                    0xF8,
                    0xF3,   0,
                    0xF8,
                    0xF3,   0,
                    0,
                    0xF8
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .timingClock(),
                    .timingClock(),
                    .songSelect(0),
                    .timingClock(),
                    .songSelect(0),
                    .songSelect(0),
                    .timingClock(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "TimingClock" will be interrupt by 3 times "SystemReset"
                    let data: [UInt8] = [
                        0xF8,         // 1st timingClock
                        0xFF,
                        0xF8,         // 2nd timingClock
                        0xFF,
                        0xF8,         // 5th timingClock
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse undefinedSystemCommonMessage correctly") {
                    expect(parsedEvents).to(equal([
                        .timingClock(),
                        .systemReset(),
                        .timingClock(),
                        .systemReset(),
                        .timingClock(),
                        .systemReset(),
                    ]))
                }
            }
        }
        
        // MARK: Undefined System RealTime Message 1
        describe("UndefinedSystemRealTimeMessage1") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xF9,
                    0xF9,
                    0xF3,   0,
                    0xF9,
                    0xF3,   0,
                    0,
                    0xF9
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .undefinedSystemRealTimeMessage1(),
                    .undefinedSystemRealTimeMessage1(),
                    .songSelect(0),
                    .undefinedSystemRealTimeMessage1(),
                    .songSelect(0),
                    .songSelect(0),
                    .undefinedSystemRealTimeMessage1(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "UndefinedSystemRealTimeMessage1" will be interrupt by 3 times "SystemReset"
                    let data: [UInt8] = [
                        0xF9,         // 1st undefinedSystemRealTimeMessage1
                        0xFF,
                        0xF9,         // 2nd undefinedSystemRealTimeMessage1
                        0xFF,
                        0xF9,         // 5th undefinedSystemRealTimeMessage1
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse undefinedSystemCommonMessage correctly") {
                    expect(parsedEvents).to(equal([
                        .undefinedSystemRealTimeMessage1(),
                        .systemReset(),
                        .undefinedSystemRealTimeMessage1(),
                        .systemReset(),
                        .undefinedSystemRealTimeMessage1(),
                        .systemReset(),
                    ]))
                }
            }
        }
        
        // MARK: Undefined System RealTime Message 2
        describe("UndefinedSystemRealTimeMessage2") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xFD,
                    0xFD,
                    0xF3,   0,
                    0xFD,
                    0xF3,   0,
                    0,
                    0xFD
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .undefinedSystemRealTimeMessage2(),
                    .undefinedSystemRealTimeMessage2(),
                    .songSelect(0),
                    .undefinedSystemRealTimeMessage2(),
                    .songSelect(0),
                    .songSelect(0),
                    .undefinedSystemRealTimeMessage2(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "UndefinedSystemRealTimeMessage2" will be interrupt by 3 times "SystemReset"
                    let data: [UInt8] = [
                        0xFD,         // 1st undefinedSystemRealTimeMessage2
                        0xFF,
                        0xFD,         // 2nd undefinedSystemRealTimeMessage2
                        0xFF,
                        0xFD,         // 5th undefinedSystemRealTimeMessage2
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse undefinedSystemCommonMessage correctly") {
                    expect(parsedEvents).to(equal([
                        .undefinedSystemRealTimeMessage2(),
                        .systemReset(),
                        .undefinedSystemRealTimeMessage2(),
                        .systemReset(),
                        .undefinedSystemRealTimeMessage2(),
                        .systemReset(),
                    ]))
                }
            }
        }
        
        // MARK: Start
        describe("Start") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xFA,
                    0xFA,
                    0xF3,   0,
                    0xFA,
                    0xF3,   0,
                    0,
                    0xFA
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .start(),
                    .start(),
                    .songSelect(0),
                    .start(),
                    .songSelect(0),
                    .songSelect(0),
                    .start(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "Start" will be interrupt by 3 times "SystemReset"
                    let data: [UInt8] = [
                        0xFA,         // 1st start
                        0xFF,
                        0xFA,         // 2nd start
                        0xFF,
                        0xFA,         // 5th start
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse undefinedSystemCommonMessage correctly") {
                    expect(parsedEvents).to(equal([
                        .start(),
                        .systemReset(),
                        .start(),
                        .systemReset(),
                        .start(),
                        .systemReset(),
                    ]))
                }
            }
        }
        
        // MARK: Continue
        describe("Continue") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xFB,
                    0xFB,
                    0xF3,   0,
                    0xFB,
                    0xF3,   0,
                    0,
                    0xFB
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .continue(),
                    .continue(),
                    .songSelect(0),
                    .continue(),
                    .songSelect(0),
                    .songSelect(0),
                    .continue(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "Continue" will be interrupt by 3 times "SystemReset"
                    let data: [UInt8] = [
                        0xFB,         // 1st continue
                        0xFF,
                        0xFB,         // 2nd continue
                        0xFF,
                        0xFB,         // 5th continue
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse undefinedSystemCommonMessage correctly") {
                    expect(parsedEvents).to(equal([
                        .continue(),
                        .systemReset(),
                        .continue(),
                        .systemReset(),
                        .continue(),
                        .systemReset(),
                    ]))
                }
            }
        }
        
        // MARK: Stop
        describe("Stop") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xFC,
                    0xFC,
                    0xF3,   0,
                    0xFC,
                    0xF3,   0,
                    0,
                    0xFC
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .stop(),
                    .stop(),
                    .songSelect(0),
                    .stop(),
                    .songSelect(0),
                    .songSelect(0),
                    .stop(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "Stop" will be interrupt by 3 times "SystemReset"
                    let data: [UInt8] = [
                        0xFC,         // 1st stop
                        0xFF,
                        0xFC,         // 2nd stop
                        0xFF,
                        0xFC,         // 5th stop
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse Stop correctly") {
                    expect(parsedEvents).to(equal([
                        .stop(),
                        .systemReset(),
                        .stop(),
                        .systemReset(),
                        .stop(),
                        .systemReset(),
                    ]))
                }
            }
        }
        
        // MARK: ActiveSensing
        describe("ActiveSensing") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xFE,
                    0xFE,
                    0xF3,   0,
                    0xFE,
                    0xF3,   0,
                    0,
                    0xFE
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .activeSensing(),
                    .activeSensing(),
                    .songSelect(0),
                    .activeSensing(),
                    .songSelect(0),
                    .songSelect(0),
                    .activeSensing(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "ActiveSensing" will be interrupt by 3 times "SystemReset"
                    let data: [UInt8] = [
                        0xFE,         // 1st activeSensing
                        0xFF,
                        0xFE,         // 2nd activeSensing
                        0xFF,
                        0xFE,         // 5th activeSensing
                        0xFF,
                    ]
                    subject.input(data: data)
                }
                it("can parse undefinedSystemCommonMessage correctly") {
                    expect(parsedEvents).to(equal([
                        .activeSensing(),
                        .systemReset(),
                        .activeSensing(),
                        .systemReset(),
                        .activeSensing(),
                        .systemReset(),
                    ]))
                }
            }
        }
        
        // MARK: SystemReset
        describe("SystemReset") {
            it("parse messages") {
                let data: [UInt8] = [
                    0xFF,
                    0xFF,
                    0xF3,   0,
                    0xFF,
                    0xF3,   0,
                    0,
                    0xFF
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    .systemReset(),
                    .systemReset(),
                    .songSelect(0),
                    .systemReset(),
                    .songSelect(0),
                    .songSelect(0),
                    .systemReset(),
                ]))
            }
            context("when real time message will interrupt") {
                beforeEach {
                    // 3 times "SystemReset" will be interrupt by 3 times "TimingClock"
                    let data: [UInt8] = [
                        0xFF,         // 1st systemReset
                        0xF8,
                        0xFF,         // 2nd systemReset
                        0xF8,
                        0xFF,         // 5th systemReset
                        0xF8,
                    ]
                    subject.input(data: data)
                }
                it("can parse undefinedSystemCommonMessage correctly") {
                    expect(parsedEvents).to(equal([
                        .systemReset(),
                        .timingClock(),
                        .systemReset(),
                        .timingClock(),
                        .systemReset(),
                        .timingClock(),
                    ]))
                }
            }
        }
        
        // MARK: System Exclusive
        describe("SystemExclusive") {
            it("normal") {
                let data: [UInt8] = [
                    0xF0, 0x43, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0xF7,
                    0xF0, 0x43, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF7
                ]
                subject.input(data: data)
                expect(parsedEvents).to(equal([
                    MIDIEvent.sysEx([0xF0, 0x43, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0xF7]),
                    MIDIEvent.sysEx([0xF0, 0x43, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF7])
                ]))
            }
            context("when real time message interrupts") {
                var data: [UInt8]!
                beforeEach {
                    data = [
                        0xF0, 0x43, 0x7F, 0x7F, 0x7F,
                        0xF8,                         // timing clock
                        0x7F, 0x7F, 0x7F, 0x7F, 0xF7,
                        
                        0xF0, 0x43, 0x00, 0x00, 0x00,
                        0xFA,                         // start
                        0xFB,                         // continue
                        0xFC,                         // stop
                        0x00, 0x00, 0x00, 0x00, 0xF7,
                        
                        0xFD,                         // undefined system realtime message 2
                        
                        0xF0,
                        0xFE,                         // active sensing
                        0x43,
                        0xFF,                         // system reset
                        0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0xF7
                    ]
                    subject.input(data: data)
                }
                it("parse system exclusive correctly") {
                    expect(parsedEvents).to(equal([
                        MIDIEvent.timingClock(),
                        MIDIEvent.sysEx([0xF0, 0x43, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0xF7]),
                        MIDIEvent.start(),
                        MIDIEvent.continue(),
                        MIDIEvent.stop(),
                        MIDIEvent.sysEx([0xF0, 0x43, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF7]),
                        MIDIEvent.undefinedSystemRealTimeMessage2(),
                        MIDIEvent.activeSensing(),
                        MIDIEvent.systemReset(),
                        MIDIEvent.sysEx([0xF0, 0x43, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0xF7])
                    ]))
                }
            }
            context("large message") {
                let messageBody = [UInt8](repeating: 0x70, count: 1024 * 1024 * 5)
                it("parse correctly") {
                    subject.input(data: [0xF0] + messageBody + [0xF7])
                    expect(parsedEvents).to(equal([
                        .sysEx([0xF0] + messageBody + [0xF7])
                    ]))
                }
                
                context("and splitted message") {
                    it("parse correctly") {
                        let splittedBody = (0..<(1024 * 1024 * 5 / 4)).map { _ in
                            [0x66, 0x66, 0x66, 0x66] as [UInt8]
                        }
                        
                        subject.input(data: [0xF0])
                        
                        splittedBody.forEach {
                            subject.input(data: $0)
                        }
                        
                        subject.input(data: [0xF7])
                        
                        expect(parsedEvents).to(equal([
                            .sysEx(
                                [0xF0] +
                                    [UInt8](repeating: 0x66, count: 1024 * 1024 * 5) +
                                    [0xF7]
                            )
                        ]))
                    }
                }
            }
        }
        
        describe("MIDI protocol violation") {
            context("when pass non-status bytes before status") {
                it("ignores these element (does not crash)") {
                    subject.input(data: [0x7F, 0x7F, 0x7F])
                }
                context("then pass normal data (e.g. noteOn)") {
                    it("can parse normal data") {
                        subject.input(data: [
                            0x7F, 0x7F, 0x7F, // violation
                            0x9F,   15,   15  // correct noteOn
                        ])
                        expect(parsedEvents).to(equal([
                            .noteOn(channel: 15, note: 15, velocity: 15)
                        ]))
                    }
                }
            }
            
            context("when pass new status byte before previous parsing completed") {
                it("does not crash and parse new message correctly") {
                    subject.input(data: [
                        0x9F,   15,       // Incomplete noteOn.
                        0x8F,   15,  15   // noteOff
                    ])
                    
                    expect(parsedEvents).to(equal([
                        .noteOff(channel: 15, note: 15, velocity: 15)
                    ]))
                }
            }
        }
        
        // MARK: Error Cases
        describe("error cases") {
            context("when input NoteOn between one SysEx") {
                // Actually, this behavior is not only about NoteOn.
                // This test case describes that the parser should performe this
                // behavior for all non-realtime messages.
                beforeEach {
                    subject.input(data: [0xF0])
                    subject.input(data: [0x90, 0x7F, 0x7F])
                    subject.input(data: [0xF7])
                }
                it("parses NoteOn correctly and ignores SysEx") {
                    expect(parsedEvents).to(equal([
                        .noteOn(channel: 0, note: 0x7F, velocity: 0x7F)
                    ]))
                }
            }
            context("when input corrupted (head dropped) SyEx") {
                beforeEach {
                    subject.input(data: [
                        // Corrupted SysEx
                        // last '247 (0xF7)' is EndOfExclusive
                        // but there is no '0xF0' SystemExclusive status byte.
                        114, 97, 0, 110, 103, 101, 109, 101, 110, 116, 0, 115, 47, 67,
                        108, 97, 115, 115, 0, 105, 99, 48, 49, 46, 83, 48, 0, 48, 48, 46,
                        109, 105, 100, 247,
                        
                        // Simple, NoteOn
                        0x90, 0x7F, 0x7F,
                    ])
                    
                }
                it("ignore them then parse next data correctly") {
                    expect(parsedEvents) == [
                        .noteOn(channel: 0, note: 0x7F, velocity: 0x7F)
                    ]
                }
            }
        }
    }
}
