//
//  ImageSearchTableViewDataModelItem.swift
//  ImageSearch
//
//  Created by Denys on 18.11.16.
//  Copyright © 2016 Denys. All rights reserved.
//

import Foundation

class ImageSearchTableViewDataModelItem {
  let link: String?
  let image: String?
  
  init(link: String?, image: String?) {
    self.link = link
    self.image = image
  }
  
  static func imagessFromBundle(response: Data?) -> [ImageSearchTableViewDataModelItem] {
    
    var data = [ImageSearchTableViewDataModelItem]()
    
    do {
      if let dataResponse = response, let response = try JSONSerialization.jsonObject(with: dataResponse as Data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
        
        if let array = response["response"] as? [AnyObject] {
          for responseDictonary in array {
            if let imagesObject = responseDictonary as? [String: AnyObject],
              let blogName = imagesObject["blog_name"] as? String {
              if let photos = imagesObject["photos"] as? [AnyObject] {
                for photoDictonary in photos {
                  if let photo = photoDictonary as? [String: AnyObject],
                    let originalSize = photo["original_size"] as? [String: AnyObject],
                    let urlString = originalSize["url"] as? String {
                    data.append(ImageSearchTableViewDataModelItem(link: blogName, image: urlString))
                  }
                }
              }
            }
          }
        }
      }
    } catch let error as NSError {
      print("Error parsing results: \(error.localizedDescription)")
    }
   return data 
  }
}

