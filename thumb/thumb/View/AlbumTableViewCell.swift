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
  /// View that contains the contents of the cell.
  var containerView: UIView!
  /// Displays the album's title.
  var titleLabel: UILabel!
  /// Displays a collage of the Album images.
  var previewImageView: UIImageView!
  /// The Album associated with this cell.
  var album: Album? {
    didSet {
      updateTitleLabel()
      updatePreviewImageData()
      updatePreviewImageView()
    }
  }
  /// Image data for this cell's preview image.
  var previewImageData: Data?

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
    backgroundColor = .clear

    let selectedBackgroundColor = UIView()
    selectedBackgroundColor.backgroundColor = .clear
    selectedBackgroundView = selectedBackgroundColor

    // MARK: Container view.
    containerView = UIView(frame: .zero)
    addSubview(containerView)

    containerView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 10, 5, 10))
    }
    containerView.clipsToBounds = true
    containerView.layer.cornerRadius = 10
    containerView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)

    // MARK: Preview image.
    previewImageView = UIImageView(frame: .zero)
    let overlay = UIView(frame: .zero)
    containerView.addSubview(previewImageView)
    containerView.addSubview(overlay)

    overlay.backgroundColor = .black
    overlay.alpha = 0.5
    overlay.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    previewImageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    previewImageView.contentMode = .scaleAspectFill
    previewImageView.clipsToBounds = true


    // MARK: Album name label.
    titleLabel = UILabel(frame: .zero)
    containerView.addSubview(titleLabel)

    titleLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    titleLabel.font = UIFont(name: "futura", size: 50)
    titleLabel.text = "title"
    titleLabel.textColor = .white
  }
}

// MARK: - Album
extension AlbumTableViewCell {
  /**
   Sets the title label's text to that of the album name.
  */
  func updateTitleLabel() {
    guard let album = album else { return }
    titleLabel.text = album.collection_name.lowercased()
  }

  /**
   Update the preview image data for this album.
   */
  func updatePreviewImageData() {
    guard let album = album else { return }
    
    guard let path = album.getPathToPreviewImageFile() else {
      print("Can't get preview image file path for album:\n \(album) \n\n")
      return
    }

    guard let dataFromImage = try? Data(contentsOf: path) else {
      print("Can't decode data for album:\n \(album) \n\n")
      return
    }

    previewImageData = dataFromImage
  }

  /**
   Sets the preview image to the preview image for the album.
  */
  func updatePreviewImageView() {
    guard let previewImageData = previewImageData  else { return }
    previewImageView.image = UIImage(data: previewImageData)
  }
}
