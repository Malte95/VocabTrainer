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
    @State private var lastIncorrectAnswer: Vocabulary? = nil
    @State private var lastCorrectAnswer: Vocabulary? = nil
    @State private var isProcessingAnswer = false
    var body: some View {
        VStack {
            Text(box.name)
            if let currentVocabulary = remainingVocabularies.first {
                Text(currentVocabulary.german)
                ForEach(remainingAnswers) { vocabulary in
                    Button(vocabulary.english) {
                        if vocabulary === currentVocabulary {
                            lastCorrectAnswer = vocabulary
                            lastIncorrectAnswer = nil
                            isProcessingAnswer = true
                            Task {
                                try? await Task.sleep(for: .milliseconds(500))
                                remainingVocabularies.removeFirst()
                                remainingAnswers.removeAll {answer in
                                    answer === currentVocabulary}
                                remainingAnswers.shuffle()
                                lastCorrectAnswer = nil
                                isProcessingAnswer = false
                            }
                            
                        } else {
                            lastIncorrectAnswer = vocabulary
                        }
                    }
                    .foregroundStyle(
                        answerColor(for: vocabulary)
                    )
                    .disabled(isProcessingAnswer)
                }
                
            }
        }
        .onAppear {
            let shuffledArray = box.vocabularies.shuffled()
            remainingVocabularies = Array(shuffledArray.prefix(10))
            remainingAnswers = remainingVocabularies.shuffled()
        }
    }
    
    private func answerColor(for vocabulary: Vocabulary) -> Color {
        if vocabulary === lastCorrectAnswer {
           return Color.green
        } else if vocabulary === lastIncorrectAnswer {
            return Color.red
        } else {
            return Color.accentColor
        }
    }
       
}


#Preview {
    PracticeView(box: .init(name: "Test"))
}
