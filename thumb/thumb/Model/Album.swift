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
  /// Holds the path to where the downloaded images are saved.
  var downloadDirectory: String!
}


