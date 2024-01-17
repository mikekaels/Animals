//
//  ImageRepository.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Networking
import Combine

internal protocol ImageRepositoryProtocol {
	func getImage(name: String) -> AnyPublisher<Image, ErrorResponse>
}

internal final class ImageRepository {
	let network: NetworkingProtocol
	
	init(network: NetworkingProtocol = Networking()) {
		self.network = network
	}
}

extension ImageRepository: ImageRepositoryProtocol {
	func getImage(name: String) -> AnyPublisher<Image, ErrorResponse> {
		let apiRequest = ImageRequest(animalName: name)
		let result = network.request(apiRequest)
		return result.asPublisher
	}
}

