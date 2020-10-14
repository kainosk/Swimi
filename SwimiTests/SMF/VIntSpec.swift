//
//  VIntSpec.swift
//  SwimiTests
//
//  Created by Kainosuke OBATA on 2020/08/02.
//  Copyright © 2020 kai. All rights reserved.
//

import Quick
import Nimble
@testable import Swimi

class VIntSpec: QuickSpec {
    
    override func spec() {
        describe("smfBytes") {
            // 16進数表記
            it("0 -> 00") {
                expect(VInt(0x0).smfBytes) == [0x00]
            }
            it("40 -> 40") {
                expect(VInt(0x40).smfBytes) == [0x40]
            }
            it("7F -> 7F") {
                expect(VInt(0x7F).smfBytes) == [0x7F]
            }
            it("80 -> 81 00") {
                expect(VInt(0x80).smfBytes) == [0x81, 0x00]
            }
            it("2000 -> C0 00") {
                expect(VInt(0x2000).smfBytes) == [0xC0, 0x00]
            }
            it("3FFF -> FF 7F") {
                expect(VInt(0x3FFF).smfBytes) == [0xFF, 0x7F]
            }
            it("4000 -> 81 80 00") {
                expect(VInt(0x4000).smfBytes) == [0x81, 0x80, 0x00]
            }
            it("100000 -> C0 80 00") {
                expect(VInt(0x100000).smfBytes) == [0xC0, 0x80, 0x00]
            }
            it("1FFFFF -> FF FF 7F") {
                expect(VInt(0x1FFFFF).smfBytes) == [0xFF, 0xFF, 0x7F]
            }
            it("200000 -> 81 80 80 00") {
                expect(VInt(0x200000).smfBytes) == [0x81, 0x80, 0x80, 0x00]
            }
            it("8000000 -> C0 80 80 00") {
                expect(VInt(0x8000000).smfBytes) == [0xC0, 0x80, 0x80, 0x00]
            }
            it("FFFFFFF -> FF FF FF 7F") {
                expect(VInt(0xFFFFFFF).smfBytes) == [0xFF, 0xFF, 0xFF, 0x7F]
            }
        }
        describe("parse") {
            it("0 <- 00") {
                expect(VInt.parse([0x00])) == .success(
                    ParseSucceeded(length: 1,  component: VInt(0x0))
                )
            }
            it("40 <- 40") {
                expect(VInt.parse([0x40])) == .success(
                    ParseSucceeded(length: 1,  component: VInt(0x40))
                )
            }
            it("7F <- 7F") {
                expect(VInt.parse([0x7F])) == .success(
                    ParseSucceeded(length: 1,  component: VInt(0x7F))
                )
            }
            it("80 <- 81 00") {
                expect(VInt.parse([0x81, 0x00])) == .success(
                    ParseSucceeded(length: 2,  component: VInt(0x80))
                )
            }
            it("2000 <- C0 00") {
                expect(VInt.parse([0xC0, 0x00])) == .success(
                    ParseSucceeded(length: 2,  component: VInt(0x2000))
                )
            }
            it("3FFF <- FF 7F") {
                expect(VInt.parse([0xFF, 0x7F])) == .success(
                    ParseSucceeded(length: 2,  component: VInt(0x3FFF))
                )
            }
            it("4000 <- 81 80 00") {
                expect(VInt.parse([0x81, 0x80, 0x00])) == .success(
                    ParseSucceeded(length: 3,  component: VInt(0x4000))
                )
            }
            it("100000 <- C0 80 00") {
                expect(VInt.parse([0xC0, 0x80, 0x00])) == .success(
                    ParseSucceeded(length: 3,  component: VInt(0x100000))
                )
            }
            it("1FFFFF <- FF FF 7F") {
                expect(VInt.parse([0xFF, 0xFF, 0x7F])) == .success(
                    ParseSucceeded(length: 3,  component: VInt(0x1FFFFF))
                )
            }
            it("200000 <- 81 80 80 00") {
                expect(VInt.parse([0x81, 0x80, 0x80, 0x00])) == .success(
                    ParseSucceeded(length: 4,  component: VInt(0x200000))
                )
            }
            it("8000000 <- C0 80 80 00") {
                expect(VInt.parse([0xC0, 0x80, 0x80, 0x00])) == .success(
                    ParseSucceeded(length: 4,  component: VInt(0x8000000))
                )
            }
            it("FFFFFFF <- FF FF FF 7F") {
                expect(VInt.parse([0xFF, 0xFF, 0xFF, 0x7F])) == .success(
                    ParseSucceeded(length: 4,  component: VInt(0xFFFFFFF))
                )
            }
            it("empty -> nil") {
                expect(VInt.parse([])) == .failure(.length(0))
            }
            it("end with non msb 0 byte -> nil") {
                expect(VInt.parse([0xFF, 0xFF])) == .failure(.length(2))
            }
        }
        
    }
    
}
