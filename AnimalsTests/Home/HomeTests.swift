//
//  HomeTests.swift
//  AnimalsTests
//
//  Created by Santo Michael on 18/01/24.
//

import XCTest
import Combine
@testable import Animals

final class HomeVMTests: XCTestCase {
	
	private var viewModel: HomeVM!
	private var useCase: HomeUseCaseProtocol!
	
	private var action: HomeVM.Action!
	private var state: HomeVM.State!
	
	var cancellables: CancelBag!
	let itemDidSelectPublisher = PassthroughSubject<IndexPath, Never>()
	let didLoadPublisher = PassthroughSubject<Void, Never>()

	
	func test_whenDidLoad_shouldGetItems() {
		// Arrange
		useCase = HomeUseCaseMock()
		cancellables = CancelBag()
		viewModel = HomeVM(useCase: useCase)
		action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   itemDidSelect: itemDidSelectPublisher.eraseToAnyPublisher())
		state = viewModel.transform(action, cancellabels: cancellables)
	
		// Act
		didLoadPublisher.send(())
		
		// Assert
		wait {
			XCTAssertEqual(self.state.dataSources.count, 1)
			XCTAssertEqual(self.state.dataSources, [.content(.init(name: "Dog 1", color: "yyyyyy"))])
		}
	}
	
	func test_whenDidSelect_shouldUpdateDataSources() {
		// Arrange
		useCase = HomeUseCaseMock()
		cancellables = CancelBag()
		viewModel = HomeVM(useCase: useCase)
		action = HomeVM.Action(didLoad: didLoadPublisher.eraseToAnyPublisher(),
							   itemDidSelect: itemDidSelectPublisher.eraseToAnyPublisher())
		state = viewModel.transform(action, cancellabels: cancellables)
		
		// Act
		didLoadPublisher.send(())
		wait { self.itemDidSelectPublisher.send(IndexPath(row: 0, section: 0)) }
		
		
		// Assert
		wait {
			XCTAssertEqual(self.state.dataSources.count, 1)
			XCTAssertEqual(self.state.selected, "Dog 1")
		}
	}
}
