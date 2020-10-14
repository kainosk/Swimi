//
//  Parsing.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

public struct ParseSucceeded<Component> {
    public var length: Int
    public var component: Component
}

public struct ParseFailed: Equatable {
    public var length: Int
    public static func length(_ length: Int) -> ParseFailed {
        ParseFailed(length: length)
    }
}

public enum ParseResult<Component> {
    case success(ParseSucceeded<Component>)
    case failure(ParseFailed)
    
    var isSuccess: Bool {
        switch self {
        case .success(_): return true
        case .failure(_): return false
        }
    }
}

extension ParseSucceeded: Equatable where Component: Equatable {}
extension ParseResult: Equatable where Component: Equatable {}

public protocol Parsing {
    static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<Self>
    var smfBytes: [UInt8] { get }
}


public protocol MetaEventParsing {
    static func parse<SSType: SequencerSpecific>(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<MetaEvent<SSType>>
    var smfBytes: [UInt8] { get }
}
