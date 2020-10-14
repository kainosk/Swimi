//
//  PlainSMFData.swift
//  Swimi
//
//  Created by kai on 2020/09/07.
//

import Foundation

/// For convenience, we define `Plain` typealiases. `PlainSequencerSpecific` is default
/// SequencerSpecific type.
public typealias PlainSMFData = SMFData<PlainSequencerSpecific>
public typealias PlainChunk = Chunk<PlainSequencerSpecific>
public typealias PlainTrackChunk = Chunk<PlainSequencerSpecific>
public typealias PlainPositionalTrackEvent = PositionalTrackEvent<PlainSequencerSpecific>
public typealias PlainTrackEvent = TrackEvent<PlainSequencerSpecific>
public typealias PlainMetaEvent = MetaEvent<PlainSequencerSpecific>
