//
//  ClassList.swift
//  HomeworkHelper
//
//  Created by Dylan Bortnick on 8/15/20.
//  Copyright © 2020 BortnickDev. All rights reserved.
//

import Foundation
import UIKit

class ClassListViewController: UITableViewController {
    var classes: [Class] = []
    
    @IBAction func createClass() {
        let _ = ClassManager.shared.create()
        reload()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let _ = ClassManager.shared.deleteClass(subject: classes[indexPath.row])
            self.classes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    
    func reload() {
        classes = ClassManager.shared.getClasses()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath)
        cell.textLabel?.text = classes[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClassSegue",
                let destination = segue.destination as? AssignmentListViewController,
                let index = tableView.indexPathForSelectedRow?.row {
            destination.classSubject = classes[index]
        }
    }
}

