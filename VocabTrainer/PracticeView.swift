//
//  PracticeView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 12.09.26.
//

import SwiftUI

struct PracticeView: View {
    let box: VocabBox
    @State private var remainingVocabularies: [Vocabulary] = []
    @State private var remainingAnswers: [Vocabulary] = []
    var body: some View {
        VStack {
            Text(box.name)
            if let currentVocabulary = remainingVocabularies.first {
                Text(currentVocabulary.german)
                ForEach(remainingAnswers) { vocabulary in
                    Button(vocabulary.english) {
                        if vocabulary === currentVocabulary {
                            remainingVocabularies.removeFirst()
                            remainingAnswers.removeAll {answer in
                                answer === currentVocabulary}
                            remainingAnswers.shuffle()
                        }
                    }
                }
                
            }
        }
        .onAppear {
            let shuffledArray = box.vocabularies.shuffled()
            remainingVocabularies = Array(shuffledArray.prefix(10))
            remainingAnswers = remainingVocabularies.shuffled()
        }
    }
       
}


#Preview {
    PracticeView(box: .init(name: "Test"))
}
