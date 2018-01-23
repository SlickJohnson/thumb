//
//  AlbumsView.swift
//  thumb
//
//  Created by Willie Johnson on 1/22/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit
import SnapKit

/// Displays Albums in an UITableViewController.
class AlbumsView: UIView {
  /// Shows all the albums.
  lazy var tableView = UITableView()
  /// Title for screen.
  lazy var titleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupUI()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

// MARK: - UI Setup
private extension AlbumsView {
  /**
   Construct a view that has a label and a tableview.
   */
  func setupUI() {
    addSubview(tableView)
    addSubview(titleLabel)
    
    // table
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: "albumCell")
    tableView.contentInset.top = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 150

    // title
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(44)
      make.centerX.equalToSuperview()
    }
    titleLabel.text = "albums"
    titleLabel.font = UIFont(name: "futura", size: 44)
  }
}
