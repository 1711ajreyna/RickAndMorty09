//
//  CharacterDetailView.swift
//  RickAndMorty09
//
//  Created by Andrew Reyna on 7/22/26.
//

import SwiftUI

struct DetailView: View {

    let character: Character

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {

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
                            systemName:
                                "person.crop.square.fill"
                        )
                        .resizable()
                        .scaledToFit()
                        .padding(50)
                        .foregroundStyle(.secondary)

                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(
                    width: 260,
                    height: 260
                )
                .background(
                    Color.gray.opacity(0.15)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 24
                    )
                )

                Text(character.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                VStack(spacing: 0) {

                    detailRow(
                        title: "Name",
                        value: character.name
                    )

                    Divider()

                    detailRow(
                        title: "Status",
                        value: character.status
                    )

                    Divider()

                    detailRow(
                        title: "Species",
                        value: character.species
                    )

                    Divider()

                    detailRow(
                        title: "Gender",
                        value: character.gender
                    )

                    Divider()

                    detailRow(
                        title: "Origin",
                        value: character.origin.name
                    )

                    if !character.type.isEmpty {
                        Divider()

                        detailRow(
                            title: "Type",
                            value: character.type
                        )
                    }
                }
                .background(.thinMaterial)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )
            }
            .padding()
        }
        .navigationTitle("Character Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(
        title: String,
        value: String
    ) -> some View {

        HStack(alignment: .top) {

            Text(title)
                .bold()

            Spacer()

            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        DetailView(
            character: Character(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                type: "",
                gender: "Male",
                image:
                    "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                origin: Origin(
                    name: "Earth (C-137)",
                    url: ""
                )
            )
        )
    }
}
