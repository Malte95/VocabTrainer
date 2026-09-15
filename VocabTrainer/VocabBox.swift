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
    @Relationship(deleteRule: .cascade)
    var vocabularies: [Vocabulary] = []
    var statisticWithoutErrors: Int = 0
    var statisticWithOneError: Int = 0
    var statisticWithMultipleErrors: Int = 0
    
    init(name: String) {
        self.name = name
    }
}

