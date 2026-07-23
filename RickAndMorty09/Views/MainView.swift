//
//  CharacterListView.swift
//  RickAndMorty09
//
//  Created by Andrew Reyna on 7/22/26.
//

import SwiftUI

struct MainView: View {

    @StateObject private var viewModel =
        CharacterViewModel()

    var body: some View {
        NavigationStack {
            Group {

                if viewModel.isLoading &&
                    viewModel.characters.isEmpty {

                    ProgressView("Loading characters...")

                } else if
                    !viewModel.errorMessage.isEmpty &&
                    viewModel.characters.isEmpty {

                    errorView

                } else {
                    characterList
                }
            }
            .navigationTitle("Characters")
            .task {
                if viewModel.characters.isEmpty {
                    await viewModel.fetchCharacters()
                }
            }
        }
    }

    private var characterList: some View {
        List(viewModel.characters) { character in

            NavigationLink {
                DetailView(character: character)
            } label: {
                HStack(spacing: 14) {

                    AsyncImage(
                        url: URL(string: character.image)
                    ) { phase in

                        switch phase {

                        case .empty:
                            ProgressView()

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()

                        case .failure:
                            Image(
                                systemName: "person.crop.square"
                            )
                            .resizable()
                            .scaledToFit()
                            .padding()

                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(
                        width: 75,
                        height: 75
                    )
                    .background(
                        Color.gray.opacity(0.15)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 6
                    ) {
                        Text(character.name)
                            .font(.headline)

                        Text(character.species)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 6) {
                            Circle()
                                .fill(
                                    statusColor(
                                        for: character.status
                                    )
                                )
                                .frame(
                                    width: 9,
                                    height: 9
                                )

                            Text(character.status)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.fetchCharacters()
        }
    }

    private var errorView: some View {
        VStack(spacing: 16) {

            Image(
                systemName:
                    "exclamationmark.triangle.fill"
            )
            .font(.system(size: 48))
            .foregroundStyle(.orange)

            Text("Unable to Load Characters")
                .font(.title2)
                .bold()

            Text(viewModel.errorMessage)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task {
                    await viewModel.fetchCharacters()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private func statusColor(
        for status: String
    ) -> Color {

        switch status.lowercased() {

        case "alive":
            return .green

        case "dead":
            return .red

        default:
            return .gray
        }
    }
}

#Preview {
    MainView()
}
