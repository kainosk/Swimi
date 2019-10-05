//
//  Notifier.swift
//  SwiftyMIDIParser
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public class Notifier {
    public var noteOff: ((NoteOff) -> Void)?
    public var noteOn: ((NoteOn) -> Void)?
    public var polyphonicKeyPressure: ((PolyphonicKeyPressure) -> Void)?
    public var controlChange: ((ControlChange) -> Void)?
    public var programChange: ((ProgramChange) -> Void)?
    public var channelPressure: ((ChannelPressure) -> Void)?
    public var pitchBendChange: ((PitchBendChange) -> Void)?
    public var timeCodeQuarterFrame: ((TimeCodeQuarterFrame) -> Void)?
    public var songPositionPointer: ((SongPositionPointer) -> Void)?
    public var songSelect: ((SongSelect) -> Void)?
    public var undefinedSystemCommonMessage1: ((UndefinedSystemCommonMessage1) -> Void)?
    public var undefinedSystemCommonMessage2: ((UndefinedSystemCommonMessage2) -> Void)?
    public var tuneRequest: ((TuneRequest) -> Void)?
    public var systemExclusive: ((SystemExclusive) -> Void)?

    func notify(messageData: [UInt8]) {
        guard let status = StatusType.fromByte(messageData[0]) else {
            fatalError("Invalid message data.")
        }
        switch status {
            
        case .noteOn:
            noteOn?(NoteOn.fromData(messageData))
        case .noteOff:
            noteOff?(NoteOff.fromData(messageData))
        case .polyphonicKeyPressure:
            polyphonicKeyPressure?(PolyphonicKeyPressure.fromData(messageData))
        case .controlChange:
            controlChange?(ControlChange.fromData(messageData))
        case .programChange:
            programChange?(ProgramChange.fromData(messageData))
        case .channelPressure:
            channelPressure?(ChannelPressure.fromData(messageData))
        case .pitchBendChange:
            pitchBendChange?(PitchBendChange.fromData(messageData))
        case .timecodeQuarterFrame:
            timeCodeQuarterFrame?(TimeCodeQuarterFrame.fromData(messageData))
        case .songPositionPointer:
            songPositionPointer?(SongPositionPointer.fromData(messageData))
        case .songSelect:
            songSelect?(SongSelect.fromData(messageData))
        case .undefinedSystemCommonMessage1:
            undefinedSystemCommonMessage1?(UndefinedSystemCommonMessage1.fromData(messageData))
        case .undefinedSystemCommonMessage2:
            undefinedSystemCommonMessage2?(UndefinedSystemCommonMessage2.fromData(messageData))
        case .tuneRequest:
            tuneRequest?(TuneRequest.fromData(messageData))
        case .timingClock:
            fatalError()
        case .undefinedSystemRealTimeMessage1:
            fatalError()
        case .start:
            fatalError()
        case .continue:
            fatalError()
        case .stop:
            fatalError()
        case .undefinedSystemRealTimeMessage2:
            fatalError()
        case .activeSensing:
            fatalError()
        case .systemReset:
            fatalError()
        case .systemExclusive:
            systemExclusive?(SystemExclusive.fromData(messageData))
        case .endOfExclusive:
            fatalError()
        }
    }
}
