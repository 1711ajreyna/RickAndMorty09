//
//  CharacterModel.swift
//  RickAndMorty09
//
//  Created by Andrew Reyna.
//

import Foundation

// Represents the top-level JSON response.
//
// The API response looks like:
//
// {
//     "info": { ... },
//     "results": [
//         { character },
//         { character }
//     ]
// }
//
// We only need "results" for this assignment.
// Codable ignores the unused "info" object.
struct CharacterResponse: Codable {

    // The API returns an array of Character objects,
    // not an array of Strings.
    let results: [Character]
}

// Represents one character inside the results array.
struct Character: Codable, Identifiable {

    // Identifiable uses this property to distinguish
    // characters in a SwiftUI List or ForEach.
    let id: Int

    let name: String
    let status: String
    let species: String

    // Some characters have an empty type,
    // but the API still returns a String.
    let type: String

    let gender: String

    // The API returns this as an image URL string.
    let image: String

    // Origin is a nested JSON object,
    // so it needs its own Swift model.
    let origin: Origin
}
