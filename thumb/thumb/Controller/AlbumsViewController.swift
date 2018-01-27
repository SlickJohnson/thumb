//
//  AlbumsViewController.swift
//  thumb
//
//  Created by Willie Johnson on 1/22/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit
import SnapKit

/// Handles displaying albums in a AlbumsView.
class AlbumsViewController: UIViewController {
  /// Displays albums in a UITableView.
  var mainView: AlbumsView!
  /// List of albums to be displayed.
  var albums: [Album]?
  /// The shared instance of networking.
  let networking = Networking.shared

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupMainView()
    getAlbums()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: - Helper methods
private extension AlbumsViewController {
  /**
   Download any necessary data to display the albums.
  */
  func getAlbums() {
    // Download json if needed.
    networking.downloadAlbumsJson() {
      guard let jsonData = self.networking.getDataFromAlbumsJson() else { return }

      DispatchQueue.global(qos: .background).async {
        self.albums = self.networking.decodeAlbums(from: jsonData)

        DispatchQueue.main.async {
          self.downloadAlbumImage()
        }
      }
    }
  }

  /**
   Call the reloadData method on the mainview's table.
  */
  func reloadTable() {
    mainView.tableView.reloadData()
  }

  /**
   Download the images for albums.
  */
  func downloadAlbumImage() {
    guard let albums = albums else { return }

    for album in albums {
      album.downloadImages()
    }
    
    reloadTable()
  }
}

// MARK: - UI setup
extension AlbumsViewController {
  /**
   Get the AlbumsView ready to display data.
   */
  func setupMainView() {
    mainView = AlbumsView(frame: .zero)
    view.addSubview(mainView)
    mainView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }

    mainView.tableView.dataSource = self
    mainView.tableView.delegate = self
  }
}

// MARK: - UITableViewDelegate
extension AlbumsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let albums = albums else { return }
    let picturesViewController = PicturesViewController()
    picturesViewController.album = albums[indexPath.row]
    picturesViewController.modalPresentationStyle = .overFullScreen

    present(picturesViewController, animated: true, completion: nil)
  }
}

// MARK: - UITableViewDataSource
extension AlbumsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let albums = albums else { return 0 }
    return albums.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let albums = albums else { return UITableViewCell() }

    if let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as? AlbumTableViewCell {
      let album = albums[indexPath.row]

      cell.album = album

      return cell
    }

    return AlbumTableViewCell()
  }
}
