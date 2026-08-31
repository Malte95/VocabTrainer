//
//  ContentView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 30.08.26.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingNewBoxSheet = false
    @State private var newBoxName = ""
    var body: some View {
        VStack {
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
        print(trimmedBoxName)
        newBoxName = ""
        isShowingNewBoxSheet = false
    }
}

#Preview {
    ContentView()
}
