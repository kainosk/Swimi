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
            fatalError()
        case .channelPressure:
            fatalError()
        case .pitchBendChange:
            fatalError()
        case .timecodeQuarterFrame:
            fatalError()
        case .songPositionPointer:
            fatalError()
        case .songSelect:
            fatalError()
        case .undefinedSystemCommonMessage1:
            fatalError()
        case .undefinedSystemCommonMessage2:
            fatalError()
        case .tuneRequest:
            fatalError()
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
