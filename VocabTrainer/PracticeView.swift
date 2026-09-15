//
//  PracticeView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 12.09.26.
//

import SwiftUI
import SwiftData

struct PracticeView: View {
    @Environment(\.modelContext) private var modelContext
    let box: VocabBox
    @State private var remainingVocabularies: [Vocabulary] = []
    @State private var remainingAnswers: [Vocabulary] = []
    @State private var incorrectVocabularies: [Vocabulary] = []
    @State private var lastIncorrectAnswer: Vocabulary? = nil
    @State private var lastCorrectAnswer: Vocabulary? = nil
    @State private var isProcessingAnswer = false
    @State private var totalVocabularyCount = 0
    @State private var incorrectAttemptsForCurrentVocabulary = 0
    @State private var correctWithoutErrorsCount = 0
    @State private var correctWithOneErrorCount = 0
    @State private var correctWithMultipleErrorsCount = 0
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
                            if incorrectAttemptsForCurrentVocabulary == 0 {
                                correctWithoutErrorsCount += 1
                            } else if incorrectAttemptsForCurrentVocabulary == 1 {
                                correctWithOneErrorCount += 1
                            } else {
                                correctWithMultipleErrorsCount += 1
                            }
                            Task {
                                try? await Task.sleep(for: .milliseconds(500))
                                remainingVocabularies.removeFirst()
                                if remainingVocabularies.isEmpty {
                                    saveStatistics()
                                }
                                remainingAnswers.removeAll {answer in
                                    answer === currentVocabulary}
                                remainingAnswers.shuffle()
                                lastCorrectAnswer = nil
                                isProcessingAnswer = false
                                incorrectAttemptsForCurrentVocabulary = 0
                            }
                            
                        } else {
                            lastIncorrectAnswer = vocabulary
                            incorrectAttemptsForCurrentVocabulary += 1
                            if !incorrectVocabularies.contains(where: { item in
                                item === currentVocabulary
                            }) {
                                incorrectVocabularies.append(currentVocabulary)
                            }
                          
                        }
                    }
                    
                    .foregroundStyle(
                        answerColor(for: vocabulary)
                    )
                    .disabled(isProcessingAnswer)
                }
            }else if totalVocabularyCount == 0 {
                Text("Keine Vokabeln vorhanden")
            } else {
                Text("Übung abgeschlossen")
            }

            Text("Fehlerhafte Vokabeln: \(incorrectVocabularies.count)")
            Text("Grün: \(correctWithoutErrorsCount)")
            Text("Gelbe: \(correctWithOneErrorCount)")
            Text("Rot:\(correctWithMultipleErrorsCount)")
        }
        .onAppear {
            let shuffledArray = box.vocabularies.shuffled()
            remainingVocabularies = Array(shuffledArray.prefix(10))
            totalVocabularyCount = remainingVocabularies.count
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
    
    private func saveStatistics() {
        box.statisticWithoutErrors += correctWithoutErrorsCount
        box.statisticWithOneError += correctWithOneErrorCount
        box.statisticWithMultipleErrors += correctWithMultipleErrorsCount
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            print(error.localizedDescription)
        }
    }
}

#Preview {
    PracticeView(box: .init(name: "Test"))
}
