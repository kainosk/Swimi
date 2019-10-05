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
        var systemExclusives: [SystemExclusive]!
        
        beforeEach {
            subject = Parser()
            
            noteOffs = []
            noteOns = []
            polyphonicKeyPressures = []
            systemExclusives = []
            
            subject.notifier.noteOff = { noteOffs.append($0) }
            subject.notifier.noteOn = { noteOns.append($0) }
            subject.notifier.polyphonicKeyPressure = { polyphonicKeyPressures.append($0) } 
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
    }
}
