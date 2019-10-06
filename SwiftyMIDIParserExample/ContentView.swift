//
//  ContentView.swift
//  SwiftyMIDIParserExample
//
//  Created by kai on 2019/10/07.
//  Copyright © 2019 kai. All rights reserved.
//

import SwiftUI
import SwiftyMIDIParser

struct ContentView: View {
    var body: some View {
        Button(action: doParse) {
            Text("Do parse.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


func doParse() {
    let parser = Parser()
    let messageBody = [UInt8].init(repeating: 0x70, count: 1024 * 1024 * 256)
    parser.input(data: [0xF0] + messageBody + [0xF7])
}
