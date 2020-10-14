//
//  MIDIEventSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/24.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class SMFMIDIEventSpec: QuickSpec {
    override func spec() {
        describe("smfBytes") {
            it("can provide NoteOn's bytes") {
                let c = NoteOn(channel: 1, note: 2, velocity: 3)
                let e: SMFMIDIEvent = .noteOn(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide NoteOff's bytes") {
                let c = NoteOff(channel: 1, note: 2, velocity: 3)
                let e: SMFMIDIEvent = .noteOff(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide PolyphonicKeyPressure's bytes") {
                let c = PolyphonicKeyPressure(channel: 1, note: 2, pressure: 3)
                let e: SMFMIDIEvent = .polyphonicKeyPressure(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide ControlChange's bytes") {
                let c = ControlChange(channel: 1, controlNumber: .balance, value: 3)
                let e: SMFMIDIEvent = .controlChange(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide ProgramChange's bytes") {
                let c = ProgramChange(channel: 1, program: 2)
                let e: SMFMIDIEvent = .programChange(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide ChannelPressure's bytes") {
                let c = ChannelPressure(channel: 1, pressure: 2)
                let e: SMFMIDIEvent = .channelPressure(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide PitchBend's bytes") {
                let c = PitchBendChange(channel: 1, lsb: 2, msb: 3)
                let e: SMFMIDIEvent = .pitchBendChange(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide TimeCodeQuarterFrame's bytes") {
                let c = TimeCodeQuarterFrame(messageType: .frameCountLower4bit, value: 1)
                let e: SMFMIDIEvent = .timeCodeQuarterFrame(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide SongPositionPointer's bytes") {
                let c = SongPositionPointer(lsb: 1, msb: 2)
                let e: SMFMIDIEvent = .songPositionPointer(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide SongSelect's bytes") {
                let c = SongSelect(songNumber: 1)
                let e: SMFMIDIEvent = .songSelect(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide UndefinedSystemCommonMessage1's bytes") {
                let c = UndefinedSystemCommonMessage1()
                let e: SMFMIDIEvent = .undefinedSystemCommonMessage1(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide UndefinedSystemCommonMessage2's bytes") {
                let c = UndefinedSystemCommonMessage2()
                let e: SMFMIDIEvent = .undefinedSystemCommonMessage2(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide TuneRequest's bytes") {
                let c = TuneRequest()
                let e: SMFMIDIEvent = .tuneRequest(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide TimingClock's bytes") {
                let c = TimingClock()
                let e: SMFMIDIEvent = .timingClock(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide UndefinedSystemRealTimeMessage1's bytes") {
                let c = UndefinedSystemRealTimeMessage1()
                let e: SMFMIDIEvent = .undefinedSystemRealTimeMessage1(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide UndefinedSystemRealTimeMessage2's bytes") {
                let c = UndefinedSystemRealTimeMessage2()
                let e: SMFMIDIEvent = .undefinedSystemRealTimeMessage2(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide Start's bytes") {
                let c = Start()
                let e: SMFMIDIEvent = .start(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide Continue's bytes") {
                let c = Continue()
                let e: SMFMIDIEvent = .continue(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide Stop's bytes") {
                let c = Stop()
                let e: SMFMIDIEvent = .stop(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide ActiveSensing's bytes") {
                let c = ActiveSensing()
                let e: SMFMIDIEvent = .activeSensing(c)
                expect(e.smfBytes) == c.bytes
            }
            it("can provide SystemReset's bytes") {
                let c = SystemReset()
                let e: SMFMIDIEvent = .systemReset(c)
                expect(e.smfBytes) == c.bytes
            }
        }
        
        describe("noteOnOrNil and isNoteOn") {
            var event: SMFMIDIEvent!
            context("event is NoteOn") {
                context("velocity 0") {
                    beforeEach {
                        event = .noteOn(channel: 1, note: 2, velocity: 0)
                    }
                    context("treatZeroVelocityNoteOnAsNoteOff false") {
                        it("returns NoteOn as noteOnOrNil") {
                            expect(event.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: false))
                                == NoteOn(channel: 1, note: 2, velocity: 0)
                        }
                        it("returns true as isNoteOn") {
                            expect(event.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: false))
                                == true
                        }
                    }
                    context("treatZeroVelocityNoteOnAsNoteOff true") {
                        it("returns nil as noteOnOrNil") {
                            expect(event.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true))
                                .to(beNil())
                        }
                        it("returns false as noteOnOrNil") {
                            expect(event.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: true))
                                == false
                        }
                    }
                }
                context("velocity is larger than 0") {
                    let on = NoteOn(channel: 1, note: 2, velocity: 3)
                    beforeEach {
                        event = .noteOn(on)
                    }
                    it("returns NoteOn as noteOnOrNil regardless of treatZeroVelocityNoteOnAsNoteOff") {
                        expect(event.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true))
                            == on
                        expect(event.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: false))
                            == on
                    }
                    it("returns true as isNoteOn regardless of treatZeroVelocityNoteOnAsNoteOff") {
                        expect(event.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: true))
                            == true
                        expect(event.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: false))
                            == true
                    }
                }
            }
            context("event is NoteOff") {
                beforeEach {
                    event = .noteOff(channel: 1, note: 2, velocity: 3)
                }
                it("returns nil as noteOnOrNil regardless of treatZeroVelocityNoteOnAsNoteOff") {
                    expect(event.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true))
                        .to(beNil())
                    expect(event.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: false))
                        .to(beNil())
                }
                it("returns false as isNoteOn regardless of treatZeroVelocityNoteOnAsNoteOff") {
                    expect(event.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: true))
                        == false
                    expect(event.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: false))
                        == false
                }
            }
            context("event is others") {
                beforeEach {
                    event = .controlChange(
                        ControlChange(channel: 1, controlNumber: .balance, value: 3)
                    )
                }
                it("returns nil as noteOnOrNil regardless of treatZeroVelocityNoteOnAsNoteOff") {
                    expect(event.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true))
                        .to(beNil())
                    expect(event.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: false))
                        .to(beNil())
                }
                it("returns false as isNoteOn regardless of treatZeroVelocityNoteOnAsNoteOff") {
                    expect(event.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: true))
                        == false
                    expect(event.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: false))
                        == false
                }
            }
        }
        
        describe("noteOffOrNil and isNoteOff") {
            var event: SMFMIDIEvent!
            context("event is NoteOn") {
                context("velocity 0") {
                    beforeEach {
                        event = .noteOn(channel: 1, note: 2, velocity: 0)
                    }
                    context("treatZeroVelocityNoteOnAsNoteOff false") {
                        it("returns nil as noteOffOrNil") {
                            expect(event.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: false))
                                .to(beNil())
                        }
                        it("returns false as isNoteOff") {
                            expect(event.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: false))
                                == false
                        }
                    }
                    context("treatZeroVelocityNoteOnAsNoteOff true") {
                        it("returns NoteOff as noteOffOrNil and its velocity is zero") {
                            expect(event.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true))
                                == NoteOff(channel: 1, note: 2, velocity: 0)
                        }
                        it("returns true as isNoteOff") {
                            expect(event.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: true))
                                == true
                        }
                    }
                }
                context("velocity is larger than 0") {
                    let on = NoteOn(channel: 1, note: 2, velocity: 3)
                    beforeEach {
                        event = .noteOn(on)
                    }
                    it("returns nil as noteOffOrNil regardless of treatZeroVelocityNoteOnAsNoteOff") {
                        expect(event.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true))
                            .to(beNil())
                        expect(event.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: false))
                            .to(beNil())
                    }
                    it("returns false as isNoteOff regardless of treatZeroVelocityNoteOnAsNoteOff") {
                        expect(event.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: true))
                            == false
                        expect(event.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: false))
                            == false
                    }
                }
            }
            context("event is NoteOff") {
                let off = NoteOff(channel: 1, note: 2, velocity: 3)
                beforeEach {
                    event = .noteOff(off)
                }
                it("returns NoteOff as noteOffOrNil regardless of treatZeroVelocityNoteOnAsNoteOff") {
                    expect(event.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true))
                        == off
                    
                    expect(event.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: false))
                        == off
                }
                it("returns true as isNoteOff regardless of treatZeroVelocityNoteOnAsNoteOff") {
                    expect(event.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: true))
                        == true
                    expect(event.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: false))
                        == true
                }
            }
            context("event is others") {
                beforeEach {
                    event = .controlChange(
                        ControlChange(channel: 1, controlNumber: .balance, value: 3)
                    )
                }
                it("returns nil as noteOffOrNil regardless of treatZeroVelocityNoteOnAsNoteOff") {
                    expect(event.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true))
                        .to(beNil())
                    expect(event.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: false))
                        .to(beNil())
                }
                it("returns false as isNoteOff regardless of treatZeroVelocityNoteOnAsNoteOff") {
                    expect(event.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: true))
                        == false
                    expect(event.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: false))
                        == false
                }
            }
        }
        
        describe("belongingChannel and belongsTo") {
            var event: SMFMIDIEvent!
            context("event is NoteOn") {
                beforeEach { event = .noteOn(channel: 1, note: 2, velocity: 3) }
                it("returns channel as belongingChannel") {
                    expect(event.belongingChannel) == 1
                }
                it("returns true as belongsTo if passed channel and event's channel are equal") {
                    expect(event.belongsTo(channel: 1)) == true
                    expect(event.belongsTo(channel: 2)) == false
                }
            }
            context("event is NoteOff") {
                beforeEach { event = .noteOff(channel: 1, note: 2, velocity: 3) }
                it("returns channel as belongingChannel") {
                    expect(event.belongingChannel) == 1
                }
                it("returns true as belongsTo if passed channel and event's channel are equal") {
                    expect(event.belongsTo(channel: 1)) == true
                    expect(event.belongsTo(channel: 2)) == false
                }
            }
            context("event is PolyphonicKeyPressure") {
                beforeEach {
                    event = .polyphonicKeyPressure(
                        PolyphonicKeyPressure(channel: 1, note: 2, pressure: 3)
                    )
                }
                it("returns channel as belongingChannel") {
                    expect(event.belongingChannel) == 1
                }
                it("returns true as belongsTo if passed channel and event's channel are equal") {
                    expect(event.belongsTo(channel: 1)) == true
                    expect(event.belongsTo(channel: 2)) == false
                }
            }
            context("event is ControlChange") {
                beforeEach {
                    event = .controlChange(
                        ControlChange(channel: 1, controlNumber: .allNotesOff, value: 2)
                    )
                }
                it("returns channel as belongingChannel") {
                    expect(event.belongingChannel) == 1
                }
                it("returns true as belongsTo if passed channel and event's channel are equal") {
                    expect(event.belongsTo(channel: 1)) == true
                    expect(event.belongsTo(channel: 2)) == false
                }
            }
            context("event is ProgramChange") {
                beforeEach {
                    event = .programChange(
                        ProgramChange(channel: 1, program: 10)
                    )
                }
                it("returns channel as belongingChannel") {
                    expect(event.belongingChannel) == 1
                }
                it("returns true as belongsTo if passed channel and event's channel are equal") {
                    expect(event.belongsTo(channel: 1)) == true
                    expect(event.belongsTo(channel: 2)) == false
                }
            }
            context("event is ChannelPressure") {
                beforeEach {
                    event = .channelPressure(
                        ChannelPressure(channel: 1, pressure: 10)
                    )
                }
                it("returns channel as belongingChannel") {
                    expect(event.belongingChannel) == 1
                }
                it("returns true as belongsTo if passed channel and event's channel are equal") {
                    expect(event.belongsTo(channel: 1)) == true
                    expect(event.belongsTo(channel: 2)) == false
                }
            }
            context("event is PitchBendChange") {
                beforeEach {
                    event = .pitchBendChange(
                        PitchBendChange(channel: 1, lsb: 2, msb: 3)
                    )
                }
                it("returns channel as belongingChannel") {
                    expect(event.belongingChannel) == 1
                }
                it("returns true as belongsTo if passed channel and event's channel are equal") {
                    expect(event.belongsTo(channel: 1)) == true
                    expect(event.belongsTo(channel: 2)) == false
                }
            }
            context("event is others") {
                beforeEach {
                    event = .start()
                }
                it("returns nil as belongingChannel") {
                    expect(event.belongingChannel).to(beNil())
                }
                it("returns false as belongsTo regardless of passed channel value") {
                    expect(event.belongsTo(channel: 1)) == false
                    expect(event.belongsTo(channel: 2)) == false
                }
            }
        }
        
        describe("convenience methods") {
            it("noteOff") {
                let a: SMFMIDIEvent = .noteOff(NoteOff(channel: 1, note: 2, velocity: 3))
                let b: SMFMIDIEvent = .noteOff(channel: 1, note: 2, velocity: 3)
                expect(a) == b
            }
            it("noteOn") {
                let a: SMFMIDIEvent = .noteOn(NoteOn(channel: 1, note: 2, velocity: 3))
                let b: SMFMIDIEvent = .noteOn(channel: 1, note: 2, velocity: 3)
                expect(a) == b
            }
            it("polyphonicKeyPressure") {
                let a: SMFMIDIEvent = .polyphonicKeyPressure(
                    PolyphonicKeyPressure(channel: 1, note: 2, pressure: 3)
                )
                let b: SMFMIDIEvent = .polyphonicKeyPressure(channel: 1, note: 2, pressure: 3)
                expect(a) == b
            }
            it("controlChange") {
                let a: SMFMIDIEvent = .controlChange(
                    ControlChange(channel: 1, controlNumber: .balanceLSB, value: 2)
                )
                let b: SMFMIDIEvent =
                    .controlChange(channel: 1, controlNumber: .balanceLSB, value: 2)
                expect(a) == b
            }
            it("programChange") {
                let a: SMFMIDIEvent = .programChange(ProgramChange(channel: 1, program: 2))
                let b: SMFMIDIEvent = .programChange(channel: 1, program: 2)
                expect(a) == b
            }
            it("channelPressure") {
                let a: SMFMIDIEvent = .channelPressure(
                    ChannelPressure(channel: 1, pressure: 2)
                )
                let b: SMFMIDIEvent = .channelPressure(channel: 1, pressure: 2)
                expect(a) == b
            }
            it("pitchBendChange") {
                let a: SMFMIDIEvent = .pitchBendChange(
                    PitchBendChange(channel: 1, lsb: 2, msb: 3)
                )
                let b: SMFMIDIEvent = .pitchBendChange(channel: 1, lsb: 2, msb: 3)
                expect(a) == b
            }
            it("timeCodeQuarterFrame") {
                let a: SMFMIDIEvent = .timeCodeQuarterFrame(
                    TimeCodeQuarterFrame(messageType: .frameCountLower4bit, value: 1)
                )
                let b: SMFMIDIEvent =
                    .timeCodeQuarterFrame(type: .frameCountLower4bit, value: 1)
                expect(a) == b
            }
            it("songPositionPointer") {
                let a: SMFMIDIEvent = .songPositionPointer(
                    SongPositionPointer(lsb: 1, msb: 2)
                )
                let b: SMFMIDIEvent = .songPositionPointer(lsb: 1, msb: 2)
                expect(a) == b
            }
            it("songSelect") {
                let a: SMFMIDIEvent = .songSelect(SongSelect(songNumber: 1))
                let b: SMFMIDIEvent = .songSelect(1)
                expect(a) == b
            }
            it("undefinedSystemCommonMessage1") {
                let a: SMFMIDIEvent = .undefinedSystemCommonMessage1(
                    UndefinedSystemCommonMessage1()
                )
                let b: SMFMIDIEvent = .undefinedSystemCommonMessage1()
                expect(a) == b
            }
            it("undefinedSystemCommonMessage2") {
                let a: SMFMIDIEvent = .undefinedSystemCommonMessage2(
                    UndefinedSystemCommonMessage2()
                )
                let b: SMFMIDIEvent = .undefinedSystemCommonMessage2()
                expect(a) == b
            }
            it("tuneRequest") {
                let a: SMFMIDIEvent = .tuneRequest(TuneRequest())
                let b: SMFMIDIEvent = .tuneRequest()
                expect(a) == b
            }
            it("timingClock") {
                let a: SMFMIDIEvent = .timingClock(TimingClock())
                let b: SMFMIDIEvent = .timingClock()
                expect(a) == b
            }
            it("undefinedSystemRealTimeMessage1") {
                let a: SMFMIDIEvent = .undefinedSystemRealTimeMessage1(
                    UndefinedSystemRealTimeMessage1()
                )
                let b: SMFMIDIEvent = .undefinedSystemRealTimeMessage1()
                expect(a) == b
            }
            it("undefinedSystemRealTimeMessage2") {
                let a: SMFMIDIEvent = .undefinedSystemRealTimeMessage2(
                    UndefinedSystemRealTimeMessage2()
                )
                let b: SMFMIDIEvent = .undefinedSystemRealTimeMessage2()
                expect(a) == b
            }
            it("start") {
                let a: SMFMIDIEvent = .start(Start())
                let b: SMFMIDIEvent = .start()
                expect(a) == b
            }
            it("continue") {
                let a: SMFMIDIEvent = .continue(Continue())
                let b: SMFMIDIEvent = .continue()
                expect(a) == b
            }
            it("stop") {
                let a: SMFMIDIEvent = .stop(Stop())
                let b: SMFMIDIEvent = .stop()
                expect(a) == b
            }
            it("activeSensing") {
                let a: SMFMIDIEvent = .activeSensing(ActiveSensing())
                let b: SMFMIDIEvent = .activeSensing()
                expect(a) == b
            }
            it("timingClock") {
                let a: SMFMIDIEvent = .systemReset(SystemReset())
                let b: SMFMIDIEvent = .systemReset()
                expect(a) == b
            }
        }
    }
}
