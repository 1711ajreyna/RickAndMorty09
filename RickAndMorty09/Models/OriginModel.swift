//
//  OriginModel.swift
//  RickAndMorty09
//
//  Created by Andrew Reyna on 7/22/26.
//

import Foundation

// Represents the nested origin object
// returned for each character.
struct Origin: Codable {
    let name: String
    let url: String
}
