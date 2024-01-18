//
//  DetailVC.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit
import Kingfisher

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
	private let rightBarButtonDidTapPublisher = PassthroughSubject<Void, Never>()
	private let doubleTapPublisher = PassthroughSubject<String, Never>()
	private let loadMorePublisher = PassthroughSubject<Void, Never>()
	
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
		
		let rightButton = UIBarButtonItem(image: .init(systemName: "rectangle.split.1x2"), style: .plain, target: self, action: #selector(updateColumnFlowLayout ))
		rightButton.tintColor = .white
		navigationItem.rightBarButtonItem = rightButton
	}
	
	@objc private func updateColumnFlowLayout() {
		rightBarButtonDidTapPublisher.send(())
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.navigationBar.prefersLargeTitles = false
	}
	
	private let loadMoreLoadingView: UIActivityIndicatorView = {
		let loadMore = UIActivityIndicatorView(style: .large)
		loadMore.color = UIColor(hex: "FE1F44")
		loadMore.startAnimating()
		loadMore.isHidden = true
		return loadMore
	}()
	
	private let collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: CustomColumnFlowLayout(height: 125, totalColumn: 3, contentInterSpacing: 3))
		collection.backgroundColor = UIColor(hex: "1E1C1C")
		collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
		
		collection.register(DetailContentCell.self, forCellWithReuseIdentifier: DetailContentCell.identifier)
		return collection
	}()
	
	private lazy var dataSource: UICollectionViewDiffableDataSource<Section, DetailVM.DataSourceType> = {
		let dataSource = UICollectionViewDiffableDataSource<Section, DetailVM.DataSourceType>(collectionView: collectionView) { [weak self] collectionView, indexPath, type in
			 
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
		let action = DetailVM.Action(didLoad: didLoadPublisher, 
									 rightBarButtonDidTap: rightBarButtonDidTapPublisher.eraseToAnyPublisher(),
									 doubleTap: doubleTapPublisher.eraseToAnyPublisher(),
									 loadMore: loadMorePublisher.eraseToAnyPublisher())
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
		
		Publishers.CombineLatest3(state.$column, state.$rightBarButtonImage, state.$cellHeight)
			.sink { [weak self] (column, rightBarButtonImage, height) in
				self?.navigationItem.rightBarButtonItem?.image = UIImage(systemName: rightBarButtonImage)
				self?.collectionView.collectionViewLayout = CustomColumnFlowLayout(height: height, totalColumn: CGFloat(column), contentInterSpacing: 3)
				self?.collectionView.reloadData()
			}
			.store(in: cancellables)
		
		state.$isLoadMore
			.sink { [weak self] isLoading in
				self?.loadMoreLoadingView.isHidden = isLoading ? false : true
			}
			.store(in: cancellables)
	}
	
	private func bindView() {
		collectionView.reachedBottomPublisher()
			.sink { [weak self] _ in
				self?.loadMorePublisher.send(())
			}
			.store(in: cancellables)
	}
	
	private func setupView() {
		view.backgroundColor = UIColor(hex: "1E1C1C")
		view.addSubview(collectionView)
		
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		view.addSubview(loadMoreLoadingView)
		loadMoreLoadingView.snp.makeConstraints { make in
			make.size.equalTo(100)
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
}
