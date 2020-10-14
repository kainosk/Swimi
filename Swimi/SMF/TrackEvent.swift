//
//  TrackEvent.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

enum EventType {
    /// MIDI event
    case midi
    
    /// SysEx event: F0 style and F7 style
    case sysEx
    
    /// Meta event
    case meta
    
    init(byte: UInt8) {
        switch byte {
        case 0xFF: self = .meta
        case 0xF0: self = .sysEx // F0 style SysEx
        case 0xF7: self = .sysEx // F7 style SysEx
        default: self = .midi
        }
    }
}

public enum TrackEvent<SSType: SequencerSpecific>: Equatable {
    case midi(SMFMIDIEvent)
    case sysEx(SMFSysExEvent)
    case meta(MetaEvent<SSType>)
    
    public var smfBytes: [UInt8] {
        switch self {
        case .midi (let e):  return e.smfBytes
        case .sysEx(let e): return e.smfBytes
        case .meta (let e):  return e.smfBytes
        }
    }
    
    /// Convenience methods
    public var midiEventOrNil: SMFMIDIEvent? {
        switch self {
        case .midi(let e): return e
        default:           return nil
        }
    }
    
    public func noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: Bool) -> NoteOff? {
        return midiEventOrNil?.noteOffOrNil(
            treatZeroVelocityNoteOnAsNoteOff: treatZeroVelocityNoteOnAsNoteOff
        )
    }
    
    public func noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: Bool) -> NoteOn? {
        return midiEventOrNil?.noteOnOrNil(
            treatZeroVelocityNoteOnAsNoteOff: treatZeroVelocityNoteOnAsNoteOff
        )
    }
    
    public func isNoteOn(treatZeroVelocityNoteOnAsNoteOff: Bool) -> Bool {
        return midiEventOrNil?.isNoteOn(
            treatZeroVelocityNoteOnAsNoteOff: treatZeroVelocityNoteOnAsNoteOff
        ) ?? false
    }
    
    public func isNoteOff(treatZeroVelocityNoteOnAsNoteOff: Bool) -> Bool {
        return midiEventOrNil?.isNoteOff(
            treatZeroVelocityNoteOnAsNoteOff: treatZeroVelocityNoteOnAsNoteOff
        ) ?? false
    }
    
    public func belongsTo(channel: Int) -> Bool {
        return midiEventOrNil?.belongsTo(channel: channel) ?? false
    }
    
    /// Channel which this event is belongingこの.
    ///
    /// If this event is not channel message, then return nil
    public var belongingChannel: Int? {
        return midiEventOrNil?.belongingChannel
    }
    
    public var timeSignatureOrNil: TimeSignature? {
        switch self {
        case .meta(let e): return e.timeSignatureOrNil
        default: return nil
        }
    }
}
