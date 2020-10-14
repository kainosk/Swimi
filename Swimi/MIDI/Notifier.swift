//
//  Notifier.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public class Notifier {
    public var eventParsed: ((MIDIEvent) -> Void)?

    func notify(messageData: [UInt8]) {
        guard !messageData.isEmpty else {
            fatalError("messageData is empty")
        }
        guard let status = StatusType.fromByte(messageData[0]) else {
            fatalError("Invalid message data.")
        }
        
        switch status {
            
        case .noteOn:
            eventParsed?(.noteOn(NoteOn.fromData(messageData)))
        case .noteOff:
            eventParsed?(.noteOff(NoteOff.fromData(messageData)))
        case .polyphonicKeyPressure:
            eventParsed?(.polyphonicKeyPressure(PolyphonicKeyPressure.fromData(messageData)))
        case .controlChange:
            eventParsed?(.controlChange(ControlChange.fromData(messageData)))
        case .programChange:
            eventParsed?(.programChange(ProgramChange.fromData(messageData)))
        case .channelPressure:
            eventParsed?(.channelPressure(ChannelPressure.fromData(messageData)))
        case .pitchBendChange:
            eventParsed?(.pitchBendChange(PitchBendChange.fromData(messageData)))
        case .timecodeQuarterFrame:
            eventParsed?(.timeCodeQuarterFrame(TimeCodeQuarterFrame.fromData(messageData)))
        case .songPositionPointer:
            eventParsed?(.songPositionPointer(SongPositionPointer.fromData(messageData)))
        case .songSelect:
            eventParsed?(.songSelect(SongSelect.fromData(messageData)))
        case .undefinedSystemCommonMessage1:
            eventParsed?(.undefinedSystemCommonMessage1(UndefinedSystemCommonMessage1.fromData(messageData)))
        case .undefinedSystemCommonMessage2:
            eventParsed?(.undefinedSystemCommonMessage2(UndefinedSystemCommonMessage2.fromData(messageData)))
        case .tuneRequest:
            eventParsed?(.tuneRequest(TuneRequest.fromData(messageData)))
        case .timingClock:
            eventParsed?(.timingClock(TimingClock.fromData(messageData)))
        case .undefinedSystemRealTimeMessage1:
            eventParsed?(.undefinedSystemRealTimeMessage1(UndefinedSystemRealTimeMessage1.fromData(messageData)))
        case .start:
            eventParsed?(.start(Start.fromData(messageData)))
        case .continue:
            eventParsed?(.continue(Continue.fromData(messageData)))
        case .stop:
            eventParsed?(.stop(Stop.fromData(messageData)))
        case .undefinedSystemRealTimeMessage2:
            eventParsed?(.undefinedSystemRealTimeMessage2(UndefinedSystemRealTimeMessage2.fromData(messageData)))
        case .activeSensing:
            eventParsed?(.activeSensing(ActiveSensing.fromData(messageData)))
        case .systemReset:
            eventParsed?(.systemReset(SystemReset.fromData(messageData)))
        case .systemExclusive:
            eventParsed?(.systemExclusive(SystemExclusive.fromData(messageData)))
        case .endOfExclusive:
            fatalError()
        }
    }
}
