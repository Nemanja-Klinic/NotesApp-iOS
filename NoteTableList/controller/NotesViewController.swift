//
//  NotesViewController.swift
//  NoteTableList
//
//  Created by Nemanja Klinic on 23.7.22..
//

import UIKit
import CoreData

var notes = [Note]()
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

class NotesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    func fetchData(){
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try context.fetch(request)
        } catch{
            print(error)
        }
        tableView.reloadData()
    }
}

extension NotesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! NoteCell
        let note = notes[indexPath.row]
        cell.titleLbl.text = note.title
        cell.descLbl.text = note.desc
//        cell.textLabel?.text = dummy[indexPath.row][0]
//        cell.titleLbl.text = dummy[indexPath.row][0]
//        cell.descLbl.text = dummy[indexPath.row][1]
        return cell
    }
}
extension NotesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editNote", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote"{
            let indexPath = tableView.indexPathForSelectedRow!
            
            let editVC = segue.destination as? NoteViewController
            
            let sel_note = notes[indexPath.row]
            
            editVC!.selectedNote = sel_note
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
