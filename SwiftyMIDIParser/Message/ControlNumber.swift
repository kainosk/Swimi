//
//  ControlNumber.swift
//  SwiftyMIDIParser
//
//  Created by kai on 2019/10/05.
//  Copyright © 2019 kai. All rights reserved.
//

import Foundation

public enum ControlNumber: UInt8 {
    case bankSelectMSB = 0x00
    case modulationWheel = 0x01
    case breathController = 0x02
    case undefined1 = 0x03
    case footController = 0x04
    case portamentoTime = 0x05
    case dataEntryMSB = 0x06
    case channelVolume = 0x07 // former name is "main volume"
    case balance = 0x08
    case undefined2 = 0x09
    case pan = 0x0A
    case expressionController = 0x0B
    case effectControl1 = 0x0C
    case effectControl2 = 0x0D
    case undefined3 = 0x0E
    case undefined4 = 0x0F
    case generalPurposeController1 = 0x10
    case generalPurposeController2 = 0x11
    case generalPurposeController3 = 0x12
    case generalPurposeController4 = 0x13
    case undefined5 = 0x14
    case undefined6 = 0x15
    case undefined7 = 0x16
    case undefined8 = 0x17
    case undefined9 = 0x18
    case undefined10 = 0x19
    case undefined11 = 0x1A
    case undefined12 = 0x1B
    case undefined13 = 0x1C
    case undefined14 = 0x1D
    case undefined15 = 0x1E
    case undefined16 = 0x1F
    
    case bankSelectLSB = 0x20
    case modulationWheelLSB = 0x21
    case breathControllerLSB = 0x22
    case undefined1LSB = 0x23
    case footControllerLSB = 0x24
    case portamentoTimeLSB = 0x25
    case dataEntryLSB = 0x26
    case channelVolumeLSB = 0x27
    case balanceLSB = 0x28
    case undefined2LSB = 0x29
    case panLSB = 0x2A
    case expressionControllerLSB = 0x2B
    case effectControl1LSB = 0x2C
    case effectControl2LSB = 0x2D
    case undefined3LSB = 0x2E
    case undefined4LSB = 0x2F
    case generalPurposeController1LSB = 0x30
    case generalPurposeController2LSB = 0x31
    case generalPurposeController3LSB = 0x32
    case generalPurposeController4LSB = 0x33
    case undefined5LSB = 0x34
    case undefined6LSB = 0x35
    case undefined7LSB = 0x36
    case undefined8LSB = 0x37
    case undefined9LSB = 0x38
    case undefined10LSB = 0x39
    case undefined11LSB = 0x3A
    case undefined12LSB = 0x3B
    case undefined13LSB = 0x3C
    case undefined14LSB = 0x3D
    case undefined15LSB = 0x3E
    case undefined16LSB = 0x3F
    
    case damperPedal = 0x40 // or sustain or hold
    case portamentoOnOff = 0x41
    case sostenuto = 0x42
    case softPedal = 0x43
    case legatoFootSwitch = 0x44
    case hold2 = 0x45 // or sustain2 or damperPedal2
    case soundController1 = 0x46 // default is sound variation
    case soundController2 = 0x47 // default is timber/harmonic intensity
    case soundController3 = 0x48 // default is release time
    case soundController4 = 0x49 // default is attack time
    case soundController5 = 0x4A // default is brightness
    case soundController6 = 0x4B // no defaults
    case soundController7 = 0x4C // no defaults
    case soundController8 = 0x4D // no defaults
    case soundController9 = 0x4E // no defaults
    case soundController10 = 0x4F // no defaults
    case generalPurposeController5 = 0x50
    case generalPurposeController6 = 0x51
    case generalPurposeController7 = 0x52
    case generalPurposeController8 = 0x53
    case portamentoControl = 0x54
    case undefined17 = 0x55
    case undefined18 = 0x56
    case undefined19 = 0x57
    case undefined20 = 0x58
    case undefined21 = 0x59
    case undefined22 = 0x5A
    case effect1Depth = 0x5B
    case effect2Depth = 0x5C
    case effect3Depth = 0x5D
    case effect4Depth = 0x5E
    case effect5Depth = 0x5F
    case dataIncrement = 0x60
    case dataDecrement = 0x61
    case nonRegisteredParameterNumberLSB = 0x62
    case nonRegisteredParameterNumberMSB = 0x63
    case registeredParameterNumberLSB = 0x64
    case registeredParameterNumberMSB = 0x65
    case undefined23 = 0x66
    case undefined24 = 0x67
    
    // MARK: Channel Mode Messages
    case allSoundOff = 0x78 // 0x78 == 120
    case resetAllController = 0x79
    case localControl = 0x7A
    case allNotesOff = 0x7B
    case omniModeOff = 0x7C // and AllNotesOff
    case omniModeOn = 0x7D // and AllNotesOff
    case monoModeOn = 0x7E // and PolyModeOff, AllNotesOff
    case polyModeOn = 0x7F // and MonoModeOff, AllNotesOff
}
