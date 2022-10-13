//
//  AssingmentListView.swift
//  HomeworkHelper
//
//  Created by Dylan Bortnick on 8/15/20.
//  Copyright © 2020 BortnickDev. All rights reserved.
//

import Foundation
import UIKit

class AssignmentListViewController: UITableViewController {
    var assignments: [Assignment]! = []
    var classSubject: Class! = nil
    
    @IBOutlet var className: UITextField!
    
    @IBAction func createAssignment() {
        let _ = AssignmentManager.shared.Acreate(subject: classSubject!)
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeHideKeyboard()
        setupTextFields()
        self.className.text = classSubject?.name
        reload()
    }
   
    func initializeHideKeyboard(){
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
    target: self,
    action: #selector(dismissMyKeyboard))
        tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
    view.endEditing(true)
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        className.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        classSubject!.name = className.text!
        ClassManager.shared.saveClass(subject: classSubject!)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let _ = AssignmentManager.shared.deleteAssignment(subject: assignments[indexPath.row])
            self.assignments.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    
    func reload() {
        assignments = AssignmentManager.shared.getAssignments(subject: classSubject!)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCell", for: indexPath)
        cell.textLabel?.text = assignments[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AssignmentSegue",
                let destination = segue.destination as? AssignmentViewController,
                let index = tableView.indexPathForSelectedRow?.row {
            destination.assignment = assignments[index]
        }
    }
}


