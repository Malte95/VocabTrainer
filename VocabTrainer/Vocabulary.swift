//
//  Vocabulary.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 03.09.26.
//

import Foundation
import SwiftData

@Model
final class Vocabulary {
    var english: String
    var german: String
    
    init(english: String, german: String) {
        self.english = english
        self.german = german
    }
}

