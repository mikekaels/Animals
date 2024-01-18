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
		let loadMore: AnyPublisher<Void, Never>
		let saveImageToLocal = PassthroughSubject<Image, Never>()
		let dislikeImage = PassthroughSubject<Image, Never>()
	}
	
	class State {
		@Published var dataSources: [DataSourceType] = []
		@Published var column: Int = 3
		@Published var cellHeight: CGFloat = 125
		@Published var rightBarButtonImage: String = "rectangle.split.3x3"
		@Published var page: Int = 1
		@Published var perPage: Int = 18
		@Published var isLoadMore: Bool = false
	}
	
	internal func transform(_ action: Action, cancellables: CancelBag) -> State {
		let state = State()
		
		action.didLoad
			.receive(on: DispatchQueue.global(qos: .userInitiated))
			.flatMap {
				self.useCase.getImages(name: self.name, page: state.page, perPage: state.perPage)
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.receive(on: DispatchQueue.main)
			.sink { [weak self] result in
				guard let self = self else { return }
				if case let .failure(error) = result {
					print("~ ERROR: \(error.localizedDescription)")
				}
				if case let .success(images) = result {
					if state.dataSources.isEmpty {
						state.dataSources = images.map {
							var image = $0
							image.isLiked = self.useCase.checkLikeStatus(image: image.image)
							return .content(image)
						}
					} else {
						let images: [DataSourceType] = images.map {
							var image = $0
							image.isLiked = self.useCase.checkLikeStatus(image: image.image)
							return .content(image)
						}
						state.dataSources.append(contentsOf: images)
					}
				}
				
				state.isLoadMore = false
			}
			.store(in: cancellables)
		
		action.doubleTap
			.sink { imageTapped in
				guard let index = state.dataSources.firstIndex(where: {
					if case let .content(content) = $0, content.image == imageTapped {
						return true
					}
					
					return false
				}) else { return }
				
				if case var .content(image) = state.dataSources[index] {
					image.isLiked.toggle()
					if !image.isLiked {
						action.dislikeImage.send(image)
					} else {
						action.saveImageToLocal.send(image)
					}
					state.dataSources[index] = .content(image)
					
				}
			}
			.store(in: cancellables)
		
		action.saveImageToLocal
			.receive(on: DispatchQueue.global(qos: .userInitiated))
			.flatMap {
				self.useCase.imageLiked(image: $0)
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { result in
				if case let .failure(error) = result {
					print("~ IS ERROR: ", error)
				}
				if case let .success(isSuccess) = result {
					print("~ IS SUCCESS: ", isSuccess)
				}
			}
			.store(in: cancellables)
		
		action.dislikeImage
			.flatMap {
				self.useCase.dislikeImage(image: $0.image)
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { result in
				if case let .failure(error) = result {
					
				}
				
				if case let .success(isDeleted) = result {
					print("~ IS DELETED", isDeleted)
				}
			}
			.store(in: cancellables)
			
		
		action.rightBarButtonDidTap
			.sink { _ in
				if state.column == 3 {
					state.column = 2
					state.rightBarButtonImage = "rectangle"
				} else if state.column == 2 {
					state.column = 3
					state.rightBarButtonImage = "rectangle.split.3x3"
				}
			}
			.store(in: cancellables)
		
		action.loadMore
			.sink { _ in
				state.isLoadMore = true
				state.page += 1
				action.didLoad.send(())
			}
			.store(in: cancellables)
		
		return state
	}
}
