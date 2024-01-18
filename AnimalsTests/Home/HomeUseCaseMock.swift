//
//  HomeUseCaseMock.swift
//  AnimalsTests
//
//  Created by Santo Michael on 18/01/24.
//

@testable import Animals
@testable import Networking
import Combine

final class HomeUseCaseMock: HomeUseCaseProtocol {
	var getAnimalCalled = false
	var getImageCalled = false
	var getPrefixAnimalCalled = false
	
	func getAnimal(name: String) -> AnyPublisher<[HomeContent], ErrorResponse> {
		getAnimalCalled = true
		return Future<[HomeContent], ErrorResponse> { promise in
			let contents = [
				HomeContent(name: "Dog 1", color: "yyyyyy")
			]
			promise(.success(contents))
		}.eraseToAnyPublisher()
	}
	
	
	func getImage(name: String) -> AnyPublisher<Image, ErrorResponse> {
		getImageCalled = true
		return Future<Image, ErrorResponse> { promise in
			promise(.success(Image(name: "Dog", image: "dog mock")))
		}.eraseToAnyPublisher()
	}
	
	func getPrefixAnimal() -> [String] {
		getPrefixAnimalCalled = true
		return ["Dog"]
	}
}

