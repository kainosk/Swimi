//
//  MIDIEvent.swift
//  Swimi
//
//  Created by kai on 2020/09/30.
//

import Foundation

public enum MIDIEvent: Equatable {
    case noteOff(NoteOff)
    case noteOn(NoteOn)
    case polyphonicKeyPressure(PolyphonicKeyPressure)
    case controlChange(ControlChange)
    case programChange(ProgramChange)
    case channelPressure(ChannelPressure)
    case pitchBendChange(PitchBendChange)
    case timeCodeQuarterFrame(TimeCodeQuarterFrame)
    case songPositionPointer(SongPositionPointer)
    case songSelect(SongSelect)
    case undefinedSystemCommonMessage1(UndefinedSystemCommonMessage1)
    case undefinedSystemCommonMessage2(UndefinedSystemCommonMessage2)
    case tuneRequest(TuneRequest)
    case timingClock(TimingClock)
    case undefinedSystemRealTimeMessage1(UndefinedSystemRealTimeMessage1)
    case undefinedSystemRealTimeMessage2(UndefinedSystemRealTimeMessage2)
    case start(Start)
    case `continue`(Continue)
    case stop(Stop)
    case activeSensing(ActiveSensing)
    case systemReset(SystemReset)
    case systemExclusive(SystemExclusive)
}

//MARK: - Extensions for convenience
public extension MIDIEvent {
    static func noteOn(channel: Int, note: Int, velocity: Int) -> MIDIEvent {
        return .noteOn(NoteOn(channel: channel, note: note, velocity: velocity))
    }
    
    static func noteOff(channel: Int, note: Int, velocity: Int) -> MIDIEvent {
        return .noteOff(NoteOff(channel: channel, note: note, velocity: velocity))
    }
    
    static func polyphonicKeyPressure(
        channel: Int,
        note: Int,
        pressure: Int
    ) -> MIDIEvent {
        return .polyphonicKeyPressure(
            PolyphonicKeyPressure(channel: channel, note: note, pressure: pressure)
        )
    }
    
    static func controlChange(
        channel: Int,
        controlNumber: ControlNumber,
        value: Int
    ) -> MIDIEvent {
        return .controlChange(
            ControlChange(channel: channel, controlNumber: controlNumber, value: value)
        )
    }
    
    static func programChange(channel: Int, program: Int) -> MIDIEvent {
        return .programChange(ProgramChange(channel: channel, program: program))
    }
    
    static func channelPressure(channel: Int, pressure: Int) -> MIDIEvent {
        return .channelPressure(ChannelPressure(channel: channel, pressure: pressure))
    }
    
    static func pitchBendChange(channel: Int, lsb: UInt8, msb: UInt8) -> MIDIEvent {
        return .pitchBendChange(PitchBendChange(channel: channel, lsb: lsb, msb: msb))
    }
    
    static func timeCodeQuarterFrame(
        type: TimeCodeQuarterFrameMessageType,
        value: UInt8
    ) -> MIDIEvent {
        return .timeCodeQuarterFrame(
            TimeCodeQuarterFrame(messageType: type, value: value)
        )
    }
    
    static func songPositionPointer(lsb: UInt8, msb: UInt8) -> MIDIEvent {
        return .songPositionPointer(SongPositionPointer(lsb: lsb, msb: msb))
    }
    
    static func songSelect(_ songNumber: UInt8) -> MIDIEvent {
        return .songSelect(SongSelect(songNumber: songNumber))
    }
    
    static func undefinedSystemCommonMessage1() -> MIDIEvent {
        return .undefinedSystemCommonMessage1(UndefinedSystemCommonMessage1())
    }
    
    static func undefinedSystemCommonMessage2() -> MIDIEvent {
        return .undefinedSystemCommonMessage2(UndefinedSystemCommonMessage2())
    }
    
    static func tuneRequest() -> MIDIEvent {
        return .tuneRequest(TuneRequest())
    }
    
    static func timingClock() -> MIDIEvent {
        return .timingClock(TimingClock())
    }
    
    static func undefinedSystemRealTimeMessage1() -> MIDIEvent {
        return .undefinedSystemRealTimeMessage1(UndefinedSystemRealTimeMessage1())
    }
    
    static func undefinedSystemRealTimeMessage2() -> MIDIEvent {
        return .undefinedSystemRealTimeMessage2(UndefinedSystemRealTimeMessage2())
    }
    
    static func start() -> MIDIEvent {
        return .start(Start())
    }
    
    static func `continue`() -> MIDIEvent {
        return .continue(Continue())
    }
    
    static func stop() -> MIDIEvent {
        return .stop(Stop())
    }
    
    static func activeSensing() -> MIDIEvent {
        return .activeSensing(ActiveSensing())
    }
    
    static func systemReset() -> MIDIEvent {
        return .systemReset(SystemReset())
    }
    
    static func sysEx(_ rawData: [UInt8]) -> MIDIEvent {
        return .systemExclusive(SystemExclusive(rawData: rawData))
    }
}
