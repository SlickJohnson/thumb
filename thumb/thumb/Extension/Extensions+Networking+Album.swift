//
//  Extensions+Networking+Album.swift
//  thumb
//
//  Created by Willie Johnson on 1/24/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import Zip
import UIKit

extension Album {
  /**
   Download image using given URL
   */
  func downloadImages() {
    // Get shared instances
    let networking = Networking.shared
    let session = networking.session
    let defaults = UserDefaults.standard

    // Check to see if images are already downloaded.
    if defaults.bool(forKey: "\(collection_name)imagesHasDownloaded") {
      return
    }

    let zipUrl = URL(string: zipped_images_url)!
    var request = URLRequest(url: zipUrl)
    request.httpMethod = "GET"

    // Download images.
    session.downloadTask(with: request) { (tempLocalUrl, response, error) in
      guard let tempLocalUrl = tempLocalUrl else { return }

      unZip(file: tempLocalUrl) {
        defaults.set(true, forKey: "\(self.collection_name)imagesHasDownloaded")
      }
    }.resume()
  }
}
