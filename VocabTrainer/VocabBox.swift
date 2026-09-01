//
//  VocabBox.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 01.09.26.
//

import Foundation
import SwiftData

@Model
final class VocabBox {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

