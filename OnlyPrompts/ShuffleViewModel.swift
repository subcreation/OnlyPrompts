//
//  ShuffleViewModel.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 12/26/22.
//

import Foundation

class ShuffleViewModel : ObservableObject {
    @Published var listData = ["one", "two", "three", "four"]

    func shuffle() {
        listData.shuffle()
        //or listData = dictionary.shuffled().prefix(upTo: 10)
    }
}
