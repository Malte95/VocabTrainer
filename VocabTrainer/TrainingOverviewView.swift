//
//  TrainingOverviewView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 14.09.26.
//

import SwiftUI

struct TrainingOverviewView: View {
    let box: VocabBox
    var body: some View {
        Text(box.name)
    }
}

#Preview {
    TrainingOverviewView(box: .init(name: "Test"))
}
