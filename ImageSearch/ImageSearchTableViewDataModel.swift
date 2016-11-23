//
//  ImageSearchTableViewDataModel.swift
//  ImageSearch
//
//  Created by Denys on 18.11.16.
//  Copyright © 2016 Denys. All rights reserved.
//

import UIKit

protocol ImageSearchTableViewDataModelDelegate: class {
  func didRecieveDataUpdate(data: [ImageSearchTableViewDataModelItem])
  func didFailDataUpdateWithError(error: Error)
}

class ImageSearchTableViewDataModel: NSObject {
  
  weak var delegate: ImageSearchTableViewDataModelDelegate?
  
  func requestData(searchTerm: String) {
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    let url = NSURL(string: "https://api.tumblr.com/v2/tagged?tag=\(searchTerm)&api_key=CcEqqSrYdQ5qTHFWssSMof4tPZ89sfx6AXYNQ4eoXHMgPJE03U")

    let dataTask = URLSession.shared.dataTask(with: url! as URL) {
      data, response, error in

      DispatchQueue.main.async(execute:{
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      })

      if let error = error {
        print(error.localizedDescription)
      } else if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
          self.setDataWithResponse(response: data)
        }
      }
    }
    dataTask.resume()
  }
  
  private func setDataWithResponse(response: Data?) {
    let data = ImageSearchTableViewDataModelItem.imagessFromBundle(response: response)
    delegate?.didRecieveDataUpdate(data: data)
  }
  
}
