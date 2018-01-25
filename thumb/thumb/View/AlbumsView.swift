//
//  AlbumsView.swift
//  thumb
//
//  Created by Willie Johnson on 1/22/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit
import SnapKit

/// Shows a list of Albums in an UITableViewController.
class AlbumsView: UIView {
  /// Album list tableview
  var tableView: UITableView!
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

// MARK: - UI Setup
private extension AlbumsView {
  /**
   Construct a view that has a label and a tableview.
   */
  func setupUI() {
    // MARK: Table

    tableView = UITableView(frame: .zero)
    addSubview(tableView)

    // constraints
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    // cells
    tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: "albumCell")
    tableView.rowHeight = 220
    // appearance
    tableView.backgroundColor = .black
    tableView.contentInset.top = 66
    tableView.separatorStyle = .none

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
    titleLabel.text = "albums"
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "futura", size: 44)
    titleLabel.textColor = .white
    titleLabel.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.90)
  }
}
