//
//  ImageRepository.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Networking
import Combine

internal protocol ImageRepositoryProtocol {
	func getImage(name: String) -> AnyPublisher<ImageEntity, ErrorResponse>
	func getImages(name: String, page: Int, perPage: Int) -> AnyPublisher<[ImageEntity], ErrorResponse>
}

internal final class ImageRepository {
	let network: NetworkingProtocol
	
	init(network: NetworkingProtocol = Networking()) {
		self.network = network
	}
}

extension ImageRepository: ImageRepositoryProtocol {
	func getImage(name: String) -> AnyPublisher<ImageEntity, ErrorResponse> {
		let apiRequest = ImageRequest(animalName: name)
		let result = network.request(apiRequest)
		return result.asPublisher
	}
	
	func getImages(name: String, page: Int, perPage: Int) -> AnyPublisher<[ImageEntity], ErrorResponse> {
		let apiRequest = ImagesRequest(animalName: name, page: page, perPage: perPage)
		let result = network.request(apiRequest)
		return result.asPublisher
	}
}

