//
//  CharacterViewModel.swift
//  RickAndMorty09
//
//  Created by Andrew Reyna on 7/22/26.
//

import Foundation
import Combine

// This class manages character data and screen state.
@MainActor
class CharacterViewModel: ObservableObject {

    // Stores the characters returned by the API.
    @Published var characters: [Character] = []

    // Controls the loading indicator.
    @Published var isLoading: Bool = false

    // Stores any error message.
    @Published var errorMessage: String = ""

    // Create one instance of APIService.
    private let apiService = APIService()

    // Calls the service and updates the ViewModel state.
    func fetchCharacters() async {

        isLoading = true
        errorMessage = ""

        // Runs whenever the function finishes.
        defer {
            isLoading = false
        }

        do {
            characters =
                try await apiService.fetchCharacters()

        } catch {
            characters = []
            errorMessage = error.localizedDescription
        }
    }
}
