//
//  AddEditItemTableViewController.swift
//  RemindifyMe
//
//  Created by Mohamed Mohamed on 3/13/20.
//  Copyright © 2020 Toasted Peanuts. All rights reserved.
//

import UIKit

class AddEditItemTableViewController: UITableViewController {
    var item: Item?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var itemNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = item {
            itemNameTextField.text = item.name
            expireDateTextField.text = item.expiration_date
            itemImage.image = item.image
        }

        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let itemNameText = itemNameTextField.text ?? ""
        let expireDateText = expireDateTextField.text ?? ""
        saveButton.isEnabled = !itemNameText.isEmpty && !expireDateText.isEmpty
    }

    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        
        let itemName = itemNameTextField.text ?? ""
        let expireDate = expireDateTextField.text ?? ""
        if let itemImage = itemImage.image {
            item = Item(name: itemName, expiration_date: expireDate, image: itemImage)
        } else {
            item = Item(name: itemName, expiration_date: expireDate, image: #imageLiteral(resourceName: "banana"))
        }
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
