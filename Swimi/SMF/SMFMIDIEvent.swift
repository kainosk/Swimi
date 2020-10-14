//
//  MIDIEvent.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

public enum SMFMIDIEvent: Equatable {
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
    //    case systemExclusive(SystemExclusive)
    
    public var smfBytes: [UInt8] {
        switch self {
        case .noteOff                        (let e): return e.bytes
        case .noteOn                         (let e): return e.bytes
        case .polyphonicKeyPressure          (let e): return e.bytes
        case .controlChange                  (let e): return e.bytes
        case .programChange                  (let e): return e.bytes
        case .channelPressure                (let e): return e.bytes
        case .pitchBendChange                (let e): return e.bytes
        case .timeCodeQuarterFrame           (let e): return e.bytes
        case .songPositionPointer            (let e): return e.bytes
        case .songSelect                     (let e): return e.bytes
        case .undefinedSystemCommonMessage1  (let e): return e.bytes
        case .undefinedSystemCommonMessage2  (let e): return e.bytes
        case .tuneRequest                    (let e): return e.bytes
        case .timingClock                    (let e): return e.bytes
        case .undefinedSystemRealTimeMessage1(let e): return e.bytes
        case .undefinedSystemRealTimeMessage2(let e): return e.bytes
        case .start                          (let e): return e.bytes
        case .continue                       (let e): return e.bytes
        case .stop                           (let e): return e.bytes
        case .activeSensing                  (let e): return e.bytes
        case .systemReset                    (let e): return e.bytes
        }
    }
    
    /// Convenience methods
    
    public func noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: Bool) -> NoteOn? {
        switch self {
        case .noteOn(let e):
            if treatZeroVelocityNoteOnAsNoteOff && e.velocity == 0 {
                return nil
            }
            return e
        default:
            return nil
        }
    }
    
    public func noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: Bool) -> NoteOff? {
        switch self {
        case .noteOn(let e):
            guard treatZeroVelocityNoteOnAsNoteOff && e.velocity == 0 else {
                return nil
            }
            return NoteOff(channel: e.channel, note: e.note, velocity: 0)
            
        case .noteOff(let e):
            return e
        default:
            return nil
        }
    }
    
    public func isNoteOn(treatZeroVelocityNoteOnAsNoteOff: Bool) -> Bool {
        return noteOnOrNil(
            treatZeroVelocityNoteOnAsNoteOff: treatZeroVelocityNoteOnAsNoteOff
            ) != nil
    }
    
    public func isNoteOff(treatZeroVelocityNoteOnAsNoteOff: Bool) -> Bool {
        return noteOffOrNil(
            treatZeroVelocityNoteOnAsNoteOff: treatZeroVelocityNoteOnAsNoteOff
            ) != nil
    }
    
    public func belongsTo(channel: Int) -> Bool {
        return belongingChannel == channel
    }
    
    /// Channel which this event is belongingこの.
    ///
    /// If this event is not channel message, then return nil
    public var belongingChannel: Int? {
        switch self {
        case .noteOn               (let e): return e.channel
        case .noteOff              (let e): return e.channel
        case .polyphonicKeyPressure(let e): return e.channel
        case .controlChange        (let e): return e.channel
        case .programChange        (let e): return e.channel
        case .channelPressure      (let e): return e.channel
        case .pitchBendChange      (let e): return e.channel
        default: return nil
        }
    }
}


//MARK: - Extensions for convenience.
public extension SMFMIDIEvent {
    static func noteOn(channel: Int, note: Int, velocity: Int) -> SMFMIDIEvent {
        return .noteOn(NoteOn(channel: channel, note: note, velocity: velocity))
    }
    
    static func noteOff(channel: Int, note: Int, velocity: Int) -> SMFMIDIEvent {
        return .noteOff(NoteOff(channel: channel, note: note, velocity: velocity))
    }
    
    static func polyphonicKeyPressure(
        channel: Int,
        note: Int,
        pressure: Int
    ) -> SMFMIDIEvent {
        return .polyphonicKeyPressure(
            PolyphonicKeyPressure(channel: channel, note: note, pressure: pressure)
        )
    }
    
    static func controlChange(
        channel: Int,
        controlNumber: ControlNumber,
        value: Int
    ) -> SMFMIDIEvent {
        return .controlChange(
            ControlChange(channel: channel, controlNumber: controlNumber, value: value)
        )
    }
    
    static func programChange(channel: Int, program: Int) -> SMFMIDIEvent {
        return .programChange(ProgramChange(channel: channel, program: program))
    }
    
    static func channelPressure(channel: Int, pressure: Int) -> SMFMIDIEvent {
        return .channelPressure(ChannelPressure(channel: channel, pressure: pressure))
    }
    
    static func pitchBendChange(channel: Int, lsb: UInt8, msb: UInt8) -> SMFMIDIEvent {
        return .pitchBendChange(PitchBendChange(channel: channel, lsb: lsb, msb: msb))
    }
    
    static func timeCodeQuarterFrame(
        type: TimeCodeQuarterFrameMessageType,
        value: UInt8
    ) -> SMFMIDIEvent {
        return .timeCodeQuarterFrame(
            TimeCodeQuarterFrame(messageType: type, value: value)
        )
    }
    
    static func songPositionPointer(lsb: UInt8, msb: UInt8) -> SMFMIDIEvent {
        return .songPositionPointer(SongPositionPointer(lsb: lsb, msb: msb))
    }
    
    static func songSelect(_ songNumber: UInt8) -> SMFMIDIEvent {
        return .songSelect(SongSelect(songNumber: songNumber))
    }
    
    static func undefinedSystemCommonMessage1() -> SMFMIDIEvent {
        return .undefinedSystemCommonMessage1(UndefinedSystemCommonMessage1())
    }
    
    static func undefinedSystemCommonMessage2() -> SMFMIDIEvent {
        return .undefinedSystemCommonMessage2(UndefinedSystemCommonMessage2())
    }
    
    static func tuneRequest() -> SMFMIDIEvent {
        return .tuneRequest(TuneRequest())
    }
    
    static func timingClock() -> SMFMIDIEvent {
        return .timingClock(TimingClock())
    }
    
    static func undefinedSystemRealTimeMessage1() -> SMFMIDIEvent {
        return .undefinedSystemRealTimeMessage1(UndefinedSystemRealTimeMessage1())
    }
    
    static func undefinedSystemRealTimeMessage2() -> SMFMIDIEvent {
        return .undefinedSystemRealTimeMessage2(UndefinedSystemRealTimeMessage2())
    }
    
    static func start() -> SMFMIDIEvent {
        return .start(Start())
    }
    
    static func `continue`() -> SMFMIDIEvent {
        return .continue(Continue())
    }
    
    static func stop() -> SMFMIDIEvent {
        return .stop(Stop())
    }
    
    static func activeSensing() -> SMFMIDIEvent {
        return .activeSensing(ActiveSensing())
    }
    
    static func systemReset() -> SMFMIDIEvent {
        return .systemReset(SystemReset())
    }
    
    static func fromMIDIEvent(_ midiEvent: MIDIEvent) -> SMFMIDIEvent {
        switch midiEvent {
        case .noteOff(let e): return .noteOff(e)
        case .noteOn(let e): return .noteOn(e)
        case .polyphonicKeyPressure(let e): return .polyphonicKeyPressure(e)
        case .controlChange(let e): return .controlChange(e)
        case .programChange(let e): return .programChange(e)
        case .channelPressure(let e): return .channelPressure(e)
        case .pitchBendChange(let e): return .pitchBendChange(e)
        case .timeCodeQuarterFrame(let e): return .timeCodeQuarterFrame(e)
        case .songPositionPointer(let e): return .songPositionPointer(e)
        case .songSelect(let e): return .songSelect(e)
        case .undefinedSystemCommonMessage1(let e): return .undefinedSystemCommonMessage1(e)
        case .undefinedSystemCommonMessage2(let e): return .undefinedSystemCommonMessage2(e)
        case .tuneRequest(let e): return .tuneRequest(e)
        case .timingClock(let e): return .timingClock(e)
        case .undefinedSystemRealTimeMessage1(let e): return .undefinedSystemRealTimeMessage1(e)
        case .undefinedSystemRealTimeMessage2(let e): return .undefinedSystemRealTimeMessage2(e)
        case .start(let e): return .start(e)
        case .continue(let e): return .continue(e)
        case .stop(let e): return .stop(e)
        case .activeSensing(let e): return .activeSensing(e)
        case .systemReset(let e): return .systemReset(e)
        case .systemExclusive(_): fatalError("SMFMIDIEvent does not contain systemExclusive")
        }
    }
}
