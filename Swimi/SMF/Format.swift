//
//  Format.swift
//  Swimi
//
//  Created by Kainosuke OBATA on 2020/08/02.
//

import Foundation

public enum Format: Equatable, Parsing {
    case zero
    case one
    case two
    case others(Int)
    
    public static func parse(_ smfBytes: ArraySlice<UInt8>) -> ParseResult<Format> {
        guard let v = Int.fromBytes(smfBytes, length: Self.length) else {
            return .failure(.length(smfBytes.count))
        }
        return .success(
            ParseSucceeded(
                length: Self.length,
                component: Format(v)
            )
        )
    }
    
    public var smfBytes: [UInt8] {
        intValue.toBytes(length: Self.length)
    }
    
    public init(_ value: Int) {
        guard value <= 0xFFFF else {
            fatalError("Format must be represented by 2 bytes.")
        }
        switch value {
        case 0: self = .zero
        case 1: self = .one
        case 2: self = .two
        default: self = .others(value)
        }
    }
    
    private var intValue: Int {
        switch self {
        case .zero: return 0
        case .one: return 1
        case .two: return 2
        case .others(let v): return v
        }
    }
    
    /// Format is fixed size 2
    private static let length: Int = 2
}
