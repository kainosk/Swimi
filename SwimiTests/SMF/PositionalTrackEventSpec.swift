//
//  PositionalTrackEventSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/17.
//
import Foundation
import Quick
import Nimble
@testable import Swimi

class PositionalTrackEventSpec: QuickSpec {
    override func spec() {
        describe("init") {
            it("can be initialized with position and event") {
                _ = PositionalTrackEvent(
                    event: TrackEvent<SS>.midi(.noteOn(channel: 1, note: 1, velocity: 1)),
                    position: 99
                )
            }
            it("can be initialized with position and event (at version)") {
                _ = PositionalTrackEvent<SS>.at(
                    99,
                    .midi(.activeSensing())
                )
            }
            it("has event and position as is") {
                let trackEvent = TrackEvent<SS>.midi(.noteOn(channel: 1, note: 1, velocity: 1))
                let position = 99
                let e = PositionalTrackEvent(
                    event: trackEvent,
                    position: position
                )
                expect(e.event) == trackEvent
                expect(e.position) == position
            }
        }
        describe("midiEventOrNil") {
            it("returns TrackEvent's midiEventOrNil as is") {
                let trackEvent: TrackEvent<SS> =
                    .midi(.noteOn(channel: 1, note: 2, velocity: 3))
                let e: PositionalTrackEvent<SS> = .at(99, trackEvent)
                expect(e.midiEventOrNil) == trackEvent.midiEventOrNil
            }
        }
        describe("noteOffOrNil") {
            it("returns TrackEvent's noteOffOrNil as is") {
                let trackEvent: TrackEvent<SS> =
                    .midi(.noteOff(channel: 1, note: 2, velocity: 3))
                let e: PositionalTrackEvent<SS> = .at(99, trackEvent)
                expect(e.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true)) ==
                trackEvent.noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: true)
            }
        }
        describe("noteOnOrNil") {
            it("returns TrackEvent's noteOnOrNil as is") {
                let trackEvent: TrackEvent<SS> =
                    .midi(.noteOn(channel: 1, note: 2, velocity: 3))
                let e: PositionalTrackEvent<SS> = .at(99, trackEvent)
                expect(e.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true)) ==
                    trackEvent.noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: true)
            }
        }
        describe("isNoteOn") {
            it("returns TrackEvent's isNoteOn as is") {
                let trackEvent: TrackEvent<SS> =
                    .midi(.noteOn(channel: 1, note: 2, velocity: 3))
                let e: PositionalTrackEvent<SS> = .at(99, trackEvent)
                expect(e.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: true)) ==
                    trackEvent.isNoteOn(treatZeroVelocityNoteOnAsNoteOff: true)
            }
        }
        describe("isNoteOff") {
            it("returns TrackEvent's isNoteOn as is") {
                let trackEvent: TrackEvent<SS> =
                    .midi(.noteOff(channel: 1, note: 2, velocity: 3))
                let e: PositionalTrackEvent<SS> = .at(99, trackEvent)
                expect(e.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: true)) ==
                    trackEvent.isNoteOff(treatZeroVelocityNoteOnAsNoteOff: true)
            }
        }
        describe("belongsTo") {
            it("returns TrackEvent's belongsTo as is") {
                let trackEvent: TrackEvent<SS> =
                    .midi(.noteOff(channel: 1, note: 2, velocity: 3))
                let e: PositionalTrackEvent<SS> = .at(99, trackEvent)
                expect(e.belongsTo(channel: 1)) == trackEvent.belongsTo(channel: 1)
            }
        }
        describe("belongingChannel") {
            it("returns TrackEvent's belongingChannel as is") {
                let trackEvent: TrackEvent<SS> =
                    .midi(.noteOff(channel: 1, note: 2, velocity: 3))
                let e: PositionalTrackEvent<SS> = .at(99, trackEvent)
                expect(e.belongingChannel) == trackEvent.belongingChannel
            }
        }
        describe("timeSignatureOrNil") {
            it("returns TrackEvent's timeSignatureOrNil as is") {
                let trackEvent: TrackEvent<SS> = .meta(.timeSignature(.standardFourFour))
                let e: PositionalTrackEvent<SS> = .at(99, trackEvent)
                expect(e.timeSignatureOrNil) == trackEvent.timeSignatureOrNil
            }
        }
    }
}
