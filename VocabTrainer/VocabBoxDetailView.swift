//
//  VocabBoxDetailView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 03.09.26.
//

import SwiftUI

struct VocabBoxDetailView: View {
    let box: VocabBox
    @State private var newEnglishWord: String = ""
    @State private var newGermanWord: String = ""
    var body: some View {
        VStack {
            Text(box.name)
            HStack {
                Text("🇬🇧")
                TextField("Add a new word", text: $newEnglishWord)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
            }
            HStack {
                Text("🇩🇪")
                TextField("Add a new word", text: $newGermanWord)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .onSubmit {addVocabulary()}
            }
            Button("Hinzufügen") {
                addVocabulary()
            }
        }
    }
    private func addVocabulary() {
        print(newEnglishWord, newGermanWord)
    }
}

#Preview {
    let instance = VocabBox(name: "Kapitel 1")
    VocabBoxDetailView(box: instance)
}
