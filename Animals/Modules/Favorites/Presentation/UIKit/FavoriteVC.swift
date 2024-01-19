//
//  FavoriteVC.swift
//  Animals
//
//  Created by Santo Michael on 18/01/24.
//

import UIKit
import Combine

internal final class FavoriteVC: UIViewController {
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	enum Section {
		case main
	}
	
	private let viewModel: FavoriteVM
	private let cancellables = CancelBag()
	private let doubleTapPublisher = PassthroughSubject<String, Never>()
	private let willAppearPublisher = PassthroughSubject<Void, Never>()
	
	init(viewModel: FavoriteVM = FavoriteVM()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		bindViewModel()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		willAppearPublisher.send(())
	}
	
	private let collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: CustomColumnFlowLayout(height: 125, totalColumn: 3, contentInterSpacing: 3))
		collection.backgroundColor = UIColor(hex: "1E1C1C")
		collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
		
		collection.register(DetailContentCell.self, forCellWithReuseIdentifier: DetailContentCell.identifier)
		collection.alwaysBounceVertical = true
		return collection
	}()
	
	private lazy var dataSource: UICollectionViewDiffableDataSource<Section, FavoriteVM.DataSourceType> = {
		let dataSource = UICollectionViewDiffableDataSource<Section, FavoriteVM.DataSourceType>(collectionView: collectionView) { [weak self] collectionView, indexPath, type in
			
			if case let .content(data) = type, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailContentCell.identifier, for: indexPath) as? DetailContentCell {
				cell.set(image: data.image)
				cell.set(isLiked: data.isLiked)
				cell.doubleTapPublisher
					.sink { _ in
						self?.doubleTapPublisher.send(data.image)
					}
					.store(in: cell.cancellabels)
				return cell
			}
			
			return UICollectionViewCell()
		}
		return dataSource
	}()
	
	private func bindViewModel() {
		let action = FavoriteVM.Action(willAppear: willAppearPublisher, 
									   dislikeImage: doubleTapPublisher.eraseToAnyPublisher())
		let state = viewModel.transform(action, cancellables: cancellables)
		
		state.$dataSource
			.sink { [weak self] contents in
				guard let self = self else { return }
				var snapshoot = NSDiffableDataSourceSnapshot<Section, FavoriteVM.DataSourceType>()
				snapshoot.appendSections([.main])
				snapshoot.appendItems(contents, toSection: .main)
				self.dataSource.apply(snapshoot, animatingDifferences: true)
			}
			.store(in: cancellables)
	}
	
	private func setupView() {
		view.backgroundColor = UIColor(hex: "1E1C1C")
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
