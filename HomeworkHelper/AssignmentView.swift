//
//  AssignmentView.swift
//  HomeworkHelper
//
//  Created by Dylan Bortnick on 8/15/20.
//  Copyright © 2020 BortnickDev. All rights reserved.
//

import UIKit

class AssignmentViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var dueDateTextField: UITextField!
    
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var backgroundSV: UIScrollView!
        
    var assignment: Assignment? = nil
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTextFields()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        
        self.nameTextField.text = assignment?.name
        self.descriptionTextView.text = assignment?.description
        self.dueDateTextField.text = assignment?.dueDate
    }
    
    
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        nameTextField.inputAccessoryView = toolbar
        descriptionTextView.inputAccessoryView = toolbar
        dueDateTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        
        assignment!.name = nameTextField.text ?? ""
        assignment!.description = descriptionTextView.text ?? ""
        assignment!.dueDate = dueDateTextField.text ?? ""
        
        AssignmentManager.shared.saveAssignment(subject: assignment!)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.dueDateTextField.isEditing {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
            if self.descriptionTextView.isFirstResponder {
                self.view.frame.origin.y = 0
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func openReminderMenu() {
        
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReminderSegue",
            let destination = segue.destination as? ReminderViewController {
            destination.notificationTitle = assignment!.name
            destination.notificationBody = assignment!.dueDate
        }
                
    }
}

