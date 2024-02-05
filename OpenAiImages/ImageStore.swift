//
//  ImageStore.swift
//  OpenAiImages
//
//  Created by gs on 5. 02. 24.
//

import Foundation
import OpenAI

class ImageStore: ObservableObject {

	var openAIClient: OpenAIProtocol

	@Published var images: [ImagesResult.URLResult] = []

	init(openAIClient: OpenAIProtocol) {
		self.openAIClient = openAIClient
	}


	@MainActor
	func images(query: ImagesQuery) async {
		images.removeAll()

		do {
			
			let response = try await openAIClient.images(query: query)
			images = response.data

		} catch {
			print(error.localizedDescription)
		}
	}

}
