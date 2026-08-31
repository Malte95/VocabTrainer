//
//  ContentView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 30.08.26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "shippingbox.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Meine Vokabelboxen")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
