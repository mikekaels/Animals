//
//  DetailUseCase.swift
//  Animals
//
//  Created by Santo Michael on 17/01/24.
//

import Combine
import Networking

internal protocol DetailUseCaseProtocol {
	func getImages(name: String) -> AnyPublisher<[Image], ErrorResponse>
}

internal final class DetailUseCase {
	let imageRepositoy: ImageRepositoryProtocol
	
	init(imageRepositoy: ImageRepositoryProtocol = ImageRepository()) {
		self.imageRepositoy = imageRepositoy
	}
}

extension DetailUseCase: DetailUseCaseProtocol {
	func getImages(name: String) -> AnyPublisher<[Image], ErrorResponse> {
		imageRepositoy.getImages(name: name)
	}
}
