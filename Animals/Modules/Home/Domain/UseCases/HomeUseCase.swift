//
//  HomeUseCase.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Networking
import Combine

internal protocol HomeUseCaseProtocol {
	func getAnimal(name: String) -> AnyPublisher<[HomeContent], ErrorResponse>
	func getImage(name: String) -> AnyPublisher<Image, ErrorResponse>
	func getPrefixAnimal() -> [String]
}

internal final class HomeUseCase {
	let animalRepository: AnimalRepositoryProtocol
	let imageRepository: ImageRepositoryProtocol
	
	let numberOfAnimalEachOfCategory = 4
	
	init(animalRepository: AnimalRepositoryProtocol = AnimalRepository(),
		 imageRepository: ImageRepositoryProtocol = ImageRepository()
	) {
		self.animalRepository = animalRepository
		self.imageRepository = imageRepository
	}
}

extension HomeUseCase: HomeUseCaseProtocol {
	func getAnimal(name: String) -> AnyPublisher<[HomeContent], ErrorResponse> {
		animalRepository.getAnimal(name: name, numOfAnimal: numberOfAnimalEachOfCategory)
	}
	
	func getImage(name: String) -> AnyPublisher<Image, ErrorResponse> {
		imageRepository.getImage(name: name)
	}
	
	func getPrefixAnimal() -> [String] {
		["Elephant", "Lion", "Fox", "Dog", "Shark", "Turtle", "Whale", "Penguin"]
	}
}
