//
//  DetailViewController.swift
//  ImageSearch
//
//  Created by Denys on 18.11.16.
//  Copyright © 2016 Denys. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var currentImageView: UIImageView!
  
  var picture: ImageSearchTableViewDataModelItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if (picture.link != nil) {
      title = picture.link
    }
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    if let statusImageUrl = URL(string: picture.image!) {
      DispatchQueue.global().async {
        if let data = NSData(contentsOf: statusImageUrl){
          DispatchQueue.main.async() {
            self.currentImageView.image = UIImage(data: data as Data)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
          }
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}
