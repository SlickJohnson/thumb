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
  /// Loaded images of the album.
  var images: [UIImage]?
  /// Keeps track of first tap in the view.
  var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
  /// Keeps track of whether the image collection view has reached the top or bottom of the view.
  var hasReachedTop: Bool! // hasReachedBottom,
  var isMovingModalView = false {
    didSet {
      mainView.imagesCollectionView.isScrollEnabled = !isMovingModalView
    }
  }

  init(_ album: Album) {
    self.album = album
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    hasReachedTop = false
//    hasReachedBottom = false
    setupUI()
    getAlbumImages()
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
  func setupUI() {
    mainView = PicturesView(frame: .zero)
    view.addSubview(mainView)

    mainView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    mainView.titleLabel.text = album.collection_name.lowercased()

    mainView.imagesCollectionView.delegate = self
    mainView.imagesCollectionView.dataSource = self
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:)))
    panGesture.maximumNumberOfTouches = 1
    panGesture.delegate = self
    mainView.imagesCollectionView.addGestureRecognizer(panGesture)
  }

  /**
   Loads all album images from caches directory.
  */
  func getAlbumImages() {
    guard let imagesFolder = getPathToImages(for: album.collection_name) else { return }
    guard let imagesData = loadFiles(from: imagesFolder) else { return }
    images = [UIImage]()
    for data in imagesData {
      if let image = UIImage(data: data) {
        images?.append(image)
      } else {
        print("Couldn't decode an image")
      }
    }
    reloadData()
  }
}

// MARK: - Helper functions
extension PicturesViewController {
  func reloadData() {
    mainView.imagesCollectionView.reloadData()
  }

  @objc func panGestureRecognizerHandler(_ recognizer: UIPanGestureRecognizer) {
    let touchPoint = recognizer.location(in: view?.window)

    switch recognizer.state {
    case .began:
      initialTouchPoint = touchPoint
    case .changed:
      guard hasReachedTop else {
        initialTouchPoint = touchPoint
        return
      }

      if hasReachedTop {
        if !isMovingModalView {
          UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.mainView.titleLabel.alpha = 0
          }, completion: nil)
        }
        guard let superview = view.superview else { return }
        let translation = recognizer.translation(in: superview)

        view.center = CGPoint(x: view.center.x + translation.x,
                                y: view.center.y + translation.y)

        recognizer.setTranslation(CGPoint.zero, in: superview)
        // Ranges from 0 - 160.
        let delta = min(max(abs(view.center.y - superview.center.y) / 2, 0), 160)

        mainView.layer.cornerRadius = delta
        mainView.frame.size = CGSize(width: superview.frame.size.width - delta / 4, height: superview.frame.size.height - delta * 2)
        isMovingModalView = true
      }
    case .ended, .cancelled:
      if hasReachedTop && (touchPoint.y - initialTouchPoint.y > 200) {
        dismiss(animated: true, completion: nil)
      } else {
        guard isMovingModalView else { return }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
          self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
          self.mainView.layer.cornerRadius = 0
          self.mainView.frame.size = self.view.frame.size
          self.mainView.titleLabel.alpha = 1
        }, completion: { _ in
          self.isMovingModalView = false
        })
      }
    default:
      return
    }
  }
}

// MARK: - UICollectionViewDelegate
extension PicturesViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y
    let topLimit: CGFloat = -120.0

    if !isMovingModalView {
      hasReachedTop = offset < topLimit

      if scrollView.contentOffset.y < 0 {
        self.mainView.titleLabel.alpha = abs(scrollView.contentOffset.y / 100)
      } else if scrollView.contentOffset.y > 0 {
        self.mainView.titleLabel.alpha = 0
      }
    }
  }
}

// MARK: - UICollectionViewDataSource
extension PicturesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let images = images else { return 0 }
    return images.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView
      .dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as? PictureCollectionViewCell else {
        return UICollectionViewCell()
      }
    guard let images = images else { return UICollectionViewCell() }
    cell.pictureImageView.image = images[indexPath.row]
    return cell
  }
}

// MARK: - UIGestureRecognizerDelegate
extension PicturesViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
