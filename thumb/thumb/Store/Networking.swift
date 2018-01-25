//
//  Networking.swift
//  thumb
//
//  Created by Willie Johnson on 1/23/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import Zip

final class Networking {
  /// Shared instance of Networking.
  static let shared = Networking()
  /// The link to get the json for all the images.
  var apiUrl = URL(string: "https://s3-us-west-2.amazonaws.com/mob3/image_collection.json")
  let session = URLSession.shared
}

// MARK: - API
extension Networking {
  /**
   Downloads the file from the provided URL to the specified directory.

   - Parameters:
     - url: Where to download the file from.
     - destination: Where to download the file to.
   */
  func downloadFile(from url: URL, to destination: URL?=nil, completion: @escaping () -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    session.downloadTask(with: request) { (tempLocalUrl, response, error) in
      guard let tempLocalUrl = tempLocalUrl else { return }

      if let destination = destination {
        self.copyFile(tempLocalUrl, to: destination)
      }

      completion()
    }.resume()
  }

  /**
   Downloads the image_collection.json file from the API url
   */
  func downloadAlbumsJson(completion: @escaping () -> Void) {
    if UserDefaults.standard.bool(forKey: "hasDownloadedJson") {
      completion()
      return
    }

    guard var cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
    cacheDirectory.appendPathComponent("albums.json")

    downloadFile(from: apiUrl!, to: cacheDirectory) {
      UserDefaults.standard.set(true, forKey: "hasDownloadedJson")
      completion()
    }
  }
  /**
   Get's the decodable ablum data from the albums.json file.
   */
  func getDataFromAlbumsJson() -> Data? {
    guard var pathToJson = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
    pathToJson.appendPathComponent("albums.json")

    do {
      return try Data(contentsOf: pathToJson)
    } catch let error as NSError {
      print(error)
      return nil
    }
  }

  /**
   Downloads the zip files for the albums.
   */
  func decodeAlbums(from data: Data) -> [Album]? {
    do {
      return try JSONDecoder().decode([Album].self, from: data)
    } catch {
      return nil
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

  /**
   Unzips the file at the given file path to the caches directory.
   */
  func unZip(file at: URL, to destination: URL?=nil, completion: @escaping () -> Void) {
    Zip.addCustomFileExtension("tmp")

    do {
      let cachesDirectory = FileManager.default.urls(for:.cachesDirectory, in: .userDomainMask).first!

      try Zip.unzipFile(at, destination: cachesDirectory, overwrite: true, password: nil, progress: { (progress) -> () in
        if progress >= 1.0 {
          completion()
        }
      })
    } catch {
      print("Something went wrong")
    }
  }
}
