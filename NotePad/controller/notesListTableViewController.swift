//
//  notesListTableViewController.swift
//  NotePad
//
//  Created by JAY BLACK on 12/05/2018.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import UIKit
import CoreData
class notesListTableViewController: UITableViewController {

    var notes = [Notes]()
    
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

    }
    
    //MARK: - Add new Notes
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newNotes = Notes(context: self.context)
            newNotes.name = textfield.text!
            self.notes.append(newNotes)
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Name of Note"
            textfield = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation
    
    func saveData(){
        do{
        try context.save()
        }
        catch {
            print("Error: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData(with request:NSFetchRequest<Notes> = Notes.fetchRequest()){
        
        do{
            notes = try context.fetch(request)
        }catch{
            print("error \(error)")
        }
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath)
        let notesCell = notes[indexPath.row]
        cell.textLabel!.text = notesCell.name
        return cell
    }
    
    //MARK: - Table view Delegate
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedNote = notes[indexPath.row]
        }
    }

}
