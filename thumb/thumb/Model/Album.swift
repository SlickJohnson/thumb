//
//  Albums.swift
//  thumb
//
//  Created by Willie Johnson on 1/23/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation

/// Holds the name and URLs associated with an Album.
struct Album: Decodable {
  /// The name of this album.
  var collection_name: String!
  /// The URL to get the images for this album.
  var zipped_images_url: String!
}

// MARK: - Convenience functions.
extension Album {
  /**
   Return the path to the album's preview image.
  */
  func getPathToPreviewImageFile() -> URL? {
    guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return  nil }

    // Account for wrong folder names created by unzipping zip files.
    var folderName = collection_name!.lowercased().replacingOccurrences(of: "health", with: "heath")
    if folderName.last == "s" {
      folderName.removeLast()
    }

    let pathToImagesDirectory = cachesDirectory
      .appendingPathComponent(folderName, isDirectory: true)
      .appendingPathComponent("_preview.png")

    return pathToImagesDirectory
  }
}
