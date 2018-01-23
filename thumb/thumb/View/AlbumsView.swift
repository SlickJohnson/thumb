//
//  AlbumView.swift
//  thumb
//
//  Created by Willie Johnson on 1/22/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

/// Displays Albums in an UITableViewController.
class AlbumView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubviews()
    setupSubviewConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

// MARK: - UI
private extension AlbumView {
  /**
   Add all UIViews necessary for this view.
   */
  func addSubviews() {

  }

  /**
   Add constraints to subviews.
   */
  func setupSubviewConstraints() {}
}
