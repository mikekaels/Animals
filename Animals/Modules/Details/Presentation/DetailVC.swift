//
//  DetailVC.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import UIKit
import Combine

internal final class DetailVC: UIViewController {
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	enum Section {
		case main
	}
	
	private let viewModel: DetailVM
	private let cancellables = CancelBag()
	private let didLoadPublisher = PassthroughSubject<Void, Never>()
	
	init(viewModel: DetailVM = DetailVM()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		bindViewModel()
		bindView()
		didLoadPublisher.send(())
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.navigationBar.prefersLargeTitles = false
	}
	
	private let collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: CustomColumnFlowLayout(height: 125, totalColumn: 3, contentInterSpacing: 3))
		collection.backgroundColor = UIColor(hex: "1E1C1C")
		collection.register(DetailContentCell.self, forCellWithReuseIdentifier: DetailContentCell.identifier)
		return collection
	}()
	
	private lazy var dataSource: UICollectionViewDiffableDataSource<Section, DetailVM.DataSourceType> = {
		let dataSource = UICollectionViewDiffableDataSource<Section, DetailVM.DataSourceType>(collectionView: collectionView) { [weak self] collectionView, indexPath, type in
			guard let self = self else { return UICollectionViewCell() }
			 
			if case let .content(data) = type, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailContentCell.identifier, for: indexPath) as? DetailContentCell {
				cell.set(image: data.url)
				return cell
			}
			
			return UICollectionViewCell()
		}
		return dataSource
	}()
	
	private func bindViewModel() {
		let action = DetailVM.Action(didLoad: didLoadPublisher)
		let state = viewModel.transform(action, cancellables: cancellables)
		
		state.$dataSources
			.receive(on: DispatchQueue.main)
			.sink { [weak self] contents in
				guard let self = self else { return }
				var snapshoot = NSDiffableDataSourceSnapshot<Section, DetailVM.DataSourceType>()
				snapshoot.appendSections([.main])
				snapshoot.appendItems(contents, toSection: .main)
				self.dataSource.apply(snapshoot, animatingDifferences: true)
			}
			.store(in: cancellables)
	}
	
	private func bindView() {
		
	}
	
	private func setupView() {
		view.backgroundColor = UIColor(hex: "1E1C1C")
		view.addSubview(collectionView)
		
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
