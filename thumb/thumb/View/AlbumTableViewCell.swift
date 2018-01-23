//
//  AlbumTableViewCell.swift
//  thumb
//
//  Created by Willie Johnson on 1/23/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit
import SnapKit

/// Shows the title and preview image of an Album.
class AlbumTableViewCell: UITableViewCell {
  /// Displays the album's title.
  lazy var titleLabel = UILabel()
  /// Displays a collage of the Album images.
  lazy var previewImageView = UIImageView()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
}

// MARK: - UI Setup
extension AlbumTableViewCell {
  /**
   Positions the subviews of the cell.
  */
  func setupUI() {
    addSubview(previewImageView)
    addSubview(titleLabel)

    // preview image
    previewImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    previewImageView.contentMode = .scaleAspectFill
    previewImageView.clipsToBounds = true

    // title label
    titleLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    titleLabel.font = UIFont(name: "futura", size: 80)
    titleLabel.text = "title"
  }
}
