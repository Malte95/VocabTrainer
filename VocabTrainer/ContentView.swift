//
//  ContentView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 30.08.26.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingNewBoxSheet = false
    var body: some View {
        VStack {
            HStack {
                Text("Meine Vokabelboxen")
                    .font(.largeTitle)
                Spacer()
                Button {
                    isShowingNewBoxSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            Spacer()
        }
        .padding()
        .sheet(isPresented: $isShowingNewBoxSheet) {
            Text("Neue Vokabelbox")
        }
    }
}

#Preview {
    ContentView()
}
