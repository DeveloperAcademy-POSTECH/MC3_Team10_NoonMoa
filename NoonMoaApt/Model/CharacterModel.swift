//
//  CharacterModel.swift
//  NoonMoaApt
//
//  Created by 최민규 on 2023/07/31.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

struct CharacterRecord: Identifiable {
    @DocumentID var id: String?
    var rawIsSmiling: Bool
    var rawIsBlinkingLeft: Bool
    var rawIsBlinkingRight: Bool
    var rawLookAtPoint: [Float]
    var rawFaceOrientation: [Float]
    var rawCharacterColor: [Float]
}

struct CharacterRecordViewData: Identifiable {
    @DocumentID var id: String?
    var isSmiling: Bool
    var isBlinkingLeft: Bool
    var isBlinkingRight: Bool
    var lookAtPoint: SIMD3<Float>
    var faceOrientation: SIMD3<Float>
    var characterColor: Color
    var bodyColor: LinearGradient
    var eyeColor: LinearGradient
    var cheekColor: LinearGradient
}
