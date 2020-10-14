//
//  StatusType.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public enum StatusType: CaseIterable {
    
    // MARK: Channel Voice Message
    case noteOn
    case noteOff
    case polyphonicKeyPressure
    case controlChange // & channelMode
    case programChange
    case channelPressure
    case pitchBendChange
    
    // MARK: System Common Message
    case timecodeQuarterFrame
    case songPositionPointer
    case songSelect
    case undefinedSystemCommonMessage1
    case undefinedSystemCommonMessage2
    case tuneRequest
    
    // MARK: System Real Time Message
    case timingClock
    case undefinedSystemRealTimeMessage1
    case start
    case `continue`
    case stop
    case undefinedSystemRealTimeMessage2
    case activeSensing
    case systemReset
    
    // MARK: System Exclusive Message
    case systemExclusive
    case endOfExclusive
    
    var dataByteSize: DataSize {
        switch self {
            
        case .noteOn:
            return .fixed(2)
        case .noteOff:
            return .fixed(2)
        case .polyphonicKeyPressure:
            return .fixed(2)
        case .controlChange:
            return .fixed(2)
        case .programChange:
            return .fixed(1)
        case .channelPressure:
            return .fixed(1)
        case .pitchBendChange:
            return .fixed(2)
        case .timecodeQuarterFrame:
            return .fixed(1)
        case .songPositionPointer:
            return .fixed(2)
        case .songSelect:
            return .fixed(1)
        case .undefinedSystemCommonMessage1:
            return .fixed(0)
        case .undefinedSystemCommonMessage2:
            return .fixed(0)
        case .tuneRequest:
            return .fixed(0)
        case .timingClock:
            return .fixed(0)
        case .undefinedSystemRealTimeMessage1:
            return .fixed(0)
        case .start:
            return .fixed(0)
        case .continue:
            return .fixed(0)
        case .stop:
            return .fixed(0)
        case .undefinedSystemRealTimeMessage2:
            return .fixed(0)
        case .activeSensing:
            return .fixed(0)
        case .systemReset:
            return .fixed(0)
        case .systemExclusive:
            return .variable
        case .endOfExclusive:
            return .fixed(0)
        }
    }
    
    public var isSystemRealTimeMessage: Bool {
        switch self {
        case .timingClock,
             .undefinedSystemRealTimeMessage1,
             .undefinedSystemRealTimeMessage2,
             .start,
             .stop,
             .continue,
             .activeSensing,
             .systemReset:
            return true
        default:
            return false
        }
    }
    
    static func fromByte(_ byte: UInt8) -> StatusType? {
        switch byte {
        case 0x80...0x8F:
            return .noteOff
        case 0x90...0x9F:
            return .noteOn
        case 0xA0...0xAF:
            return .polyphonicKeyPressure
        case 0xB0...0xBF:
            return .controlChange
        case 0xC0...0xCF:
            return .programChange
        case 0xD0...0xDF:
            return .channelPressure
        case 0xE0...0xEF:
            return .pitchBendChange
            
        case 0xF0:
            return .systemExclusive
        case 0xF1:
            return .timecodeQuarterFrame
        case 0xF2:
            return .songPositionPointer
        case 0xF3:
            return .songSelect
        case 0xF4:
            return .undefinedSystemCommonMessage1
        case 0xF5:
            return .undefinedSystemCommonMessage2
        case 0xF6:
            return .tuneRequest
        case 0xF7:
            return .endOfExclusive
            
        case 0xF8:
            return .timingClock
        case 0xF9:
            return .undefinedSystemRealTimeMessage1
        case 0xFA:
            return .start
        case 0xFB:
            return .continue
        case 0xFC:
            return .stop
        case 0xFD:
            return .undefinedSystemRealTimeMessage2
        case 0xFE:
            return .activeSensing
        case 0xFF:
            return .systemReset
        
        default:
            return nil
        }
    }
    
    public var statusByte: UInt8 {
        switch self {
            case .noteOff: return 0x80
            case .noteOn: return 0x90
            case .polyphonicKeyPressure: return 0xA0
            case .controlChange: return 0xB0
            case .programChange: return 0xC0
            case .channelPressure: return 0xD0
            case .pitchBendChange: return 0xE0
            case .systemExclusive: return 0xF0
            case .timecodeQuarterFrame: return 0xF1
            case .songPositionPointer: return 0xF2
            case .songSelect: return 0xF3
            case .undefinedSystemCommonMessage1: return 0xF4
            case .undefinedSystemCommonMessage2: return 0xF5
            case .tuneRequest: return 0xF6
            case .endOfExclusive: return 0xF7
            case .timingClock: return 0xF8
            case .undefinedSystemRealTimeMessage1: return 0xF9
            case .start: return 0xFA
            case .continue: return 0xFB
            case .stop: return 0xFC
            case .undefinedSystemRealTimeMessage2: return 0xFD
            case .activeSensing: return 0xFE
            case .systemReset: return 0xFF
        }
    }
}
