//
//  AnimalRepository.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Networking
import Combine

internal protocol AnimalRepositoryProtocol {
	func getAnimal(name: String, numOfAnimal: Int) -> AnyPublisher<[HomeContent], ErrorResponse>
}

internal final class AnimalRepository {
	let network: NetworkingProtocol
	
	init(network: NetworkingProtocol = Networking()) {
		self.network = network
	}
}

extension AnimalRepository: AnimalRepositoryProtocol {
	func getAnimal(name: String, numOfAnimal: Int) -> AnyPublisher<[HomeContent], ErrorResponse> {
		let apiRequest = AnimalRequest(animalName: name, numOfAnimal: numOfAnimal)
		let result = network.request(apiRequest)
		return result.asPublisher
	}
}
