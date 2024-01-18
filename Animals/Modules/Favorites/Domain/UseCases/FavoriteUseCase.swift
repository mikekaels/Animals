//
//  FavoriteUseCase.swift
//  Animals
//
//  Created by Santo Michael on 18/01/24.
//

import Combine

internal protocol FavoriteUseCaseProtocol {
	func getImages() -> AnyPublisher<[Image], Error>
	func delete(image: String) -> AnyPublisher<Bool, Error>
}

internal final class FavoriteUseCase {
	let imageCoreData: ImageCoreDataRepositoryProtocol
	
	init(imageCoreData: ImageCoreDataRepositoryProtocol = ImageCoreDataRepository()) {
		self.imageCoreData = imageCoreData
	}
}

extension FavoriteUseCase: FavoriteUseCaseProtocol {
	func delete(image: String) -> AnyPublisher<Bool, Error> {
		imageCoreData.delete(image: image)
	}
	
	func getImages() -> AnyPublisher<[Image], Error> {
		imageCoreData.getAll()
	}
}
