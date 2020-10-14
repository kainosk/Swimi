//
//  TimeSignatureSpec.swift
//  SwimiTests
//
//  Created by kai on 2020/09/11.
//

import Foundation
import Quick
import Nimble
@testable import Swimi

class TimeSignatureSpec: QuickSpec {
    
    override func spec() {
        describe("init with numerator, denominator, midiClocksPerMetronomeClick, thirtySecondNotesPer24MIDIClocks") {
            let ts = TimeSignature(
                numerator: 10,
                denominator: 8,
                midiClocksPerMetronomeClick: 24,
                thirtySecondNotesPer24MIDIClocks: 8
            )
            it("returns passed numerator as is") {
                expect(ts.numerator) == 10
            }

            it("returns denominatorPowerOfTwo log2(denominator)") {
                expect(ts.denominatorPowerOfTwo) == 3
            }
            context("passed denomitor is power of two") {
                it("returns passed denominator as is") {
                    expect(ts.denominator) == 8
                }
            }
            context("passed denominator is not power of two") {
                it("converts denomitor to nearest power of two") {
                    let ts = TimeSignature(
                        numerator: 4,
                        denominator: 7,
                        midiClocksPerMetronomeClick: 24,
                        thirtySecondNotesPer24MIDIClocks: 8
                    )
                    expect(ts.denominator) == 8
                    expect(ts.denominatorPowerOfTwo) == 3
                }
            }
        }
        describe("init with numerator, denominator as power of two, midiClocksPerMetronomeClick, thirtySecondNotesPer24MIDIClocks") {
            let ts = TimeSignature(
                numerator: 9,
                denominatorPowerOfTwo: 3,
                midiClocksPerMetronomeClick: 24,
                thirtySecondNotesPer24MIDIClocks: 8
            )
            it("returns passed numerator as is") {
                expect(ts.numerator) == 9
            }
            it("returns denominator: 2^denominatorPowerOfTwo") {
                expect(ts.denominator) == 8
            }
            it("returns passed denominatorPowerOfTwo as is") {
                expect(ts.denominatorPowerOfTwo) == 3
            }
        }
        describe("smfBytes") {
            it("returns 0xFF, 0x58, 0x04, and 4 values") {
                let ts = TimeSignature(
                    numerator: 100,
                    denominatorPowerOfTwo: 10,
                    midiClocksPerMetronomeClick: 24,
                    thirtySecondNotesPer24MIDIClocks: 8
                )
                expect(ts.smfBytes) == [
                    0xFF, 0x58, 0x04,
                    100, 10, 24, 8
                ]
            }
        }
        describe("parse") {
            var result: ParseResult<MetaEvent<SS>>!
            context("smfBytes does not have prefix [0xFF, 0x00, 0x02]") {
                
                it("returns failure with length 0") {
                    result = TimeSignature.parse([0xFF, 0x57, 0x04, 0x00, 0x11, 0x22, 0x33])
                    expect(result) == .failure(.length(0))
                }
            }
            context("smfBytes has prefix bytes but data is less than 4 bytes (3)") {
                it("returns failure with length smfBytes.count") {
                    result = TimeSignature.parse([0xFF, 0x58, 0x04, 0x00, 0x11, 0x22])
                    expect(result) == .failure(.length(6))
                }
            }
            context("smfBytes has prefix bytes but data is less than 4 bytes (2)") {
                it("returns failure with length smfBytes.count") {
                    result = TimeSignature.parse([0xFF, 0x58, 0x04, 0x00, 0x11])
                    expect(result) == .failure(.length(5))
                }
            }
            context("smfBytes has prefix bytes but data is less than 4 bytes (1)") {
                it("returns failure with length smfBytes.count") {
                    result = TimeSignature.parse([0xFF, 0x58, 0x04, 0x00])
                    expect(result) == .failure(.length(4))
                }
            }
            context("smfBytes has prefix bytes but data is less than 4 bytes (0)") {
                it("returns failure with length smfBytes.count") {
                    result = TimeSignature.parse([0xFF, 0x58, 0x04])
                    expect(result) == .failure(.length(3))
                }
            }
            context("smfBytes has prefix and data length is two (valid)") {
                it("returns success") {
                    result = TimeSignature.parse([0xFF, 0x58, 0x04, 10, 20, 30, 40, 0, 0])
                    expect(result) == .success(
                        ParseSucceeded(
                            length: 7,
                            component: .timeSignature(
                                numerator: 10,
                                denominatorPowerOfTwo: 20,
                                midiClocksPerMetronomeClick: 30,
                                thirtySecondNotesPer24MIDIClocks: 40
                            )
                        )
                    )
                }
            }
        }
    }
}
