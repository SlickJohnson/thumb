//
//  PictureCollectionViewCell.swift
//  thumb
//
//  Created by Willie Johnson on 1/26/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit
import SnapKit

/// Displays a picture.
class PictureCollectionViewCell: UICollectionViewCell {
  /// The image view to display the picture.
  var pictureImageView: UIImageView!

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
extension PictureCollectionViewCell {
  /**
   Configures the Cell to have an UIImageView that fills the cell.
  */
  func setupUI() {
    pictureImageView = UIImageView(frame: .zero)
    addSubview(pictureImageView)

    pictureImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    pictureImageView.clipsToBounds = true
    pictureImageView.contentMode = .scaleAspectFill
    pictureImageView.layer.cornerRadius = 5
  }
}
