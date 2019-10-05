//
//  ParserSpec.swift
//  SwiftyMIDIParserTests
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import SwiftyMIDIParser

class ParserSpec: QuickSpec {
    override func spec() {
        var subject: Parser!
        
        var noteOffs: [NoteOff]!
        var noteOns: [NoteOn]!
        var polyphonicKeyPressures: [PolyphonicKeyPressure]!
        var controlChanges: [ControlChange]!
        var programChanges: [ProgramChange]!
        var channelPressures: [ChannelPressure]!
        var pitchBendChanges: [PitchBendChange]!
        var timeCodeQuarterFrames: [TimeCodeQuarterFrame]!
        var songPositionPointers: [SongPositionPointer]!
        var songSelects: [SongSelect]!
        var systemExclusives: [SystemExclusive]!
        
        beforeEach {
            subject = Parser()
            
            noteOffs = []
            noteOns = []
            polyphonicKeyPressures = []
            controlChanges = []
            programChanges = []
            channelPressures = []
            pitchBendChanges = []
            timeCodeQuarterFrames = []
            songPositionPointers = []
            songSelects = []
            systemExclusives = []
            
            subject.notifier.noteOff = { noteOffs.append($0) }
            subject.notifier.noteOn = { noteOns.append($0) }
            subject.notifier.polyphonicKeyPressure = { polyphonicKeyPressures.append($0) }
            subject.notifier.controlChange = { controlChanges.append($0) }
            subject.notifier.programChange = { programChanges.append($0) }
            subject.notifier.channelPressure = { channelPressures.append($0) }
            subject.notifier.pitchBendChange = { pitchBendChanges.append($0) }
            subject.notifier.timeCodeQuarterFrame = { timeCodeQuarterFrames.append($0) }
            subject.notifier.songPositionPointer = { songPositionPointers.append($0) }
            subject.notifier.songSelect = { songSelects.append($0) }
            subject.notifier.systemExclusive = { systemExclusives.append($0) }
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
                expect(noteOns).to(equal([
                    NoteOn(channel: 5, note:   1, velocity:   1),
                    NoteOn(channel: 5, note:   3, velocity:   3),
                    NoteOn(channel: 5, note:   7, velocity:   7),
                    NoteOn(channel: 5, note:  15, velocity:  15),
                    NoteOn(channel: 5, note:  31, velocity:  31),
                    NoteOn(channel: 5, note:  63, velocity:  63),
                    NoteOn(channel: 5, note: 127, velocity: 127),
                    NoteOn(channel: 5, note:   0, velocity:   0),
                ]))
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x9F, 64, 64])
                        expect(noteOns).to(equal([
                            NoteOn(channel: 15, note: 64, velocity: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x90, 64, 64])
                        expect(noteOns).to(equal([
                            NoteOn(channel: 0, note: 64, velocity: 64)
                        ]))
                    }
                }
                context("note maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x95, 127, 64])
                        expect(noteOns).to(equal([
                            NoteOn(channel: 5, note: 127, velocity: 64)
                        ]))
                    }
                }
                context("note minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x95, 0, 64])
                        expect(noteOns).to(equal([
                            NoteOn(channel: 5, note: 0, velocity: 64)
                        ]))
                    }
                }
                context("velocity maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x95, 64, 127])
                        expect(noteOns).to(equal([
                            NoteOn(channel: 5, note: 64, velocity: 127)
                        ]))
                    }
                }
                context("velocity minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x95, 64, 0])
                        expect(noteOns).to(equal([
                            NoteOn(channel: 5, note: 64, velocity: 0)
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
                expect(noteOffs).to(equal([
                    NoteOff(channel: 6, note:   1, velocity:   1),
                    NoteOff(channel: 6, note:   3, velocity:   3),
                    NoteOff(channel: 6, note:   7, velocity:   7),
                    NoteOff(channel: 6, note:  15, velocity:  15),
                    NoteOff(channel: 6, note:  31, velocity:  31),
                    NoteOff(channel: 6, note:  63, velocity:  63),
                    NoteOff(channel: 6, note: 127, velocity: 127),
                    NoteOff(channel: 6, note:   0, velocity:   0),
                ]))
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x8F, 64, 64])
                        expect(noteOffs).to(equal([
                            NoteOff(channel: 15, note: 64, velocity: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x80, 64, 64])
                        expect(noteOffs).to(equal([
                            NoteOff(channel: 0, note: 64, velocity: 64)
                        ]))
                    }
                }
                context("note maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x85, 127, 64])
                        expect(noteOffs).to(equal([
                            NoteOff(channel: 5, note: 127, velocity: 64)
                        ]))
                    }
                }
                context("note minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x85, 0, 64])
                        expect(noteOffs).to(equal([
                            NoteOff(channel: 5, note: 0, velocity: 64)
                        ]))
                    }
                }
                context("velocity maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0x85, 64, 127])
                        expect(noteOffs).to(equal([
                            NoteOff(channel: 5, note: 64, velocity: 127)
                        ]))
                    }
                }
                context("velocity minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0x85, 64, 0])
                        expect(noteOffs).to(equal([
                            NoteOff(channel: 5, note: 64, velocity: 0)
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
                expect(polyphonicKeyPressures).to(equal([
                    PolyphonicKeyPressure(channel: 5, note:   1, pressure:   1),
                    PolyphonicKeyPressure(channel: 5, note:   3, pressure:   3),
                    PolyphonicKeyPressure(channel: 5, note:   7, pressure:   7),
                    PolyphonicKeyPressure(channel: 5, note:  15, pressure:  15),
                    PolyphonicKeyPressure(channel: 5, note:  31, pressure:  31),
                    PolyphonicKeyPressure(channel: 5, note:  63, pressure:  63),
                    PolyphonicKeyPressure(channel: 5, note: 127, pressure: 127),
                    PolyphonicKeyPressure(channel: 5, note:   0, pressure:   0),
                ]))
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xAF, 64, 64])
                        expect(polyphonicKeyPressures).to(equal([
                            PolyphonicKeyPressure(channel: 15, note: 64, pressure: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xA0, 64, 64])
                        expect(polyphonicKeyPressures).to(equal([
                            PolyphonicKeyPressure(channel: 0, note: 64, pressure: 64)
                        ]))
                    }
                }
                context("note maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xA5, 127, 64])
                        expect(polyphonicKeyPressures).to(equal([
                            PolyphonicKeyPressure(channel: 5, note: 127, pressure: 64)
                        ]))
                    }
                }
                context("note minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xA5, 0, 64])
                        expect(polyphonicKeyPressures).to(equal([
                            PolyphonicKeyPressure(channel: 5, note: 0, pressure: 64)
                        ]))
                    }
                }
                context("pressure maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xA5, 64, 127])
                        expect(polyphonicKeyPressures).to(equal([
                            PolyphonicKeyPressure(channel: 5, note: 64, pressure: 127)
                        ]))
                    }
                }
                context("pressure minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xA5, 64, 0])
                        expect(polyphonicKeyPressures).to(equal([
                            PolyphonicKeyPressure(channel: 5, note: 64, pressure: 0)
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
                expect(controlChanges).to(equal([
                    ControlChange(channel: 5, controlNumber: ControlNumber(rawValue:    1)!, value:   1),
                    ControlChange(channel: 5, controlNumber: ControlNumber(rawValue:    3)!, value:   3),
                    ControlChange(channel: 5, controlNumber: ControlNumber(rawValue:    7)!, value:   7),
                    ControlChange(channel: 5, controlNumber: ControlNumber(rawValue:   15)!, value:  15),
                    ControlChange(channel: 5, controlNumber: ControlNumber(rawValue:   31)!, value:  31),
                    ControlChange(channel: 5, controlNumber: ControlNumber(rawValue:   63)!, value:  63),
                    ControlChange(channel: 5, controlNumber: ControlNumber(rawValue:  127)!, value: 127),
                    ControlChange(channel: 5, controlNumber: ControlNumber(rawValue:    0)!, value:   0),
                ]))
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xBF, 64, 64])
                        expect(controlChanges).to(equal([
                            ControlChange(channel: 15, controlNumber: .damperPedal, value: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xB0, 64, 64])
                        expect(controlChanges).to(equal([
                            ControlChange(channel: 0, controlNumber: .damperPedal, value: 64)
                        ]))
                    }
                }
                context("control number maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xB5, 127, 64])
                        expect(controlChanges).to(equal([
                            ControlChange(channel: 5, controlNumber: .polyModeOn, value: 64)
                        ]))
                    }
                }
                context("control number minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xB5, 0, 64])
                        expect(controlChanges).to(equal([
                            ControlChange(channel: 5, controlNumber: .bankSelectMSB, value: 64)
                        ]))
                    }
                }
                context("value maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xB5, 64, 127])
                        expect(controlChanges).to(equal([
                            ControlChange(channel: 5, controlNumber: .damperPedal, value: 127)
                        ]))
                    }
                }
                context("value minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xB5, 64, 0])
                        expect(controlChanges).to(equal([
                            ControlChange(channel: 5, controlNumber: .damperPedal, value: 0)
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
                expect(programChanges).to(equal([
                    ProgramChange(channel: 5,  program:   1),
                    ProgramChange(channel: 5,  program:   3),
                    ProgramChange(channel: 5,  program:   7),
                    ProgramChange(channel: 5,  program:  15),
                    ProgramChange(channel: 5,  program:  31),
                    ProgramChange(channel: 5,  program:  63),
                    ProgramChange(channel: 5,  program: 127),
                    ProgramChange(channel: 5,  program:   0),
                ]))
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xCF, 64])
                        expect(programChanges).to(equal([
                            ProgramChange(channel: 15,  program: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xC0, 64])
                        expect(programChanges).to(equal([
                            ProgramChange(channel: 0,  program: 64)
                        ]))
                    }
                }
                context("program number maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xC5, 127])
                        expect(programChanges).to(equal([
                            ProgramChange(channel: 5,  program: 127)
                        ]))
                    }
                }
                context("program number minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xC5, 0])
                        expect(programChanges).to(equal([
                            ProgramChange(channel: 5,  program: 0)
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
                expect(channelPressures).to(equal([
                    ChannelPressure(channel: 5,  pressure:   1),
                    ChannelPressure(channel: 5,  pressure:   3),
                    ChannelPressure(channel: 5,  pressure:   7),
                    ChannelPressure(channel: 5,  pressure:  15),
                    ChannelPressure(channel: 5,  pressure:  31),
                    ChannelPressure(channel: 5,  pressure:  63),
                    ChannelPressure(channel: 5,  pressure: 127),
                    ChannelPressure(channel: 5,  pressure:   0),
                ]))
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xDF, 64])
                        expect(channelPressures).to(equal([
                            ChannelPressure(channel: 15,  pressure: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xD0, 64])
                        expect(channelPressures).to(equal([
                            ChannelPressure(channel: 0,  pressure: 64)
                        ]))
                    }
                }
                context("pressure maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xD5, 127])
                        expect(channelPressures).to(equal([
                            ChannelPressure(channel: 5,  pressure: 127)
                        ]))
                    }
                }
                context("pressure minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xD5, 0])
                        expect(channelPressures).to(equal([
                            ChannelPressure(channel: 5,  pressure: 0)
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
                expect(pitchBendChanges).to(equal([
                    PitchBendChange(channel: 5, lsb:   1, msb:   1),
                    PitchBendChange(channel: 5, lsb:   3, msb:   3),
                    PitchBendChange(channel: 5, lsb:   7, msb:   7),
                    PitchBendChange(channel: 5, lsb:  15, msb:  15),
                    PitchBendChange(channel: 5, lsb:  31, msb:  31),
                    PitchBendChange(channel: 5, lsb:  63, msb:  63),
                    PitchBendChange(channel: 5, lsb: 127, msb: 127),
                    PitchBendChange(channel: 5, lsb:   0, msb:   0),
                ]))
            }
            describe("range") {
                context("channel maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xEF, 64, 64])
                        expect(pitchBendChanges).to(equal([
                            PitchBendChange(channel: 15, lsb: 64, msb: 64)
                        ]))
                    }
                }
                context("channel minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xE0, 64, 64])
                        expect(pitchBendChanges).to(equal([
                            PitchBendChange(channel: 0, lsb: 64, msb: 64)
                        ]))
                    }
                }
                context("lsb maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xE5, 127, 64])
                        expect(pitchBendChanges).to(equal([
                            PitchBendChange(channel: 5, lsb: 127, msb: 64)
                        ]))
                    }
                }
                context("lsb minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xE5, 0, 64])
                        expect(pitchBendChanges).to(equal([
                            PitchBendChange(channel: 5, lsb: 0, msb: 64)
                        ]))
                    }
                }
                context("msb maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xE5, 64, 127])
                        expect(pitchBendChanges).to(equal([
                            PitchBendChange(channel: 5, lsb: 64, msb: 127)
                        ]))
                    }
                }
                context("msb minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xE5, 64, 0])
                        expect(pitchBendChanges).to(equal([
                            PitchBendChange(channel: 5, lsb: 64, msb: 0)
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
                expect(timeCodeQuarterFrames).to(equal([
                    TimeCodeQuarterFrame(messageType: .frameCountLower4bit,  value:  1),
                    TimeCodeQuarterFrame(messageType: .frameCountLower4bit,  value:  3),
                    TimeCodeQuarterFrame(messageType: .frameCountLower4bit,  value:  7),
                    TimeCodeQuarterFrame(messageType: .frameCountLower4bit,  value: 15),
                    TimeCodeQuarterFrame(messageType: .frameCountUpper4bit,  value: 15),
                    TimeCodeQuarterFrame(messageType: .secondCountUpper4bit, value: 15),
                    TimeCodeQuarterFrame(messageType: .timeCountUpper4bit,   value: 15),
                    TimeCodeQuarterFrame(messageType: .timeCountUpper4bit,   value: 15),
                ]))
            }
            describe("range") {
                context("messageType maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF1, 0b01110000])
                        expect(timeCodeQuarterFrames).to(equal([
                            TimeCodeQuarterFrame(messageType: .timeCountUpper4bit, value: 0)
                        ]))
                    }
                }
                context("messageType minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF1, 0b00001111])
                        expect(timeCodeQuarterFrames).to(equal([
                            TimeCodeQuarterFrame(messageType: .frameCountLower4bit, value: 15)
                        ]))
                    }
                }
                context("value maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF1, 0b00001111])
                        expect(timeCodeQuarterFrames).to(equal([
                            TimeCodeQuarterFrame(messageType: .frameCountLower4bit, value: 15)
                        ]))
                    }
                }
                context("value minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF1, 0b00000000])
                        expect(timeCodeQuarterFrames).to(equal([
                            TimeCodeQuarterFrame(messageType: .frameCountLower4bit, value: 0)
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
                expect(songPositionPointers).to(equal([
                    SongPositionPointer(lsb:   1, msb:   1),
                    SongPositionPointer(lsb:   3, msb:   3),
                    SongPositionPointer(lsb:   7, msb:   7),
                    SongPositionPointer(lsb:  15, msb:  15),
                    SongPositionPointer(lsb:  31, msb:  31),
                    SongPositionPointer(lsb:  63, msb:  63),
                    SongPositionPointer(lsb: 127, msb: 127),
                    SongPositionPointer(lsb:   0, msb:   0),
                ]))
            }
            describe("range") {
                context("lsb maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF2, 127, 64])
                        expect(songPositionPointers).to(equal([
                            SongPositionPointer(lsb: 127, msb: 64)
                        ]))
                    }
                }
                context("lsb minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF2, 0, 64])
                        expect(songPositionPointers).to(equal([
                            SongPositionPointer(lsb: 0, msb: 64)
                        ]))
                    }
                }
                context("msb maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF2, 64, 127])
                        expect(songPositionPointers).to(equal([
                            SongPositionPointer(lsb: 64, msb: 127)
                        ]))
                    }
                }
                context("msb minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF2, 64, 0])
                        expect(songPositionPointers).to(equal([
                            SongPositionPointer(lsb: 64, msb: 0)
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
                expect(songSelects).to(equal([
                    SongSelect(songNumber:   1),
                    SongSelect(songNumber:   3),
                    SongSelect(songNumber:   7),
                    SongSelect(songNumber:  15),
                    SongSelect(songNumber:  31),
                    SongSelect(songNumber:  63),
                    SongSelect(songNumber: 127),
                    SongSelect(songNumber:   0),
                ]))
            }
            describe("range") {
                context("songNumber number maximum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF3, 127])
                        expect(songSelects).to(equal([
                            SongSelect(songNumber: 127)
                        ]))
                    }
                }
                context("songNumber number minimum") {
                    it("can parse correctly") {
                        subject.input(data: [0xF3, 0])
                        expect(songSelects).to(equal([
                            SongSelect(songNumber: 0)
                        ]))
                    }
                }
            }
        }
    }
}
