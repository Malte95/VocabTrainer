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
    @State private var boxPendingDeletion: VocabBox? = nil
    @State private var isShowingDeleteAlert: Bool = false
    @State private var boxPendingEdit: VocabBox? = nil
    @State private var editedBoxName = ""
    @State private var isShowingEditBoxSheet: Bool = false
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
                    Spacer()
                    Button {
                        boxPendingEdit = box
                        editedBoxName = box.name
                        isShowingEditBoxSheet = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                    Button(role: .destructive) {
                        boxPendingDeletion = box
                        isShowingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
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
        .sheet(isPresented: $isShowingEditBoxSheet) {
            VStack {
                Text("Vokabelbox umbenennen")
                TextField("Name der Box", text: $editedBoxName)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                    .onSubmit {
                        renameBox()
                    }
                Button("Speichern") {
                    renameBox()
                }
                .disabled(trimmedEditedBoxName.isEmpty)
            }
            .padding()
        }
        .alert(
            "Vokabelbox löschen?",
            isPresented: $isShowingDeleteAlert,
            presenting: boxPendingDeletion
        ) { box in
            Button("Löschen", role: .destructive) {
                deleteBox(box)
            }
            Button("Abbrechen", role: .cancel) {
    
            }
        } message: { box in
            Text("Möchtest du die Vokabelbox „\(box.name)“ wirklich löschen?")
        }
    }
    private var trimmedBoxName: String {
        newBoxName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    private var trimmedEditedBoxName: String {
        editedBoxName.trimmingCharacters(in: .whitespacesAndNewlines)
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
    
    private func deleteBox(_ box: VocabBox) {
        do {
            modelContext.delete(box)
            try modelContext.save()
        } catch {
            modelContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    private func renameBox() {
        guard let box = boxPendingEdit else { return }
        guard !trimmedEditedBoxName.isEmpty else { return }
        do {
            box.name = trimmedEditedBoxName
            try modelContext.save()
            editedBoxName = ""
            boxPendingEdit = nil
            isShowingEditBoxSheet = false
        } catch {
            modelContext.rollback()
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
