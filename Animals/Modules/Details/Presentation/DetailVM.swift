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
	}
	
	class State {
		@Published var dataSources: [DataSourceType] = []
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
			.sink { [weak self] result in
				if case let .failure(error) = result {
					print("~ ERROR: \(error.localizedDescription)")
				}
				if case let .success(images) = result {
					print("~ IMAGES: \(images)")
					state.dataSources = images.map { .content($0) } // N2
				}
			}
			.store(in: cancellables)
		
		return state
	}
}
