//
//  PositionalTrackEvent.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

public struct PositionalTrackEvent<SSType: SequencerSpecific>: Equatable {
    public var event: TrackEvent<SSType>
    public var position: Tick
    
    public init(event: TrackEvent<SSType>, position: Tick) {
        self.event = event
        self.position = position
    }
   
    /// convenience initializer.
    public static func at(
        _ position: Tick,
        _ event: TrackEvent<SSType>
    ) -> PositionalTrackEvent<SSType> {
        return .init(event: event, position: position)
    }
    
    /// Convenience methods
    public var midiEventOrNil: SMFMIDIEvent? {
        event.midiEventOrNil
    }
    
    public func noteOffOrNil(treatZeroVelocityNoteOnAsNoteOff: Bool) -> NoteOff? {
        return event.noteOffOrNil(
            treatZeroVelocityNoteOnAsNoteOff: treatZeroVelocityNoteOnAsNoteOff
        )
    }
    
    public func noteOnOrNil(treatZeroVelocityNoteOnAsNoteOff: Bool) -> NoteOn? {
        return event.noteOnOrNil(
            treatZeroVelocityNoteOnAsNoteOff: treatZeroVelocityNoteOnAsNoteOff
        )
    }
    
    public func isNoteOn(treatZeroVelocityNoteOnAsNoteOff: Bool) -> Bool {
        return event.isNoteOn(
            treatZeroVelocityNoteOnAsNoteOff: treatZeroVelocityNoteOnAsNoteOff
        )
    }
    
    public func isNoteOff(treatZeroVelocityNoteOnAsNoteOff: Bool) -> Bool {
        return event.isNoteOff(
            treatZeroVelocityNoteOnAsNoteOff: treatZeroVelocityNoteOnAsNoteOff
        )
    }
    
    public func belongsTo(channel: Int) -> Bool {
        return event.belongsTo(channel: channel)
    }
    
    /// Channel which this event is belongingこの.
    ///
    /// If this event is not channel message, then return nil
    public var belongingChannel: Int? {
        return event.belongingChannel
    }
    
    public var timeSignatureOrNil: TimeSignature? {
        return event.timeSignatureOrNil
    }
}
