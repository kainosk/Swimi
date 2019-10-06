//
//  NotifierSpec.swift
//  SwimiTests
//
//  Created by kai on 2019/10/06.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class NotifierSpec: QuickSpec {
    override func spec() {
        var subject: Notifier!
        
        // Notified events will be stored below arrays.
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
        var undefinedSystemCommonMessage1s: [UndefinedSystemCommonMessage1]!
        var undefinedSystemCommonMessage2s: [UndefinedSystemCommonMessage2]!
        var tuneRequests: [TuneRequest]!
        var timingClocks: [TimingClock]!
        var undefinedSystemRealTimeMessage1s: [UndefinedSystemRealTimeMessage1]!
        var undefinedSystemRealTimeMessage2s: [UndefinedSystemRealTimeMessage2]!
        var starts: [Start]!
        var continues: [Continue]!
        var stops: [Stop]!
        var activeSensings: [ActiveSensing]!
        var systemResets: [SystemReset]!
        var systemExclusives: [SystemExclusive]!
        
        beforeEach {
            subject = Notifier()
            
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
            undefinedSystemCommonMessage1s = []
            undefinedSystemCommonMessage2s = []
            tuneRequests = []
            timingClocks = []
            undefinedSystemRealTimeMessage1s = []
            undefinedSystemRealTimeMessage2s = []
            starts = []
            continues = []
            stops = []
            activeSensings = []
            systemResets = []
            systemExclusives = []
            
            subject.noteOff = { noteOffs.append($0) }
            subject.noteOn = { noteOns.append($0) }
            subject.polyphonicKeyPressure = { polyphonicKeyPressures.append($0) }
            subject.controlChange = { controlChanges.append($0) }
            subject.programChange = { programChanges.append($0) }
            subject.channelPressure = { channelPressures.append($0) }
            subject.pitchBendChange = { pitchBendChanges.append($0) }
            subject.timeCodeQuarterFrame = { timeCodeQuarterFrames.append($0) }
            subject.songPositionPointer = { songPositionPointers.append($0) }
            subject.songSelect = { songSelects.append($0) }
            subject.undefinedSystemCommonMessage1 = { undefinedSystemCommonMessage1s.append($0) }
            subject.undefinedSystemCommonMessage2 = { undefinedSystemCommonMessage2s.append($0) }
            subject.tuneRequest = { tuneRequests.append($0) }
            subject.timingClock = { timingClocks.append($0) }
            subject.undefinedSystemRealTimeMessage1 = { undefinedSystemRealTimeMessage1s.append($0) }
            subject.undefinedSystemRealTimeMessage2 = { undefinedSystemRealTimeMessage2s.append($0) }
            subject.start = { starts.append($0) }
            subject.continue = { continues.append($0) }
            subject.stop = { stops.append($0) }
            subject.activeSensing = { activeSensings.append($0) }
            subject.systemReset = { systemResets.append($0) }
            subject.systemExclusive = { systemExclusives.append($0) }
        }
        
        describe("notify") {
            context("when pass noteOff message data") {
                it("notifies noteOff closure") {
                    subject.notify(messageData: [0x8F, 127, 127])
                    expect(noteOffs).to(equal([
                        NoteOff(channel: 15, note: 127, velocity: 127)
                    ]))
                }
            }
            context("when pass noteOn message data") {
                it("notifies noteOn closure") {
                    subject.notify(messageData: [0x9F, 127, 127])
                    expect(noteOns).to(equal([
                        NoteOn(channel: 15, note: 127, velocity: 127)
                    ]))
                }
            }
            context("when pass polyphonicKeyPressure message data") {
                it("notifies polyphonicKeyPressure closure") {
                    subject.notify(messageData: [0xAF, 127, 127])
                    expect(polyphonicKeyPressures).to(equal([
                        PolyphonicKeyPressure(channel: 15, note: 127, pressure: 127)
                    ]))
                }
            }
            context("when pass controlChange message data") {
                it("notifies controlChange closure") {
                    subject.notify(messageData: [0xBF, 0, 127])
                    expect(controlChanges).to(equal([
                        ControlChange(channel: 15, controlNumber: .bankSelectMSB, value: 127)
                    ]))
                }
            }
            context("when pass programChange message data") {
                it("notifies programChange closure") {
                    subject.notify(messageData: [0xCF, 127])
                    expect(programChanges).to(equal([
                        ProgramChange(channel: 15, program: 127)
                    ]))
                }
            }
            context("when pass channelPressure message data") {
                it("notifies channelPressure closure") {
                    subject.notify(messageData: [0xDF, 127])
                    expect(channelPressures).to(equal([
                        ChannelPressure(channel: 15, pressure: 127)
                    ]))
                }
            }
            context("when pass pitchBendChange message data") {
                it("notifies pitchBendChange closure") {
                    subject.notify(messageData: [0xEF, 127, 127])
                    expect(pitchBendChanges).to(equal([
                        PitchBendChange(channel: 15, lsb: 127, msb: 127)
                    ]))
                }
            }
            context("when pass timeCodeQuarterFrame message data") {
                it("notifies timeCodeQuarterFrame closure") {
                    subject.notify(messageData: [0xF1, 127])
                    expect(timeCodeQuarterFrames).to(equal([
                        TimeCodeQuarterFrame(messageType: .timeCountUpper4bit, value: 0xF)
                    ]))
                }
            }
            context("when pass songPositionPointer message data") {
                it("notifies songPositionPointer closure") {
                    subject.notify(messageData: [0xF2, 127, 127])
                    expect(songPositionPointers).to(equal([
                        SongPositionPointer(lsb: 127, msb: 127)
                    ]))
                }
            }
            context("when pass songSelect message data") {
                it("notifies songSelect closure") {
                    subject.notify(messageData: [0xF3, 127])
                    expect(songSelects).to(equal([
                        SongSelect(songNumber: 127)
                    ]))
                }
            }
            context("when pass undefinedSystemCommonMessage1 message data") {
                it("notifies undefinedSystemCommonMessage1 closure") {
                    subject.notify(messageData: [0xF4])
                    expect(undefinedSystemCommonMessage1s).to(equal([
                        UndefinedSystemCommonMessage1()
                    ]))
                }
            }
            context("when pass undefinedSystemCommonMessage2 message data") {
                it("notifies undefinedSystemCommonMessage2 closure") {
                    subject.notify(messageData: [0xF5])
                    expect(undefinedSystemCommonMessage2s).to(equal([
                        UndefinedSystemCommonMessage2()
                    ]))
                }
            }
            context("when pass tuneRequest message data") {
                it("notifies tuneRequest closure") {
                    subject.notify(messageData: [0xF6])
                    expect(tuneRequests).to(equal([
                        TuneRequest()
                    ]))
                }
            }
            context("when pass endOfExclusive message data") {
                it("fatalError because we should look sytemExclusive closure") {
                    expect {
                        subject.notify(messageData: [0xF7])
                    }.to(throwAssertion())
                }
            }
            context("when pass timingClock message data") {
                it("notifies timingClock closure") {
                    subject.notify(messageData: [0xF8])
                    expect(timingClocks).to(equal([
                        TimingClock()
                    ]))
                }
            }
            context("when pass undefinedSystemRealTimeMessage1 message data") {
                it("notifies undefinedSystemRealTimeMessage1 closure") {
                    subject.notify(messageData: [0xF9])
                    expect(undefinedSystemRealTimeMessage1s).to(equal([
                        UndefinedSystemRealTimeMessage1()
                    ]))
                }
            }
            context("when pass undefinedSystemRealTimeMessage2 message data") {
                it("notifies undefinedSystemRealTimeMessage2 closure") {
                    subject.notify(messageData: [0xFD])
                    expect(undefinedSystemRealTimeMessage2s).to(equal([
                        UndefinedSystemRealTimeMessage2()
                    ]))
                }
            }
            context("when pass start message data") {
                it("notifies start closure") {
                    subject.notify(messageData: [0xFA])
                    expect(starts).to(equal([
                        Start()
                    ]))
                }
            }
            context("when pass continue message data") {
                it("notifies continue closure") {
                    subject.notify(messageData: [0xFB])
                    expect(continues).to(equal([
                        Continue()
                    ]))
                }
            }
            context("when pass stop message data") {
                it("notifies stop closure") {
                    subject.notify(messageData: [0xFC])
                    expect(stops).to(equal([
                        Stop()
                    ]))
                }
            }
            context("when pass activeSensing message data") {
                it("notifies stop closure") {
                    subject.notify(messageData: [0xFE])
                    expect(activeSensings).to(equal([
                        ActiveSensing()
                    ]))
                }
            }
            context("when pass systemReset message data") {
                it("notifies systemReset closure") {
                    subject.notify(messageData: [0xFF])
                    expect(systemResets).to(equal([
                        SystemReset()
                    ]))
                }
            }
            context("when pass systemExclusive message data") {
                it("notifies systemExclusive closure") {
                    let data: [UInt8] = [
                        0xF0,
                        0x7F, 0x7E, 0x7D, 0x7C, 0x7B, 0x7A, 0x79, 0x78, 0x77, 0x76, 0x75,
                        0xF7
                    ]
                    subject.notify(messageData: data)
                    expect(systemExclusives).to(equal([
                        SystemExclusive(rawData: data)
                    ]))
                }
            }
            context("when pass empty data") {
                it("throw assertion") {
                    expect {
                        subject.notify(messageData: [])
                    }.to(throwAssertion())
                }
            }
            context("when pass invalid data (failed to create StatusType from first element)") {
                it("throw assertion") {
                    expect {
                        subject.notify(messageData: [0x00, 0x00, 0x00])
                    }.to(throwAssertion())
                }
            }
        }
    }
}
