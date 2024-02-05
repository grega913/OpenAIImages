//
//  ContentView.swift
//  OpenAiImages
//
//  Created by gs on 5. 02. 24.
//

import SwiftUI
import OpenAI


struct ContentView: View {

	//store
	@StateObject private var store = ImageStore(openAIClient: OpenAI(apiToken: OPENAI_API_KEY))

	@State private var prompt: String = ""

    var body: some View {
		VStack {
			List {
				TextField("Prompt", text: $prompt, axis: .vertical)
				// images
				if !$store.images.isEmpty {
					
					ForEach($store.images, id: \.self) { image in
						let urlString = image.wrappedValue.url ?? ""
						if let imageUrl = URL(string:urlString), UIApplication.shared.canOpenURL(imageUrl) {
							LinkPreview(previewURL: imageUrl)
								.aspectRatio(contentMode: .fit)
						} else {
							Text(urlString)
								.foregroundStyle(.secondary)
						}
					}

				} else {
					ContentUnavailableView("No Image", systemImage: "photo.on.rectangle.angled", description:
					Text("Please enter a prompt to create an image"))
				}

			}

		}
		.listStyle(.insetGrouped)
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Create Image") {
					Task {
						let query = ImagesQuery(prompt: prompt, n: 1, size: "512x512")
						await store.images(query: query)
					}
				}
			}
		}
    }
}

