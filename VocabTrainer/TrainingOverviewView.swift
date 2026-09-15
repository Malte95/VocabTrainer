//
//  TrainingOverviewView.swift
//  VocabTrainer
//
//  Created by Malte Scherenberg on 14.09.26.
//

import SwiftUI
import Charts

enum TrainingTab {
    case practice
    case vocabularyTest
}
struct TrainingOverviewView: View {
    let box: VocabBox
    @State private var selectedTab: TrainingTab = .practice
    var body: some View {
        VStack {
            Text(box.name)
            HStack {
                VStack {
                    Button("Übung"){
                        selectedTab = .practice
                    }
                    .foregroundStyle(selectedTab == .practice
                                     ? Color.orange
                                     : Color.primary)
                    .frame(maxWidth: .infinity)
                    Rectangle()
                        .fill(selectedTab == .practice
                              ? Color.orange
                              : Color.clear)
                        .frame(height: 3)
                }
                
                VStack {
                    Button("Vokabeltest") {
                        selectedTab = .vocabularyTest
                    }
                    .foregroundStyle(selectedTab == .vocabularyTest
                                     ? Color.orange
                                     : Color.primary)
                    .frame(maxWidth: .infinity)
                    Rectangle()
                        .fill(selectedTab == .vocabularyTest
                              ? Color.orange
                              : Color.clear)
                        .frame(height: 3)
                }
            }
            NavigationLink {
                if selectedTab == .practice {
                    PracticeView(box: box)
                } else {
                    VocabularyTestView(box: box)
                }
            } label: {
                Text("STARTEN")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(.orange)
                    .cornerRadius(30)
            }
            Text("Grün: \(box.statisticWithoutErrors)")
            Text("Gelb: \(box.statisticWithOneError)")
            Text("Rot: \(box.statisticWithMultipleErrors)")
            Chart {
                SectorMark (
                    angle: .value("Error-free", box.statisticWithoutErrors),
                    innerRadius: .ratio(0.6)
                )
                .foregroundStyle(.green)
                
                SectorMark (
                    angle: .value("One Error", box.statisticWithOneError),
                    innerRadius: .ratio(0.6)
                )
                .foregroundStyle(.yellow)
                
                SectorMark (
                    angle: .value("Multiple Errors", box.statisticWithMultipleErrors),
                    innerRadius: .ratio(0.6)
                )
                .foregroundStyle(.red)
                
            }
            .frame(width: 220, height: 220)
        }
        
    }
}

#Preview {
    TrainingOverviewView(box: .init(name: "Test"))
}
