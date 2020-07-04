//
//  ViewController.swift
//  AssigmentApp
//
//  Created by Prerna Chauhan on 02/07/20.
//  Copyright © 2020 Prerna Chauhan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    private let cellID = "TableViewCell"
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Article.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "likes", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photos Feed"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        view.backgroundColor = .white
        self.tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.updateTableContent()
    }
    
    func updateTableContent() {
        
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
        } catch let error  {
            print("ERROR: \(error)")
        }
        
        let service = APIService()
        service.getDataWith { (result) in
            switch result {
            case .Success(let data):
                self.clearData()
                self.saveInCoreDataWith(array: data)
            case .Error(let message):
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: message)
                }
            }
        }
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier:"TableViewCell") as! TableViewCell
        if let article = fetchedhResultController.object(at: indexPath) as? Article {
            // cell.setPhotoCellWith(photo: article)
            DispatchQueue.main.async {
                cell.article_Content.text = article.content
                let value = article.comments
                let str = Int(value!)
                cell.comment.text = "\(str!.shorted()) Comments"
                let valuelike = article.likes
                let strlike = Int(valuelike!)
                cell.like.text = "\(strlike!.shorted()) Likes"
                cell.article_Url.text = article.mediaUrl
                cell.article_Title.text = article.mediaTitle
                cell.user_descrip.text = article.userDesignation
                cell.user_Name.text = article.userName! + "" + article.userLastName!
                if let url = article.userAvatar {
                    cell.user_Img.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
                }
                
                if let url = article.mediaImage {
                    cell.atricle_img.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width + 10
    }
    
    func createPhotoEntityFrom(dictionary:[String: Any]) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "Article", into: context) as? Article {
            photoEntity.content = dictionary["content"] as? String
            photoEntity.id = dictionary["id"] as? String
            let Comment = (dictionary["comments"]) as? Int
            let commentValue = Comment!.toString()
            photoEntity.comments = commentValue
            let like = (dictionary["likes"])as? Int
            let likeValue = like!.toString()
            photoEntity.likes = likeValue
            let mediaData = dictionary["media"] as? [[String: AnyObject]]
            for mdata in mediaData!{
                print(mdata)
                photoEntity.mediaImage = mdata["image"] as? String
                photoEntity.mediaBlogId = mdata["blogId"] as? String
                photoEntity.mediaCreatedAt = mdata["createdAt"] as? String
                photoEntity.mediaId = mdata["id"] as? String
                photoEntity.mediaTitle = mdata["title"] as? String
                photoEntity.mediaUrl = mdata["url"] as? String
            }
            var userData = dictionary["user"] as? [[String: AnyObject]]
            for udata in userData!{
                photoEntity.userAvatar = udata["avatar"] as? String
                photoEntity.userBlogId = udata["blogId"] as? String
                photoEntity.userCity = udata["city"] as? String
                photoEntity.userCreatedAt = udata["createdAt"] as? String
                photoEntity.userDesignation = udata["designation"] as? String
                photoEntity.userId = udata["id"] as? String
                photoEntity.userLastName = udata["lastname"] as? String
                photoEntity.userName = udata["name"] as? String
                photoEntity.userAbout = udata["about"] as? String
            }
            return photoEntity
        }
        return nil
    }
    
    func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createPhotoEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Article.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}


extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
}







