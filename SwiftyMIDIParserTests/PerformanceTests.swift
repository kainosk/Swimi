//
//  PerformanceTests.swift
//  SwiftyMIDIParserTests
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation
import XCTest
import SwiftyMIDIParser

class PerformanceTests: XCTestCase {
    
    func test_Performance() {
        let subject = Parser()
        let data = (0..<100000)
            .map { _ in
                [
                    0x95,   1,    1,
                    0x95,   3,    3,
                            7,    7, // Running Status
                           15,   15, // Running Status
                    0x95,  31,   31,
                    0xF0,  11, 0xF7, // System Exclusive
                    0x95,  63,   63,
                          127,  127, // Running Status
                    0xF0,  22, 0xF7, // System Exclusive
                    0x95,   0,    0,
                ] as [UInt8]
            }
        
        let dataSize = data.reduce(into: 0) { (result, array) in
            result += array.count
        }
        print("dataSize = \(dataSize / 1000) kByte")
        measure {
            data.forEach {
                subject.input(data: $0)
            }
        }
        
        // 2019/10/05
        // MacBook Pro (15-inch, 2018)
        // 2.2 GHz Intel Core i7
        // Average: 0.275 second (dataSize = 2700 KB)
        //  => 9818 kB/sec
    }
    
    func test_performance2() {
        let subject = Parser()
        let messageBody = [UInt8].init(repeating: 0x70, count: 1024 * 1024 * 256)
        
        measure {
            subject.input(data: [0xF0] + messageBody + [0xF7])
        }
        
        // 2019/10/05
        // MacBook Pro (15-inch, 2018)
        // 2.2 GHz Intel Core i7
        // Average: 7.8 second (dataSize = 256 MB)
        //  => 33608 kB/sec
    }
}
