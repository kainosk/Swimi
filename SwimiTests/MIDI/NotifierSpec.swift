//
//  NotifierSpec.swift
//  SwimiTests
//
//  Created by Kainosuke OBATA on 2019/10/06.
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
        var parsedMIDIEvents: [MIDIEvent]!
        
        beforeEach {
            subject = Notifier()
            parsedMIDIEvents = []
            subject.eventParsed = { parsedMIDIEvents.append($0) }
        }
        
        describe("notify") {
            context("when pass noteOff message data") {
                it("notifies noteOff closure") {
                    subject.notify(messageData: [0x8F, 127, 127])
                    expect(parsedMIDIEvents).to(equal([
                        .noteOff(NoteOff(channel: 15, note: 127, velocity: 127))
                    ]))
                }
            }
            context("when pass noteOn message data") {
                it("notifies noteOn closure") {
                    subject.notify(messageData: [0x9F, 127, 127])
                    expect(parsedMIDIEvents).to(equal([
                        .noteOn(NoteOn(channel: 15, note: 127, velocity: 127))
                    ]))
                }
            }
            context("when pass polyphonicKeyPressure message data") {
                it("notifies polyphonicKeyPressure closure") {
                    subject.notify(messageData: [0xAF, 127, 127])
                    expect(parsedMIDIEvents).to(equal([
                        .polyphonicKeyPressure(PolyphonicKeyPressure(channel: 15, note: 127, pressure: 127))
                    ]))
                }
            }
            context("when pass controlChange message data") {
                it("notifies controlChange closure") {
                    subject.notify(messageData: [0xBF, 0, 127])
                    expect(parsedMIDIEvents).to(equal([
                        .controlChange(ControlChange(channel: 15, controlNumber: .bankSelectMSB, value: 127))
                    ]))
                }
            }
            context("when pass programChange message data") {
                it("notifies programChange closure") {
                    subject.notify(messageData: [0xCF, 127])
                    expect(parsedMIDIEvents).to(equal([
                        .programChange(ProgramChange(channel: 15, program: 127))
                    ]))
                }
            }
            context("when pass channelPressure message data") {
                it("notifies channelPressure closure") {
                    subject.notify(messageData: [0xDF, 127])
                    expect(parsedMIDIEvents).to(equal([
                        .channelPressure(ChannelPressure(channel: 15, pressure: 127))
                    ]))
                }
            }
            context("when pass pitchBendChange message data") {
                it("notifies pitchBendChange closure") {
                    subject.notify(messageData: [0xEF, 127, 127])
                    expect(parsedMIDIEvents).to(equal([
                        .pitchBendChange(PitchBendChange(channel: 15, lsb: 127, msb: 127))
                    ]))
                }
            }
            context("when pass timeCodeQuarterFrame message data") {
                it("notifies timeCodeQuarterFrame closure") {
                    subject.notify(messageData: [0xF1, 127])
                    expect(parsedMIDIEvents).to(equal([
                        .timeCodeQuarterFrame(TimeCodeQuarterFrame(messageType: .timeCountUpper4bit, value: 0xF))
                    ]))
                }
            }
            context("when pass songPositionPointer message data") {
                it("notifies songPositionPointer closure") {
                    subject.notify(messageData: [0xF2, 127, 127])
                    expect(parsedMIDIEvents).to(equal([
                        .songPositionPointer(SongPositionPointer(lsb: 127, msb: 127))
                    ]))
                }
            }
            context("when pass songSelect message data") {
                it("notifies songSelect closure") {
                    subject.notify(messageData: [0xF3, 127])
                    expect(parsedMIDIEvents).to(equal([
                        .songSelect(SongSelect(songNumber: 127))
                    ]))
                }
            }
            context("when pass undefinedSystemCommonMessage1 message data") {
                it("notifies undefinedSystemCommonMessage1 closure") {
                    subject.notify(messageData: [0xF4])
                    expect(parsedMIDIEvents).to(equal([
                        .undefinedSystemCommonMessage1(UndefinedSystemCommonMessage1())
                    ]))
                }
            }
            context("when pass undefinedSystemCommonMessage2 message data") {
                it("notifies undefinedSystemCommonMessage2 closure") {
                    subject.notify(messageData: [0xF5])
                    expect(parsedMIDIEvents).to(equal([
                        .undefinedSystemCommonMessage2(UndefinedSystemCommonMessage2())
                    ]))
                }
            }
            context("when pass tuneRequest message data") {
                it("notifies tuneRequest closure") {
                    subject.notify(messageData: [0xF6])
                    expect(parsedMIDIEvents).to(equal([
                        .tuneRequest(TuneRequest())
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
                    expect(parsedMIDIEvents).to(equal([
                        .timingClock(TimingClock())
                    ]))
                }
            }
            context("when pass undefinedSystemRealTimeMessage1 message data") {
                it("notifies undefinedSystemRealTimeMessage1 closure") {
                    subject.notify(messageData: [0xF9])
                    expect(parsedMIDIEvents).to(equal([
                        .undefinedSystemRealTimeMessage1(UndefinedSystemRealTimeMessage1())
                    ]))
                }
            }
            context("when pass undefinedSystemRealTimeMessage2 message data") {
                it("notifies undefinedSystemRealTimeMessage2 closure") {
                    subject.notify(messageData: [0xFD])
                    expect(parsedMIDIEvents).to(equal([
                        .undefinedSystemRealTimeMessage2(UndefinedSystemRealTimeMessage2())
                    ]))
                }
            }
            context("when pass start message data") {
                it("notifies start closure") {
                    subject.notify(messageData: [0xFA])
                    expect(parsedMIDIEvents).to(equal([
                        .start(Start())
                    ]))
                }
            }
            context("when pass continue message data") {
                it("notifies continue closure") {
                    subject.notify(messageData: [0xFB])
                    expect(parsedMIDIEvents).to(equal([
                        .continue(Continue())
                    ]))
                }
            }
            context("when pass stop message data") {
                it("notifies stop closure") {
                    subject.notify(messageData: [0xFC])
                    expect(parsedMIDIEvents).to(equal([
                        .stop(Stop())
                    ]))
                }
            }
            context("when pass activeSensing message data") {
                it("notifies stop closure") {
                    subject.notify(messageData: [0xFE])
                    expect(parsedMIDIEvents).to(equal([
                        .activeSensing(ActiveSensing())
                    ]))
                }
            }
            context("when pass systemReset message data") {
                it("notifies systemReset closure") {
                    subject.notify(messageData: [0xFF])
                    expect(parsedMIDIEvents).to(equal([
                        .systemReset(SystemReset())
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
                    expect(parsedMIDIEvents).to(equal([
                        .systemExclusive(SystemExclusive(rawData: data))
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
