//
//  ListVM.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import Combine
import Foundation

internal final class HomeVM {
	
	let useCase: HomeUseCaseProtocol
	
	init(useCase: HomeUseCaseProtocol = HomeUseCase()) {
		self.useCase = useCase
	}
	
	internal enum DataSourceType: Hashable {
		case content(HomeContent)
	}
}

extension HomeVM {
	struct Action {
		let didLoad: AnyPublisher<Void, Never>
		let itemDidSelect: AnyPublisher<IndexPath, Never>
		let getAnimal = PassthroughSubject<String, Never>()
		let getImage = PassthroughSubject<String, Never>()
	}
	
	class State {
		@Published var dataSources: [DataSourceType] = []
		@Published var selected: String = ""
	}
	
	internal func transform(_ action: Action, cancellabels: CancelBag) -> State {
		let state = State()
		
		action.itemDidSelect
			.sink { indexPath in
				if case let .content(animal) = state.dataSources[indexPath.row] {
					state.selected = animal.name
				}
			}
			.store(in: cancellabels)
		
		action.getImage
			.receive(on: DispatchQueue.global(qos: .userInitiated))
			.flatMap {
				self.useCase.getImage(name: $0)
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.receive(on: DispatchQueue.main)
			.sink{ result in
				if case .failure = result {
					
				}
				
				if case let .success(content) = result {
					guard let index = state.dataSources.firstIndex(where: {
						if case let .content(animal) = $0, animal.name == content.name {
							return true
						}
						
						return false
					}) else { return }
					
					if case var .content(animal) = state.dataSources[index] {
						animal.image = content.image
						state.dataSources[index] = .content(animal)
					}
				}
			}
			.store(in: cancellabels)
		
		action.getAnimal
			.receive(on: DispatchQueue.global(qos: .userInitiated))
			.flatMap {
				self.useCase.getAnimal(name: $0)
					.map { Result.success($0) }
					.catch { Just(Result.failure($0)) }
					.eraseToAnyPublisher()
			}
			.receive(on: DispatchQueue.main)
			.sink{ result in
				if case .failure = result {
					
				}
				
				if case let .success(animals) = result {
					state.dataSources.append(contentsOf: animals.map { // N2
						action.getImage.send($0.name)
						return .content($0)
					})
				}
			}
			.store(in: cancellabels)
		
		action.didLoad
			.receive(on: DispatchQueue.global(qos: .userInitiated))
			.sink { [weak self] _ in
				self?.useCase.getPrefixAnimal().forEach {
					action.getAnimal.send($0)
				}
			}
			.store(in: cancellabels)
		return state
	}
}
