//
//  ListVC.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import UIKit
import Combine
import SnapKit
import CombineCocoa

internal final class HomeVC: UIViewController, UIViewControllerTransitioningDelegate {
	private enum Section {
		case main
	}
	
	private let viewModel: HomeVM
	private let cancellabels = CancelBag()
	private let itemDidSelectedPublisher = PassthroughSubject<IndexPath, Never>()
	var selectedTitleLabel: UILabel?
	
	init(viewModel: HomeVM = HomeVM()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		bindViewModel()
		bindView()
	}
	
	private let collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: CustomColumnFlowLayout(height: 135, totalColumn: 2))
		collection.backgroundColor = UIColor(hex: "1E1C1C")
		collection.register(HomeContentCell.self, forCellWithReuseIdentifier: HomeContentCell.identifier)
		return collection
	}()
	
	private lazy var dataSource: UICollectionViewDiffableDataSource<Section, HomeVM.DataSourceType> = {
		let dataSource = UICollectionViewDiffableDataSource<Section, HomeVM.DataSourceType>(collectionView: collectionView) { [weak self] collectionView, indexPath, type in
			guard let self = self else { return UICollectionViewCell() }
			
			if case let .content(data) = type, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeContentCell.identifier, for: indexPath) as? HomeContentCell {
				cell.set(image: data.image)
				cell.set(title: data.name)
				cell.set(backgroundColor: data.color)
				return cell
			}
			
			return UICollectionViewCell()
		}
		return dataSource
	}()
	
	private func bindViewModel() {
		let action = HomeVM.Action(didLoad: Just(()).eraseToAnyPublisher(),
								   itemDidSelect: itemDidSelectedPublisher.eraseToAnyPublisher()
		)
		let state = viewModel.transform(action, cancellabels: cancellabels)
		
		state.$dataSources
			.receive(on: DispatchQueue.main)
			.sink { [weak self] contents in
				guard let self = self else { return }
				var snapshoot = NSDiffableDataSourceSnapshot<Section, HomeVM.DataSourceType>()
				snapshoot.appendSections([.main])
				snapshoot.appendItems(contents, toSection: .main)
				self.dataSource.apply(snapshoot, animatingDifferences: true)
			}
			.store(in: cancellabels)
		
		state.$selected
			.receive(on: DispatchQueue.main)
			.filter { !$0.isEmpty }
			.sink {  [weak self] animalName in
				guard let self = self else { return }
				let vm = DetailVM(name: animalName)
				let vc = DetailVC(viewModel: vm)
				vc.title = animalName
				self.navigationController?.pushViewController(vc, animated: true)
			}
			.store(in: cancellabels)
	}
	
	private func bindView() {
		collectionView.didSelectItemPublisher
			.sink { [weak self] indexPath in
				self?.itemDidSelectedPublisher.send(indexPath)
			}
			.store(in: cancellabels)
	}
	
	private func setupView() {
		view.backgroundColor = UIColor(hex: "1E1C1C")
		view.addSubview(collectionView)
		
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
