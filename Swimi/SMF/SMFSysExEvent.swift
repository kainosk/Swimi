//
//  SysExEvent.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/03.
//

import Foundation

public enum SMFSysExEvent: Equatable, Parsing {
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<SMFSysExEvent> {
        var failureLength = 0
        
        // F0 Style
        switch F0SysExEvent.parse(smfBytes) {
        case .failure(let failure):
            failureLength = failure.length
        case .success(let success):
            return .success(
                ParseSucceeded(
                    length: success.length,
                    component: .f0Style(success.component)
                )
            )
        }
        
        // F7 Style
        switch F7SysExEvent.parse(smfBytes) {
        case .failure(let failure):
            return .failure(
                .length(
                    max(failureLength, failure.length)
                )
            )
            
        case .success(let success):
            return .success(
                ParseSucceeded(
                    length: success.length,
                    component: .f7Style(success.component)
                )
            )
        }
    }
    
    public var smfBytes: [UInt8] {
        switch self {
        case .f0Style(let e): return e.smfBytes
        case .f7Style(let e): return e.smfBytes
        }
    }
    
    public var data: [UInt8] {
        switch self {
        case .f0Style(let e): return e.data
        case .f7Style(let e): return e.data
        }
    }
    
    case f0Style(F0SysExEvent)
    case f7Style(F7SysExEvent)
}

//MARK: - Extensions for convenience.
public extension SMFSysExEvent {
    static func f0(dataWithoutFirstF0: [UInt8]) -> SMFSysExEvent {
        return .f0Style(F0SysExEvent(dataWithoutFirstF0: dataWithoutFirstF0))
    }
    
    static func f0(dataIncludingFirstF0: [UInt8]) -> SMFSysExEvent {
        return .f0Style(F0SysExEvent(dataIncludingFirstF0: dataIncludingFirstF0))
    }
    
    static func f7(_ data: [UInt8]) -> SMFSysExEvent {
        return .f7Style(F7SysExEvent(data: data))
    }
}
