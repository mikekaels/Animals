//
//  DetailVC.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import UIKit

internal final class DetailVC: UIViewController {
	
	enum Section {
		case main
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		bindViewModel()
		bindView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		navigationController?.navigationBar.prefersLargeTitles = false
	}
	
	private let collectionView: UICollectionView = {
		let collection = UICollectionView(frame: .zero, collectionViewLayout: CustomColumnFlowLayout(height: 135, totalColumn: 3))
		collection.backgroundColor = UIColor(hex: "1E1C1C")
		
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
		
	}
	
	private func bindView() {
		
	}
	
	private func setupView() {
		view.backgroundColor = UIColor(hex: "1E1C1C")
	}
}
