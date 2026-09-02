//
//  ContentView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 30.08.26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingNewBoxSheet = false
    @State private var newBoxName = ""
    @Query private var vocabBoxes: [VocabBox]
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Meine Vokabelboxen")
                    .font(.largeTitle)
                Spacer()
                Button {
                    newBoxName = ""
                    isShowingNewBoxSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            ForEach(vocabBoxes) { box in
                HStack {
                    Image(systemName: "rectangle.stack")
                    Text(box.name)
                }
            }
            Spacer()
        }
        .padding()
        .sheet(isPresented: $isShowingNewBoxSheet) {
            VStack {
                Text("Neue Vokabelbox")
                TextField("Name der Box", text: $newBoxName)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                    .onSubmit {
                        createBox()
                    }
                Button("Erstellen") {
                    createBox()
                }
                .disabled(trimmedBoxName.isEmpty)
                
            }
            .padding()
        }
    }
    private var trimmedBoxName: String {
        newBoxName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func createBox() {
        guard !trimmedBoxName.isEmpty else { return }
        let newBox = VocabBox(name: trimmedBoxName)
        do {
            modelContext.insert(newBox)
            try modelContext.save()
            newBoxName = ""
            isShowingNewBoxSheet = false
        } catch {
            modelContext.rollback()
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
