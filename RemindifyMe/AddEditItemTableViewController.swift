//
//  AddEditItemTableViewController.swift
//  RemindifyMe
//
//  Created by Mohamed Mohamed on 3/13/20.
//  Copyright © 2020 Toasted Peanuts. All rights reserved.
//

import UIKit

class AddEditItemTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var item: Item?
    
    @IBOutlet weak var notificationDaysOutlet: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var daysBeforeLabel: UILabel!
    @IBOutlet weak var notificationDateView: UIView!
    @IBOutlet weak var choosePhotoButton: UIButton!
    var imagePicker = UIImagePickerController()
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        expireDateTextField.inputView = datePicker
        
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        choosePhotoButton.setTitle("Choose image", for: .normal)
        
        notificationDateView.isHidden = true
        if let item = item {
            itemNameTextField.text = item.name
            expireDateTextField.text = item.expiration_date
            choosePhotoButton.setTitle("", for: .normal)
            
            itemImage.image = item.image
            if item.notificationDaysBefore != nil {
                notificationDateView.isHidden = false
                notificationDaysOutlet.text = item.notificationDaysBefore
            }
        }
        datePicker?.minimumDate = Date()
        
        updateSaveButtonState()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func choosePhotoButtonClicked(_ sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\n\nin\n\n")
        self.dismiss(animated: true, completion: { () -> Void in

        })
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        itemImage.image = image
        choosePhotoButton.setTitle("", for: .normal)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        expireDateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
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
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        notificationDateView.isHidden = false
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        notificationDateView.isHidden = true
    }
    
    @IBAction func notificationExpirationTextField(_ sender: UITextField) {
        let text = notificationDaysOutlet.text
        if text == "1" {
            daysBeforeLabel.text = "day before expiration date"
        } else {
            daysBeforeLabel.text = "days before expiration date"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        
        let itemName = itemNameTextField.text ?? ""
        let expireDate = expireDateTextField.text ?? ""
        if let itemImage = itemImage.image {
            item = Item(name: itemName, expiration_date: expireDate, image: itemImage)
        } else {
            item = Item(name: itemName, expiration_date: expireDate, image: #imageLiteral(resourceName: "clear"))
        }
        if notificationDaysOutlet.text != "" {
            item?.notificationDaysBefore = notificationDaysOutlet.text
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
