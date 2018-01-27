//
//  FileManagement.swift
//  thumb
//
//  Created by Willie Johnson on 1/26/18.
//  Copyright © 2018 Willie Johnson. All rights reserved.
//

import Foundation
import Zip


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

/**
 Return the path to the album's preview image.
 */
func getPathToPreviewImage(for albumName: String) -> URL? {
  guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return  nil }

  // Account for wrong folder names created by unzipping zip files.
  var folderName = albumName.lowercased().replacingOccurrences(of: "health", with: "heath")
  if folderName.last == "s" {
    folderName.removeLast()
  }
  
  let pathToImagesDirectory = cachesDirectory
    .appendingPathComponent(folderName, isDirectory: true)
    .appendingPathComponent("_preview.png")

  return pathToImagesDirectory
}

