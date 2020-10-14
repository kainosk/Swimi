//
//  TrackChunk.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

public struct TrackChunk<SSType: SequencerSpecific>: Equatable {
    
    public var events: [PositionalTrackEvent<SSType>]
    
    
    public var firstTimeSignature: TimeSignature? {
        return events.first { $0.timeSignatureOrNil != nil }?.timeSignatureOrNil
    }
    
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseSucceeded<TrackChunk<SSType>> {
        var bytes = smfBytes
        
        // Parse events: DeltaTime + (MIDI | SysEx | Meta)
        var events: [PositionalTrackEvent<SSType>] = []
        let makeResult = {
            ParseSucceeded(
                // This value is ignored by `Chunk`, zero is meaningless.
                length: 0,
                component: TrackChunk(events: events)
            )
        }
        
        let midiParser = MIDIEventParser(parser: Parser())
        let metaParser = MetaEventParser<SSType>()
        var tick: Tick = 0
        while true {
            guard case let .success(dt) = VInt.parse(bytes) else {
                // failed to parse but return value incompletely.
                break
            }
            tick += dt.component.value
            bytes = bytes.dropFirst(dt.length)
            guard bytes.count > 0 else {
                break
            }
            
            let type = EventType(byte: bytes.first!)
            switch type {
            case .midi:
                let result = midiParser.input(bytes: Array(bytes))
                
                switch result {
                case .success(let success):
                    events.append(
                        PositionalTrackEvent(
                            event: .midi(success.component),
                            position: tick
                        )
                    )
                    bytes = bytes.dropFirst(success.length)
                case .failure(let failure):
                    bytes = bytes.dropFirst(failure.length)
                }
            case .meta:
                let result = metaParser.parse(bytes)
                switch result {
                case .success(let success):
                    events.append(
                        PositionalTrackEvent(
                            event: .meta(success.component),
                            position: tick
                        )
                    )
                    bytes = bytes.dropFirst(success.length)
                case .failure(let failure):
                    bytes = bytes.dropFirst(failure.length)
                }
            case .sysEx:
                let result = SMFSysExEvent.parse(bytes)
                switch result {
                case .failure(let failure):
                    bytes = bytes.dropFirst(failure.length)
                case .success(let success):
                    events.append(
                        PositionalTrackEvent(
                            event: .sysEx(success.component),
                            position: tick
                        )
                    )
                    bytes = bytes.dropFirst(success.length)
                }
            }
        }
        return makeResult()
    }
    
    public var smfBytes: [UInt8] {
        var t = 0
        var bytes: [UInt8] = []
        for event in events {
            let dt = event.position - t
            t += dt
            bytes.append(contentsOf: VInt(dt).smfBytes)
            bytes.append(contentsOf: event.event.smfBytes)
        }
        return bytes
    }
    
    public init(events: [PositionalTrackEvent<SSType>]) {
        self.events = events
    }
}

class MIDIEventParser {
    let parser: Parser
    
    init(parser: Parser) {
        self.parser = parser
        parser.notifier.eventParsed = { [weak self] in
            self?.parsedMIDIEvent = SMFMIDIEvent.fromMIDIEvent($0)
        }
//        // [I want to refactor] Grouping Non Realtime MIDI Message with enum and Simplify Notifier interfaces.
//        parser.notifier.noteOff = { [weak self] in self?.parsedMIDIEvent = .noteOff($0) }
//        parser.notifier.noteOn = { [weak self] in self?.parsedMIDIEvent = .noteOn($0) }
//        parser.notifier.polyphonicKeyPressure = { [weak self] in self?.parsedMIDIEvent = .polyphonicKeyPressure($0) }
//        parser.notifier.controlChange = { [weak self] in self?.parsedMIDIEvent = .controlChange($0) }
//        parser.notifier.programChange = { [weak self] in self?.parsedMIDIEvent = .programChange($0) }
//        parser.notifier.channelPressure = { [weak self] in self?.parsedMIDIEvent = .channelPressure($0) }
//        parser.notifier.pitchBendChange = { [weak self] in self?.parsedMIDIEvent = .pitchBendChange($0) }
//        parser.notifier.timeCodeQuarterFrame = { [weak self] in self?.parsedMIDIEvent = .timeCodeQuarterFrame($0) }
//        parser.notifier.songPositionPointer = { [weak self] in self?.parsedMIDIEvent = .songPositionPointer($0) }
//        parser.notifier.songSelect = { [weak self] in self?.parsedMIDIEvent = .songSelect($0) }
//        parser.notifier.undefinedSystemCommonMessage1 = { [weak self] in self?.parsedMIDIEvent = .undefinedSystemCommonMessage1($0) }
//        parser.notifier.undefinedSystemCommonMessage2 = { [weak self] in self?.parsedMIDIEvent = .undefinedSystemCommonMessage2($0) }
//        parser.notifier.tuneRequest = { [weak self] in self?.parsedMIDIEvent = .tuneRequest($0) }
//        parser.notifier.timingClock = { [weak self] in self?.parsedMIDIEvent = .timingClock($0) }
//        parser.notifier.undefinedSystemRealTimeMessage1 = { [weak self] in self?.parsedMIDIEvent = .undefinedSystemRealTimeMessage1($0) }
//        parser.notifier.undefinedSystemRealTimeMessage2 = { [weak self] in self?.parsedMIDIEvent = .undefinedSystemRealTimeMessage2($0) }
//        parser.notifier.start = { [weak self] in self?.parsedMIDIEvent = .start($0) }
//        parser.notifier.`continue` = { [weak self] in self?.parsedMIDIEvent = .`continue`($0) }
//        parser.notifier.stop = { [weak self] in self?.parsedMIDIEvent = .stop($0) }
//        parser.notifier.activeSensing = { [weak self] in self?.parsedMIDIEvent = .activeSensing($0) }
//        //       parser.notifier.systemReset = { [weak self] in self?.parsedMIDIEvent = .systemReset($0) }
//        //       parser.notifier.systemExclusive = { [weak self] in self?.parsedMIDIEvent = .systemExclusive($0) }
    }
    
    func input(bytes: [UInt8]) -> ParseResult<SMFMIDIEvent> {
        parsedMIDIEvent = nil
        var byteCount = 1
        for byte in bytes {
            parser.input(data: [byte])
            if let event = parsedMIDIEvent {
                return .success(
                    ParseSucceeded(length: byteCount, component: event)
                )
            }
            byteCount += 1
        }
        return .failure(.length(byteCount))
    }
    
    private var parsedMIDIEvent: SMFMIDIEvent?
    
}
