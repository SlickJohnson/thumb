//
//  Networking.swift
//  thumb
//
//  Created by Willie Johnson on 1/23/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation

class Networking {
  /// The link to get the json for all the images.
  var apiUrl = URL(string: "https://s3-us-west-2.amazonaws.com/mob3/image_collection.json")
  let session = URLSession.shared

  /**
   Downloads the file from the provided URL to the specified directory.

   - Parameters:
       - url: Where to download the file from.
       - destination: Where to download the file to.
   */
  func downloadFile(from url: URL, to destination: URL, completion: @escaping () -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    session.downloadTask(with: request) { (tempLocalUrl, response, error) in
      guard let tempLocalUrl = tempLocalUrl else { return }

      self.copyFile(tempLocalUrl, to: destination)
      completion()
      }.resume()
  }
}

// MARK: - API
extension Networking {
  /**
   Downloads the image_collection.json file from the API url
   */
  func downloadAlbumsJson() {
    guard var cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
    cacheDirectory.appendPathComponent("albums.json")

    downloadFile(from: apiUrl!, to: cacheDirectory) {
      UserDefaults.standard.set(true, forKey: "hasDownloadedJson")
    }
  }

  /**
   Check User Defaults to see if the file image_collection.json file was already downloaded.
   */
  func shouldDownloadAlbumJson() -> Bool {
    return !UserDefaults.standard.bool(forKey: "hasDownloadedJson")
  }
}

// MARK: - File management
extension Networking {
  /**
   Copy the file from the specified directory to the given destination.

   - Parameters:
       - at: File to copy.
       - destination: The path to the directory the file should be copied to.
   */
  func copyFile(_ at: URL, to destination: URL) {
    do {
      try FileManager.default.copyItem(at: at, to: destination)
    } catch (let writeError) {
      print("error writing file \(destination) : \(writeError)")
    }
  }
}
