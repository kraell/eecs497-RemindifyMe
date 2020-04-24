//
//  ItemTableViewController.swift
//  RemindifyMe
//
//  Created by Mohamed Mohamed on 3/12/20.
//  Copyright © 2020 Toasted Peanuts. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController,
        UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var items: [Item] = [
        Item(name: "Banana", expire_date: Date(), image: #imageLiteral(resourceName: "banana")),
        Item(name: "Milk", expire_date: Date(), image: #imageLiteral(resourceName: "milk"))
    ]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        sortItems()
    }
    
    func sortItems() {
        items = items.sorted(by: {
            $0.expire_date.compare($1.expire_date) == .orderedAscending
        })
        self.tableView.reloadData()
        
    }
    
    @IBAction func takeCouponPhotoButtonPressed(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    var takenPhoto: UIImage?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        
        // print out the image size as a test
        print(image.size)
        takenPhoto = image
        self.performSegue(withIdentifier: "NewItemPicture", sender: self)
    }

    @IBAction func unwindToItemTable(unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "saveUnwind" else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            return
        }
        let sourceViewController = unwindSegue.source as! AddEditItemTableViewController
        
        if let item = sourceViewController.item {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                items[selectedIndexPath.row] = item
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                let newIndexPath = IndexPath(row: items.count, section: 0)
                items.append(item)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            sortItems()
        }
    }
    
    @IBAction func refreshTable(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
        var expiredItems = [String]()
        var newItems: [Item] = []
        for item in items {
            if Calendar.current.isDateInToday(item.expire_date) {
                newItems.append(item)
            }
            else {
                var diffInDays = Calendar.current.dateComponents([.day], from: Date(), to: item.expire_date).day
                diffInDays = (diffInDays ?? 0) + 1
                if diffInDays ?? 1 <= 0 {
                    expiredItems.append(item.name)
                }
                else {
                    newItems.append(item)
                }
            }
        }
        
        if expiredItems.count > 0 {
            var expiredItemsString: String = ""
            for i in expiredItems {
                expiredItemsString = expiredItemsString + i + "\n"
            }
            let alertPrompt = UIAlertController(title: "Expired Items", message: "\(expiredItemsString)", preferredStyle: .actionSheet)
            
                let confirmAction = UIAlertAction(title: "Remove from list", style: UIAlertAction.Style.default, handler: { _ in
                    self.items = newItems
                    self.tableView.reloadData()
                })
                
                let cancelAction = UIAlertAction(title: "Keep all items", style: UIAlertAction.Style.cancel, handler: nil)
                
                alertPrompt.addAction(confirmAction)
                alertPrompt.addAction(cancelAction)
            
                self.present(alertPrompt, animated: true, completion: nil)
        }
    }
    // MARK: - Table view data source
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditItem" {
            let indexPath = tableView.indexPathForSelectedRow!
            let item = items[indexPath.row]
            let top = segue.destination as! UINavigationController
            let addEditItemTableViewController = top.topViewController as! AddEditItemTableViewController
            addEditItemTableViewController.item = item
        }
        else if segue.identifier == "NewItemPicture" {
            let item = Item(name: "", expire_date: Date(), image: takenPhoto!)
            let addEditItemTableViewController = segue.destination as! AddEditItemTableViewController
            addEditItemTableViewController.item = item
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return items.count
        } else {
            return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell

        let item = items[indexPath.row]
        cell.update(with: item)
        cell.showsReorderControl = true
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) ->
        UITableViewCell.EditingStyle {
            return .delete
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: . automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

}
