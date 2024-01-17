//
//  DetailContentCell.swift
//  Animals
//
//  Created by Santo Michael on 17/01/24.
//

import UIKit
import Kingfisher
import SnapKit
import Combine

internal final class DetailContentCell: UICollectionViewCell {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	private let imageView: UIImageView = {
		let image = UIImageView()
		image.contentMode = .scaleAspectFill
		image.layer.masksToBounds = true
		return image
	}()
	
	private let loveIconView: UIImageView = {
		let image = UIImageView()
		image.image = UIImage(systemName: "heart.fill")
		image.tintColor = .white
		image.alpha = 0.0
		image.contentMode = .scaleAspectFit
		image.layer.masksToBounds = true
		return image
	}()
	
	private func setupView() {
		contentView.backgroundColor = .clear
		
		[imageView, loveIconView].forEach { contentView.addSubview($0) }
		imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		loveIconView.snp.makeConstraints { make in
			make.size.equalTo(50)
			make.center.equalToSuperview()
		}
		
		handleGesture()
	}
	
	private func handleGesture() {
		// Single Tap
		let singleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
		singleTap.numberOfTapsRequired = 1
		self.contentView.addGestureRecognizer(singleTap)
		
		// Double Tap
		let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
		doubleTap.numberOfTapsRequired = 2
		self.contentView.addGestureRecognizer(doubleTap)
		
		singleTap.require(toFail: doubleTap)
		singleTap.delaysTouchesBegan = true
		doubleTap.delaysTouchesBegan = true
	}
	
	@objc func handleSingleTap(sender: AnyObject?) {
		print("~ Single Tap!")
	}
	
	@objc func handleDoubleTap() {
		UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: .calculationModeCubic, animations: { [weak self] in
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
				self?.loveIconView.alpha = 0.5
			}
			
			UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
				self?.loveIconView.alpha = 1.0
			}
			
			UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.25) {
				self?.loveIconView.alpha = 0.1
			}
			
			UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0.25) {
				self?.loveIconView.alpha = 0.0
			}
		})
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension DetailContentCell {
	internal func set(image: String) {
		if let url = URL(string: image) {
			self.imageView.kf.setImage(with: url, options: [
				.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 70))),
				.scaleFactor(UIScreen.main.scale),
				.forceRefresh,
				.transition(.flipFromBottom(0.8))
			]) { result in
				switch result {
				case let .success(imageResult):
					
					break
				case let .failure(error):
					break
				}
			}
		}
	}
}

