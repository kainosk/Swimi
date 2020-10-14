//
//  TrackEventSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/17.
//
import Foundation
import Quick
import Nimble
@testable import Swimi

class TrackEventSpec: QuickSpec {
    override func spec() {
        describe("smfBytes") {
            context("midi") {
                it("returns MIDIEvent's smfBytes as is") {
                    let midi: SMFMIDIEvent = .noteOn(channel: 10, note: 99, velocity: 99)
                    let e = TrackEvent<SS>.midi(midi)
                    expect(e.smfBytes) == midi.smfBytes
                }
            }
            context("sysEx") {
                it("returns SysExEvent's smfBytes as is") {
                    let sysEx: SMFSysExEvent = .f7([0x22])
                    let e = TrackEvent<SS>.sysEx(sysEx)
                    expect(e.smfBytes) == sysEx.smfBytes
                }
            }
            context("meta") {
                it("returns MetaEvent's smfBytes as is") {
                    let meta: MetaEvent<SS> = .lyric([0x22, 0x33])
                    let e = TrackEvent<SS>.meta(meta)
                    expect(e.smfBytes) == meta.smfBytes
                }
            }
        }
        
        describe("midiEventOrNil") {
            context("midi") {
                it("returns MIDIEvent as is") {
                    let midiEvent: SMFMIDIEvent =
                        .noteOn(channel: 10, note: 99, velocity: 99)
                    let e = TrackEvent<SS>.midi(midiEvent)
                    expect(e.midiEventOrNil) == midiEvent
                }
            }
            context("sysEx") {
                it("returns nil") {
                    let e = TrackEvent<SS>.sysEx(.f7([0x22]))
                    expect(e.midiEventOrNil).to(beNil())
                }
            }
            context("meta") {
                it("returns nil") {
                    let e = TrackEvent<SS>.meta(
                        .lyric([0x22, 0x33])
                    )
                    expect(e.midiEventOrNil).to(beNil())
                }
            }
        }
        
        describe("noteOffOrNil") {
            context("midi (noteOff)") {
                it("returns MIDIEvent's noteOffOrNil as is") {
                    let noteOff = NoteOff(channel: 10, note: 99, velocity: 99)
                    let midiEvent: SMFMIDIEvent = .noteOff(noteOff)
                    let e = TrackEvent<SS>.midi(midiEvent)
                    expect(e.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true))
                        == midiEvent.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true)
                }
            }
            context("midi (not noteOff)") {
                it("returns MIDIEvent's noteOffOrNil as is") {
                    let midiEvent: SMFMIDIEvent = .continue()
                    let e = TrackEvent<SS>.midi(midiEvent)
                    expect(e.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true)).to(beNil())
                }
            }
            context("sysEx") {
                it("returns nil") {
                    let e = TrackEvent<SS>.sysEx(.f7([0x22]))
                    expect(e.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true)).to(beNil())
                }
            }
            context("meta") {
                it("returns nil") {
                    let e = TrackEvent<SS>.meta(
                        .lyric([0x22, 0x33])
                    )
                    expect(e.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true)).to(beNil())
                }
            }
        }
        
        describe("noteOnOrNil") {
            context("midi (noteOn)") {
                it("returns MIDIEvent's noteOnOrNil as is") {
                    let noteOn = NoteOn(channel: 10, note: 99, velocity: 99)
                    let midiEvent: SMFMIDIEvent = .noteOn(noteOn)
                    let e = TrackEvent<SS>.midi(midiEvent)
                    expect(e.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true))
                        == midiEvent.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true)
                }
            }
            context("midi (not noteOn)") {
                it("returns MIDIEvent's noteOnOrNil as is") {
                    let midiEvent: SMFMIDIEvent = .continue()
                    let e = TrackEvent<SS>.midi(midiEvent)
                    expect(e.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true)).to(beNil())
                }
            }
            context("sysEx") {
                it("returns nil") {
                    let e = TrackEvent<SS>.sysEx(.f7([0x22]))
                    expect(e.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true)).to(beNil())
                }
            }
            context("meta") {
                it("returns nil") {
                    let e = TrackEvent<SS>.meta(
                        .lyric([0x22, 0x33])
                    )
                    expect(e.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true)).to(beNil())
                }
            }
        }
        
        describe("isNoteOn") {
            context("event is midi") {
                it("returns MIDIEvent's isNoteOn as is") {
                    let midiEvent: SMFMIDIEvent =
                        .noteOn(channel: 1, note: 1, velocity: 1)
                    let e = TrackEvent<SS>.midi(midiEvent)
                    expect(e.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: true)) ==
                        midiEvent.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: true)
                }
            }
            context("event is not midi") {
                it("returns false") {
                    let e = TrackEvent<SS>.meta(.endOfTrack())
                    expect(e.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: true)) == false
                }
            }
        }
        
        describe("isNoteOff") {
            context("event is midi") {
                it("returns MIDIEvent's isNoteOff as is") {
                    let midiEvent: SMFMIDIEvent =
                        .noteOff(channel: 1, note: 1, velocity: 1)
                    let e = TrackEvent<SS>.midi(midiEvent)
                    expect(e.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: true)) ==
                        midiEvent.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: true)
                }
            }
            context("event is not midi") {
                it("returns false") {
                    let e = TrackEvent<SS>.meta(.endOfTrack())
                    expect(e.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: true)) == false
                }
            }
        }
        
        describe("belongingChannel") {
            context("event is not midi") {
                it("returns nil") {
                    let e = TrackEvent<SS>.meta(.endOfTrack())
                    expect(e.belongingChannel).to(beNil())
                }
            }
            context("event is midi") {
                context("event has channel") {
                    it("returns MIDIEvent's belongingChannel as is ") {
                        let midiEvent =
                            SMFMIDIEvent.noteOn(channel: 1, note: 2, velocity: 3)
                        let e = TrackEvent<SS>.midi(midiEvent)
                        expect(e.belongingChannel) == midiEvent.belongingChannel
                    }
                }
                context("event has not channel") {
                    it("returns nil") {
                        let midiEvent = SMFMIDIEvent.continue()
                        let e = TrackEvent<SS>.midi(midiEvent)
                        expect(e.belongingChannel).to(beNil())
                        expect(midiEvent.belongingChannel).to(beNil())
                    }
                }
            }
        }
        
        describe("belongsTo") {
            context("event is midi") {
                it("returns MIDIEvent's belongsTo as is") {
                    let midiEvent =
                        SMFMIDIEvent.noteOff(channel: 2, note: 3, velocity: 4)
                    let e = TrackEvent<SS>.midi(midiEvent)
                    expect(e.belongsTo(channel: 2)) == midiEvent.belongsTo(channel: 2)
                }
            }
            context("event is not midi") {
                it("returns false") {
                    let e = TrackEvent<SS>.meta(.endOfTrack())
                    expect(e.belongsTo(channel: 2)) == false
                }
            }
        }
        
        describe("timeSignatureOrNil") {
            context("event is meta") {
                it("returns MetaEvent's timeSignatureOrNil as is") {
                    let metaEvent = MetaEvent<SS>.timeSignature(.standardFourFour)
                    let e = TrackEvent<SS>.meta(metaEvent)
                    expect(e.timeSignatureOrNil) == metaEvent.timeSignatureOrNil
                }
            }
            context("event is not meta") {
                it("returns nil") {
                    let e = TrackEvent<SS>.midi(.continue())
                    expect(e.timeSignatureOrNil).to(beNil())
                }
            }
        }
    }
}
