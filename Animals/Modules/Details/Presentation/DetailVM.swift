//
//  DetailVM.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Combine
import Foundation

internal final class DetailVM {
	let useCase: DetailUseCaseProtocol
	let name: String
	
	init(useCase: DetailUseCaseProtocol = DetailUseCase(), name: String = "") {
		self.useCase = useCase
		self.name = name
	}
	
	enum DataSourceType: Hashable {
		case content(Image)
	}
}

extension DetailVM {
	struct Action {
		let didLoad: PassthroughSubject<Void, Never>
		let rightBarButtonDidTap: AnyPublisher<Void, Never>
		let doubleTap: AnyPublisher<String, Never>
	}
	
	class State {
		@Published var dataSources: [DataSourceType] = []
		@Published var column: Int = 3
		@Published var cellHeight: CGFloat = 125
		@Published var rightBarButtonImage: String = "rectangle.split.3x3"
	}
	
	internal func transform(_ action: Action, cancellables: CancelBag) -> State {
		let state = State()
		
		action.didLoad
			.receive(on: DispatchQueue.global(qos: .userInitiated))
			.flatMap {
				self.useCase.getImages(name: self.name)
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.receive(on: DispatchQueue.main)
			.sink { result in
				if case let .failure(error) = result {
					print("~ ERROR: \(error.localizedDescription)")
				}
				if case let .success(images) = result {
					print("~ IMAGES: \(images)")
					state.dataSources = images.map { .content($0) } // N2
				}
			}
			.store(in: cancellables)
		
		action.doubleTap
			.sink { imageTinyURL in
				guard let index = state.dataSources.firstIndex(where: {
					if case let .content(image) = $0, image.url.tiny == imageTinyURL {
						return true
					}
					
					return false
				}) else { return }
				
				if case var .content(image) = state.dataSources[index] {
					image.isLiked.toggle()
					state.dataSources[index] = .content(image)
				}
			}
			.store(in: cancellables)
		
		action.rightBarButtonDidTap
			.sink { _ in
				if state.column == 3 {
					state.column = 2
					state.rightBarButtonImage = "rectangle"
					state.cellHeight = 125
					state.dataSources = state.dataSources.map {
						if case var .content(image) = $0 {
							image.showedImage = image.url.tiny
							return .content(image)
						}
						return nil
					}.compactMap { $0 }
					
				} else if state.column == 2 {
					state.column = 1
					state.rightBarButtonImage = "rectangle.split.3x3"
					state.cellHeight = 220
					state.dataSources = state.dataSources.map {
						if case var .content(image) = $0 {
							image.showedImage = image.url.large
							return .content(image)
						}
						return nil
					}.compactMap { $0 }
					
				} else if state.column == 1 {
					state.column = 3
					state.rightBarButtonImage = "rectangle.split.1x2"
					state.cellHeight = 125
					state.dataSources = state.dataSources.map {
						guard case var .content(image) = $0 else { return nil }
						image.showedImage = image.url.tiny
						return .content(image)
						
					}.compactMap { $0 }
				}
			}
			.store(in: cancellables)
		
		return state
	}
}
