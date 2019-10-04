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
        
        var noteOns: [NoteOn]!
        var systemExclusives: [SystemExclusive]!
        
        beforeEach {
            subject = Parser()
            
            noteOns = []
            systemExclusives = []
            
            subject.notifier.noteOn = { noteOns.append($0) }
            subject.notifier.systemExclusive = { systemExclusives.append($0) }
        }
        
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
    }
}
