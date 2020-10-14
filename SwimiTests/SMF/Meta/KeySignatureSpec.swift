//
//  KeySignatureSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/11.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class KeySignatureSpec: QuickSpec {
    
    override func spec() {
        let minus7: UInt8 = UInt8(bitPattern: -7)
        let minus8: UInt8 = UInt8(bitPattern: -8)
        
        describe("init with number of shaps/flats and mode") {
            let key = KeySignature(
                numberOfSharpsOrFlats: 1,
                mode: .major
            )
            it("provides number of sharps/flats") {
                expect(key.numberOfSharpsOrFlats) == 1
            }
            it("provides major/minor") {
                expect(key.mode) == .major
            }
            context("if passed number of sharps/flats is less than -7") {
                it("throw fatalError") {
                    expect {
                        _ = KeySignature(
                            numberOfSharpsOrFlats: -8,
                            mode: .major
                        )
                    }.to(throwAssertion())
                }
            }
            context("if passed number of sharps/flats is greater than +7") {
                it("throw fatalError") {
                    expect {
                        _ = KeySignature(
                            numberOfSharpsOrFlats: 8,
                            mode: .major
                        )
                    }.to(throwAssertion())
                }
            }
        }
        describe("setter: numberOfSharpsOrFlats") {
            var key: KeySignature!
            beforeEach {
                key = KeySignature(numberOfSharpsOrFlats: 0, mode: .major)
            }
            context("if passed number of sharps/flats is in -7 ~ 0 ~ 7") {
                it("accepts") {
                    key.numberOfSharpsOrFlats = 7
                    expect(key.numberOfSharpsOrFlats) == 7
                }
            }
            context("if passed number of sharps/flats is less than -7") {
                it("throw fatalError") {
                    expect {
                        key.numberOfSharpsOrFlats = -8
                    }.to(throwAssertion())
                }
            }
            context("if passed number of sharps/flats is greater than +7") {
                it("throw fatalError") {
                    expect {
                        _ = KeySignature(
                            numberOfSharpsOrFlats: 8,
                            mode: .major
                        )
                    }.to(throwAssertion())
                }
            }
        }
        describe("parse") {
            it("Success: (7, major)") {
                let binary: [UInt8] = [0xFF, 0x59, 0x02, 0x07, 0x00]
                let result: ParseResult<MetaEvent<SS>> = KeySignature.parse(binary[...])
                expect(result) == .success(
                    ParseSucceeded(
                        length: 5,
                        component: .keySignature(numberOfSharpsOrFlats: 7, mode: .major)
                    )
                )
            }
            it("Success: (-7, major)") {
                let binary: [UInt8] = [0xFF, 0x59, 0x02, minus7, 0x00]
                let result: ParseResult<MetaEvent<SS>> = KeySignature.parse(binary[...])
                expect(result) == .success(
                    ParseSucceeded(
                        length: 5,
                        component: .keySignature(numberOfSharpsOrFlats: -7, mode: .major)
                    )
                )
            }
            it("Success: (7, minor)") {
                let binary: [UInt8] = [0xFF, 0x59, 0x02, 0x07, 0x01]
                let result: ParseResult<MetaEvent<SS>> = KeySignature.parse(binary[...])
                expect(result) == .success(
                    ParseSucceeded(
                        length: 5,
                        component: .keySignature(numberOfSharpsOrFlats: 7, mode: .minor)
                    )
                )
            }
            it("Success: (-7, minor)") {
                let binary: [UInt8] = [0xFF, 0x59, 0x02, minus7, 0x01]
                let result: ParseResult<MetaEvent<SS>> = KeySignature.parse(binary[...])
                expect(result) == .success(
                    ParseSucceeded(
                        length: 5,
                        component: .keySignature(numberOfSharpsOrFlats: -7, mode: .minor)
                    )
                )
            }
            it("Success: (0, major)") {
                let binary: [UInt8] = [0xFF, 0x59, 0x02, 0x00, 0x00]
                let result: ParseResult<MetaEvent<SS>> = KeySignature.parse(binary[...])
                expect(result) == .success(
                    ParseSucceeded(
                        length: 5,
                        component: .keySignature(numberOfSharpsOrFlats: 0, mode: .major)
                    )
                )
            }
            it("Success: (0, minor)") {
                let binary: [UInt8] = [0xFF, 0x59, 0x02, 0, 0x01]
                let result: ParseResult<MetaEvent<SS>> = KeySignature.parse(binary[...])
                expect(result) == .success(
                    ParseSucceeded(
                        length: 5,
                        component: .keySignature(numberOfSharpsOrFlats: 0, mode: .minor)
                    )
                )
            }
            it("Failure: Prefix is not match.") {
                let binary: [UInt8] = [0xFF, 0x58, 0x02, 0x07, 0x00]
                let result: ParseResult<MetaEvent<SS>> = KeySignature.parse(binary[...])
                expect(result) == .failure(
                    ParseFailed(length: 0)
                )
            }
            it("Failure: number of sharps/flats less than -7") {
                let binary: [UInt8] = [0xFF, 0x59, 0x02, minus8, 0x00]
                let result: ParseResult<MetaEvent<SS>> = KeySignature.parse(binary[...])
                expect(result) == .failure(
                    ParseFailed(length: 5)
                )
            }
            it("Failure: number of sharps/flats greater than 7") {
                let binary: [UInt8] = [0xFF, 0x59, 0x02, 0x08, 0x00]
                let result: ParseResult<MetaEvent<SS>> = KeySignature.parse(binary[...])
                expect(result) == .failure(
                    ParseFailed(length: 5)
                )
            }
            it("Failure: mode is not 0/1") {
                let binary: [UInt8] = [0xFF, 0x59, 0x02, 0x00, 0x02]
                let result: ParseResult<MetaEvent<SS>> = KeySignature.parse(binary[...])
                expect(result) == .failure(
                    ParseFailed(length: 5)
                )
            }
        }
        describe("smfBytes") {
            it("can provide smfBytes (+7, major)") {
                let key = KeySignature(numberOfSharpsOrFlats: 7, mode: .major)
                expect(key.smfBytes) == [0xFF, 0x59, 0x02, 0x07, 0x00]
            }
            it("can provide smfBytes (-7, major)") {
                let key = KeySignature(numberOfSharpsOrFlats: -7, mode: .major)
                expect(key.smfBytes) == [0xFF, 0x59, 0x02, UInt8(bitPattern: -7), 0x00]
            }
            it("can provide smfBytes (+7, minor)") {
                let key = KeySignature(numberOfSharpsOrFlats: 7, mode: .minor)
                expect(key.smfBytes) == [0xFF, 0x59, 0x02, 0x07, 0x01]
            }
            it("can provide smfBytes (-7, minor)") {
                let key = KeySignature(numberOfSharpsOrFlats: -7, mode: .minor)
                expect(key.smfBytes) == [0xFF, 0x59, 0x02, UInt8(bitPattern: -7), 0x01]
            }
            it("can provide smfBytes (0, major)") {
                let key = KeySignature(numberOfSharpsOrFlats: 0, mode: .major)
                expect(key.smfBytes) == [0xFF, 0x59, 0x02, 0x00, 0x00]
            }
            it("can provide smfBytes (0, minor)") {
                let key = KeySignature(numberOfSharpsOrFlats: 0, mode: .minor)
                expect(key.smfBytes) == [0xFF, 0x59, 0x02, 0x00, 0x01]
            }
        }
    }
}
