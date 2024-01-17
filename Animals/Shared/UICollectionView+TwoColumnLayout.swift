//
//  UICollectionView+TwoColumnLayout.swift
//  Animals
//
//  Created by Santo Michael on 16/01/24.
//

import UIKit

class CustomColumnFlowLayout: UICollectionViewFlowLayout {
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let height: CGFloat
	let totalColumn: CGFloat
	
	init(height: CGFloat, totalColumn: CGFloat) {
		self.height = height
		self.totalColumn = totalColumn
		super.init()
	}
	
	override func prepare() {
		super.prepare()
		
		guard let collectionView = collectionView else { return }
		
		let availableWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
		let itemWidth = (availableWidth - minimumInteritemSpacing) / self.totalColumn
		
		
		if itemWidth.isFinite, itemWidth > 0 {
			minimumInteritemSpacing = 0
			itemSize =  CGSize(width: itemWidth, height: self.height)

		} else {
			itemSize = CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.width / 2)
			minimumInteritemSpacing = 0
		}
		
		minimumLineSpacing = 0
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}

