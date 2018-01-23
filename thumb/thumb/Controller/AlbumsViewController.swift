//
//  AlbumsViewController.swift
//  thumb
//
//  Created by Willie Johnson on 1/22/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit
import SnapKit

/// Displays all albums.
class AlbumsViewController: UIViewController {
  lazy var mainView = AlbumsView()
  let networking = Networking()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupMainView()

    if networking.shouldDownloadAlbumJson() {
      networking.downloadAlbumsJson()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: - UI setup
extension AlbumsViewController {
  /**
   Get the AlbumsView ready to display data.
   */
  func setupMainView() {
    view.addSubview(mainView)
    mainView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}

// MARK: - UITableViewDelegate
extension AlbumsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
}

// MARK: - UITableViewDataSource
extension AlbumsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as? AlbumTableViewCell {
      return cell
    }

    return UITableViewCell()
  }
}
