//
//  ImageSearchTableViewController.swift
//  ImageSearch
//
//  Created by Denys on 19.11.16.
//  Copyright © 2016 Denys. All rights reserved.
//

import UIKit

class ImageSearchTableViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView?
  @IBOutlet weak var searchBar: UISearchBar?
  
  var imageCache = NSCache<AnyObject, AnyObject>()
  let dataSource = ImageSearchTableViewDataModel()
  
  fileprivate var dataArray = [ImageSearchTableViewDataModelItem]() {
    didSet {
      DispatchQueue.main.async(execute:{
        self.tableView?.setContentOffset(CGPoint.zero, animated: false)
        self.tableView?.reloadData()
        self.imageCache.removeAllObjects()
      })
    }
  }
  
  lazy var tapRecognizer: UITapGestureRecognizer = {
    var recognizer = UITapGestureRecognizer(target:self, action: #selector(UIInputViewController.dismissKeyboard))
    return recognizer
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView?.rowHeight = UITableViewAutomaticDimension
    tableView?.estimatedRowHeight = 140
    tableView?.delegate = self
    tableView?.dataSource = self
    
    searchBar?.delegate = self
    
    dataSource.delegate = self
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showImageSegue" {
      if let indexPath = self.tableView?.indexPathForSelectedRow {
        let detinationVC = segue.destination as! DetailViewController
        detinationVC.picture = dataArray[indexPath.row]
      }
    }
  }
}

extension ImageSearchTableViewController: UISearchBarDelegate {
  func dismissKeyboard() {
    searchBar?.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    dismissKeyboard()
    
    if !searchBar.text!.isEmpty {
      let expectedCharSet = NSCharacterSet.urlQueryAllowed
      let searchTerm = searchBar.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)!
      dataSource.requestData(searchTerm: searchTerm)
    }
  }
   
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    view.addGestureRecognizer(tapRecognizer)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    view.removeGestureRecognizer(tapRecognizer)
  }
}

extension ImageSearchTableViewController: UITableViewDelegate {
  
}

extension ImageSearchTableViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "Cell"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ImageSearchTableViewCell
    
    let pictures = dataArray[indexPath.row]

    let cacheKey = pictures.image!
    if(self.imageCache.object(forKey: cacheKey as AnyObject) != nil){
      cell.thumbnailImageView?.image = self.imageCache.object(forKey: cacheKey as AnyObject) as? UIImage
    }else{
      DispatchQueue.global().async {
        if let url = URL(string: pictures.image!) {
          if let data = NSData(contentsOf: url) {
            let image: UIImage = resizeImage(image: UIImage(data: data as Data)!, newWidth: 300)!
            self.imageCache.setObject(image, forKey: cacheKey as AnyObject)
            DispatchQueue.main.async {
              cell.delegate?.tableViewCell(cell: cell)
              cell.thumbnailImageView?.image = image
            }
          }
        }
      }
    }

    
    cell.delegate = self
    return cell
  }
}

extension ImageSearchTableViewController: ImageSearchTableViewCellDelegate {
  func tableViewCell(cell: UITableViewCell) {
    tableView?.beginUpdates()
    if let cellIndexPath = tableView?.indexPathForRow(at: cell.center) {
      tableView?.reloadRows(at: [cellIndexPath], with: UITableViewRowAnimation.automatic)
    }
    tableView?.endUpdates()
  }
}

extension ImageSearchTableViewController: ImageSearchTableViewDataModelDelegate {
  func didFailDataUpdateWithError(error: Error) {
    print("error: \(error.localizedDescription)")
  }

  func didRecieveDataUpdate(data: [ImageSearchTableViewDataModelItem]) {
    dataArray = data
  }
}
