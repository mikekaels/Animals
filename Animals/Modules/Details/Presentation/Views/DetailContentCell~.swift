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
	
	internal let cancellabels = CancelBag()
	internal var doubleTapPublisher = PassthroughSubject<Void, Never>()
	private var isLiked = false
	
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
	
	override func prepareForReuse() {
		super.prepareForReuse()
		doubleTapPublisher = PassthroughSubject<Void, Never>()
	}
	
	private func setupView() {
		[imageView, loveIconView].forEach { contentView.addSubview($0) }
		imageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		loveIconView.snp.makeConstraints { make in
			make.size.equalTo(100)
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
		if isLiked {
			let amplitude: CGFloat = 1.0
			UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: .calculationModeCubic, animations: { [weak self] in
				guard let self = self else { return }
				UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.9) {
					self.loveIconView.transform = CGAffineTransform(translationX: -amplitude, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9) {
					self.loveIconView.transform = CGAffineTransform(translationX: amplitude, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.9) {
					self.loveIconView.transform = CGAffineTransform(translationX: -amplitude, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.9) {
					self.loveIconView.transform = CGAffineTransform(translationX: amplitude, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.9) {
					self.loveIconView.transform = CGAffineTransform(translationX: -amplitude, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.9) {
					self.loveIconView.transform = CGAffineTransform(translationX: amplitude, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.9) {
					self.loveIconView.transform = CGAffineTransform(translationX: -amplitude, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.9) {
					self.loveIconView.transform = CGAffineTransform(translationX: amplitude, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.9) {
					self.loveIconView.transform = CGAffineTransform(translationX: -amplitude, y: 0)
				}
				
				UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) {
					self.loveIconView.alpha = 0.0
					self.loveIconView.transform = .identity
				}
				
			}) { [weak self] isComplete in
				self?.doubleTapPublisher.send(())
				self?.layoutIfNeeded()
			}
		} else {
			UIView.animateKeyframes(withDuration: 0.75, delay: 0, options: .calculationModeCubic, animations: { [weak self] in
				guard let self = self else { return }
				UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.25) {
					self.loveIconView.alpha = 0.5
				}
				
				UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75) {
					self.loveIconView.alpha = 1.0
				}
				self.layoutIfNeeded()
			}) { [weak self] isComplete in
				guard let self = self else { return }
				UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .calculationModeCubic, animations: {
					
					UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
						
					}
					UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0.25) {
						self.loveIconView.snp.remakeConstraints { make in
							make.size.equalTo(30)
						}
						
						self.loveIconView.snp.makeConstraints { make in
							make.bottom.equalToSuperview().offset(-5)
							make.left.equalToSuperview().offset(5)
						}
						
					}
					self.layoutIfNeeded()
				}) { [weak self] isComplete in
					self?.doubleTapPublisher.send(())
				}
			}
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension DetailContentCell {
	internal func set(isLiked: Bool) {
		self.isLiked = isLiked
		if isLiked {
			self.loveIconView.alpha = 1.0
			self.loveIconView.snp.remakeConstraints { make in
				make.size.equalTo(30)
				make.bottom.equalToSuperview().offset(-5)
				make.left.equalToSuperview().offset(5)
			}
		} else {
			self.loveIconView.alpha = 0.0
			
			loveIconView.snp.remakeConstraints { make in
				make.size.equalTo(100)
				make.center.equalToSuperview()
			}
		}
	}
	
	internal func set(image: String) {
		if let url = URL(string: image) {
			self.imageView.kf.setImage(with: url, options: [
				.processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 70))),
				.scaleFactor(UIScreen.main.scale),
				.forceRefresh
			])
		}
	}
}

