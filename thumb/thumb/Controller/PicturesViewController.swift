//
//  PicturesViewController.swift
//  thumb
//
//  Created by Willie Johnson on 1/26/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import UIKit

/// Handles images displayed in a PicturesView.
class PicturesViewController: UIViewController {
  /// The PicturesView that will dispaly the pictures.
  var mainView: PicturesView!
  /// The album who's images will be shown.
  var album: Album!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    setupUI()
  }
}



// MARK: Setup
private extension PicturesViewController {
  /**
   Setup the mainView and other necessary configurations.
  */
  private func setupUI() {
    mainView = PicturesView(frame: .zero)
    view.addSubview(mainView)

    mainView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    mainView.imagesCollectionView.delegate = self
    mainView.imagesCollectionView.dataSource = self
  }
}

// MARK: - UICollectionViewDelegate
extension PicturesViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension PicturesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

    return cell
  }
}
