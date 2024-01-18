//
//  FavoriteVM.swift
//  Animals
//
//  Created by Santo Michael on 18/01/24.
//

import Combine

internal final class FavoriteVM {
	let useCase: FavoriteUseCaseProtocol
	
	init(useCase: FavoriteUseCaseProtocol = FavoriteUseCase()) {
		self.useCase = useCase
	}
	
	enum DataSourceType: Hashable {
		case content(Image)
	}
}

extension FavoriteVM {
	struct Action {
		let willAppear: PassthroughSubject<Void, Never>
		let dislikeImage: AnyPublisher<String, Never>
	}
	
	class State {
		@Published var dataSource: [DataSourceType] = []
	}
	
	internal func transform(_ action: Action, cancellables: CancelBag) -> State {
		let state = State()
		
		action.dislikeImage
			.flatMap {
				self.useCase.delete(image: $0)
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { result in
				if case .success = result {
					action.willAppear.send(())
				}
			}
			.store(in: cancellables)
		
		action.willAppear
			.flatMap {
				self.useCase.getImages()
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.sink { result in
				if case .failure = result {
					
				}
				
				if case let .success(images) = result {
					state.dataSource = images.map { .content($0) }
				}
			}
			.store(in: cancellables)
		
		return state
	}
}
