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
  /// Keeps track of first tap in the view.
  var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
  var distance: CGFloat = 0.0
  /// Keeps track of whether the image collection view has reached the top or bottom of the view.
  var hasReachedBottom, hasReachedTop: Bool!

  override func viewDidLoad() {
    super.viewDidLoad()
    hasReachedTop = false
    hasReachedBottom = false
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
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:)))
    panGesture.maximumNumberOfTouches = 1
    panGesture.delegate = self
    mainView.imagesCollectionView.addGestureRecognizer(panGesture)
  }
}

// MARK: - Helper functions
extension PicturesViewController {
  @objc func panGestureRecognizerHandler(_ recognizer: UIPanGestureRecognizer) {
    let touchPoint = recognizer.location(in: view?.window)

    switch recognizer.state {
    case .began:
      initialTouchPoint = touchPoint
      distance = touchPoint.y - initialTouchPoint.y
    case .changed:
      if hasReachedTop && (touchPoint.y - initialTouchPoint.y > 0)
        || hasReachedBottom && (touchPoint.y - initialTouchPoint.y < 0) {
        let translation = recognizer.translation(in: view.superview)

        view.center = CGPoint(x: view.center.x + translation.x,
                                y: view.center.y + translation.y)

        recognizer.setTranslation(CGPoint.zero, in: view.superview)
      }

    case .ended, .cancelled:
      if hasReachedTop && (touchPoint.y - initialTouchPoint.y > 200)
        || hasReachedBottom && (touchPoint.y - initialTouchPoint.y < 200) {
        dismiss(animated: true, completion: nil)
      } else {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
          self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion: nil)
      }
    default:
      return
    }
  }
}

// MARK: - UICollectionViewDelegate
extension PicturesViewController: UICollectionViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    hasReachedBottom = scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
    hasReachedTop = scrollView.contentOffset.y < 0
  }
}

// MARK: - UICollectionViewDataSource
extension PicturesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 100
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView
      .dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as? PictureCollectionViewCell else {
        return UICollectionViewCell()
      }

    return cell
  }
}

// MARK: - UIGestureRecognizerDelegate
extension PicturesViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
