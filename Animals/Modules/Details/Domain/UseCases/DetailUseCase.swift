//
//  DetailUseCase.swift
//  Animals
//
//  Created by Santo Michael on 17/01/24.
//

import Combine
import Networking

internal protocol DetailUseCaseProtocol {
	func getImages(name: String, page: Int, perPage: Int) -> AnyPublisher<[ImageEntity], ErrorResponse>
	func imageLiked(image: ImageEntity) -> AnyPublisher<Bool, Error>
	func getFavorites() -> AnyPublisher<[ImageEntity], Error>
	func checkLikeStatus(image: String) -> Bool
	func dislikeImage(image: String) -> AnyPublisher<Bool, Error>
}

internal final class DetailUseCase {
	let imageRepositoy: ImageRepositoryProtocol
	let imageCoreData: ImageCoreDataRepositoryProtocol
	
	init(imageRepositoy: ImageRepositoryProtocol = ImageRepository(),
		 imageCoreData: ImageCoreDataRepositoryProtocol = ImageCoreDataRepository()) {
		self.imageRepositoy = imageRepositoy
		self.imageCoreData = imageCoreData
	}
}

extension DetailUseCase: DetailUseCaseProtocol {
	func dislikeImage(image: String) -> AnyPublisher<Bool, Error> {
		imageCoreData.delete(image: image)
	}
	
	func checkLikeStatus(image: String) -> Bool {
		imageCoreData.checkLikeStatusBy(image: image)
	}
	
	func getFavorites() -> AnyPublisher<[ImageEntity], Error> {
		imageCoreData.getAll()
	}
	
	func imageLiked(image: ImageEntity) -> AnyPublisher<Bool, Error> {
		imageCoreData.create(image: image)
	}
	
	func getImages(name: String, page: Int, perPage: Int) -> AnyPublisher<[ImageEntity], ErrorResponse> {
		imageRepositoy.getImages(name: name, page: page, perPage: perPage)
	}
}
