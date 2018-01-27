//
//  PicturesView.swift
//  thumb
//
//  Created by Willie Johnson on 1/26/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

/// Displays once the user taps on an album in the AlbumsView.
class PicturesView: UIView {
  /// Displays an album's images.
  var imagesCollectionView: UICollectionView!
  /// AlbumsView title label.
  var titleLabel: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
}

// MARK: Setup
private extension PicturesView {
  /**
   Create a UIView with a colleciton view as the subview
  */
  func setupUI() {
    setupImagesCollectionView()
    setupTitleLabel()
  }

  /**
   Configure the collection view to display PictureCollectionViewCells.
  */
  func setupImagesCollectionView() {
    // Configure how the colleciton view will display its items.
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    layout.itemSize = CGSize(width: 160, height: 140)

    imagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    addSubview(imagesCollectionView)

    imagesCollectionView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    imagesCollectionView.contentInset.top = 66

    imagesCollectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: "pictureCell")
  }

  /**
   Configure the view title label.
  */
  func setupTitleLabel() {
    // MARK: Title
    titleLabel = UILabel(frame: .zero)
    addSubview(titleLabel)
    // constraints
    titleLabel.snp.makeConstraints { (make) in
      make.top.left.right.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalTo(88)
    }
    // appearance
    titleLabel.text = "pictures"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "futura", size: 44)
    titleLabel.textColor = .white
    titleLabel.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.90)
  }
}
