//
//  CharacterService.swift
//  RickAndMorty09
//
//  Created by Andrew Reyna on 7/22/26.
//

import Foundation

// Describes the possible errors that can happen
// while calling or decoding the API.
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingError
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."

        case .invalidResponse:
            return "The server returned an invalid response."

        case .badStatusCode(let statusCode):
            return "The request failed with status code \(statusCode)."

        case .decodingError:
            return "The character data could not be decoded."

        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

// This class contains the logic used to call
// the Rick and Morty REST API.
class APIService {

    private let endpoint =
        "https://rickandmortyapi.com/api/character"

    // Fetches and returns the character array.
    func fetchCharacters() async throws -> [Character] {

        // Convert the endpoint String into a URL.
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }

        do {
            // Call the API and wait for the response.
            let (data, response) =
                try await URLSession.shared.data(from: url)

            // URLSession gives us a general URLResponse.
            // Convert it to HTTPURLResponse so we can
            // inspect the status code.
            guard let httpResponse =
                    response as? HTTPURLResponse else {

                throw APIError.invalidResponse
            }

            // Check for a successful status code.
            guard (200...299).contains(
                httpResponse.statusCode
            ) else {
                throw APIError.badStatusCode(
                    httpResponse.statusCode
                )
            }

            do {
                // Decode the outside CharacterResponse object.
                let decodedResponse =
                    try JSONDecoder().decode(
                        CharacterResponse.self,
                        from: data
                    )

                // Return only the characters inside results.
                return decodedResponse.results

            } catch {
                print("Decoding error: \(error)")

                if let json = String(
                    data: data,
                    encoding: .utf8
                ) {
                    print("JSON: \(json.prefix(500))")
                }

                throw APIError.decodingError
            }

        } catch let apiError as APIError {
            // Preserve the specific API error.
            throw apiError

        } catch {
            print("Unknown error: \(error)")
            throw APIError.unknownError
        }
    }
}
