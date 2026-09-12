//
//  VocabBoxDetailView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 03.09.26.
//

import SwiftUI
import SwiftData

struct VocabBoxDetailView: View {
    let box: VocabBox
    @State private var newEnglishWord: String = ""
    @State private var newGermanWord: String = ""
    @State private var vocabularyPendingEdit: Vocabulary? = nil
    @State private var editedEnglishWord = ""
    @State private var editedGermanWord = ""
    @State private var isShowingEditVocabularySheet: Bool = false
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        VStack {
            Text(box.name)
            NavigationLink("Üben"){
                PracticeView(box: box)
            }
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
            .disabled(trimmedEnglishWord.isEmpty || trimmedGermanWord.isEmpty)
            
            HStack {
                Text("🇬🇧").frame(maxWidth: .infinity)
                Text("🇩🇪").frame(maxWidth: .infinity)
            }
            
            List(box.vocabularies) { vocabulary in
                HStack {
                    Text(vocabulary.english)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(vocabulary.german)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        deleteVocabulary(vocabulary)
                    } label: {
                        Image(systemName: "trash")
                        
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        vocabularyPendingEdit = vocabulary
                        editedEnglishWord = vocabulary.english
                        editedGermanWord = vocabulary.german
                        isShowingEditVocabularySheet = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
            }
            .listStyle(.plain)
        }
        .sheet(isPresented: $isShowingEditVocabularySheet){
            VStack {
                Text("Vokabel bearbeiten")
                HStack {
                    Text("🇬🇧")
                    TextField("Englisches Wort", text: $editedEnglishWord)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                    
                }
                HStack {
                    Text("🇩🇪")
                    TextField("Deutsches Wort", text: $editedGermanWord)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                }
                Button ("Speichern") {
                    updateVocabulary()
                }
                .disabled(trimmedEditedEnglishWord.isEmpty || trimmedEditedGermanWord.isEmpty)
            }
        }
    }
        
    private var trimmedEnglishWord : String {
        newEnglishWord.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var trimmedGermanWord : String {
        newGermanWord.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var trimmedEditedEnglishWord : String {
        editedEnglishWord.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var trimmedEditedGermanWord : String {
        editedGermanWord.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    private func addVocabulary() {
        guard !trimmedEnglishWord.isEmpty,
              !trimmedGermanWord.isEmpty else { return }
        let newVocabulary = Vocabulary(english: trimmedEnglishWord, german: trimmedGermanWord)
        do {
            box.vocabularies.append(newVocabulary)
            try modelContext.save()
            newEnglishWord = ""
            newGermanWord = ""
        } catch {
            modelContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    private func deleteVocabulary(_ vocabulary: Vocabulary) {
        do { modelContext.delete(vocabulary)
            try modelContext.save()
        } catch { modelContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    private func updateVocabulary() {
        guard let vocabulary = vocabularyPendingEdit else { return }
        guard !trimmedEditedEnglishWord.isEmpty,
              !trimmedEditedGermanWord.isEmpty else { return }
        do {
            vocabulary.english = trimmedEditedEnglishWord
            vocabulary.german = trimmedEditedGermanWord
            try modelContext.save()
            editedEnglishWord = ""
            editedGermanWord = ""
            vocabularyPendingEdit = nil
            isShowingEditVocabularySheet = false
        } catch {
            modelContext.rollback()
            print(error.localizedDescription)
        }
        
    }
       
}

#Preview {
    let instance = VocabBox(name: "Kapitel 1")
    VocabBoxDetailView(box: instance)
}
