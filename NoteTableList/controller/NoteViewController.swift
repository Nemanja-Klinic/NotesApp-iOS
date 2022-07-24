//
//  NoteViewController.swift
//  NoteTableList
//
//  Created by Nemanja Klinic on 23.7.22..
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
    
    @IBOutlet weak var descTa: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    
    var selectedNote: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedNote != nil{
            descTa.text = selectedNote?.description
            titleTF.text = selectedNote?.title
        }
    }
    
    

    @IBAction func deleteNote(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if selectedNote != nil {
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            do {
                notes = try context.fetch(request)
                for note in notes{
                    if note == selectedNote {
                        if let index = notes.firstIndex(of: note) {
                            context.delete(note)
                            notes.remove(at: index)
                            do{
                                try context.save()
                            }catch{
                                print("Error saving a note: \(error)")
                            }
                        }
                    }
                }
            } catch{
                print(error)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        if selectedNote == nil {
            
            let newNote = Note(context: context)
            newNote.title = titleTF.text!
            newNote.desc = descTa.text!
            notes.append(newNote)
            
            do{
                try context.save()
            }catch{
                print("Error saving a note: \(error)")
            }
        }else {
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            do {
                notes = try context.fetch(request)
                for note in notes{
                    if note == selectedNote {
                        note.title = titleTF.text
                        note.desc = descTa.text
                        try context.save()
                    }
                }
            } catch{
                print(error)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
