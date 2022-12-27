//
//  ModelData.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 12/26/22.
//

import Foundation

/* old, local json implementation
var prompts: [Prompt] = load("promptData.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
 */


var cd_artPrompts: CDArtPrompts = loadArtPrompts()

func loadArtPrompts() -> CDArtPrompts {
    print("*** loadArtPrompts")
    let loadCDArtPrompts = CDArtPrompts()
    CKPrompt.fetchArt { (results) in
        print("+++ CKPrompt.fetch")
        switch results {
        case .success(let newPrompts):
            print("+++ success")
            loadCDArtPrompts.lists = newPrompts
        case .failure(let error):
            print("+++ failure")
            print(error)
        }
    }
    return loadCDArtPrompts
}
