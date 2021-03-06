//
//  ViewController.swift
//  NotePad
//
//  Created by JAY BLACK on 08/05/2018.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITextViewDelegate {

    var editableNote = [NotesDetails]()
    
    @IBOutlet weak var textView: UITextView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
      HoldData()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        print("TextField editing")
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        HoldData()
    }
    var selectedNote : Notes? {
        didSet{
            loadData()
        }
    }
    func saveData(){
        do{
            try context.save()
        } catch{
            print("error \(error)")
        }
    }
    
    func loadData(with request:NSFetchRequest<NotesDetails>=NotesDetails.fetchRequest(),predicate: NSPredicate? = nil){
        
        let NotesPredicate = NSPredicate(format: "parentNoteList.name MATCHES %@", selectedNote!.name!)
       
        request.predicate = NotesPredicate
        do {
            editableNote = try context.fetch(request)
        }
        catch
        {
            print("error \(error)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textView.delegate = self
        loadData()
        for notess in editableNote{
            textView.text = notess.notesDetails
        }
    }

    func HoldData(){
        let newNote = NotesDetails(context: self.context)
        newNote.notesDetails = textView.text!
        newNote.parentNoteList = self.selectedNote
        self.editableNote.append(newNote)
        self.saveData()
    }


}

