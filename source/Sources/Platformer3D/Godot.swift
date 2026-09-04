//
//  Godot.swift
//
//
//  Created by F R Noor on 4/09/26.
//

import SwiftGodot

let registeredTypes: [Object.Type] = [
    AudioPlayer.self,
    Player.self,
    Coin.self,
    Cloud.self,
    FallingPlatform.self,
    GameUI.self,
    CameraView.self
]

#initSwiftExtension(cdecl: "swift_entry_point", types: registeredTypes)