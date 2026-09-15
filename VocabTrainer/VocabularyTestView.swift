//
//  VocabularyTestView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 15.09.26.
//

import SwiftUI

struct VocabularyTestView: View {
    let box: VocabBox
    var body: some View {
        Text(box.name)
    }
}

#Preview {
    VocabularyTestView(box: .init(name: "Test"))
}
