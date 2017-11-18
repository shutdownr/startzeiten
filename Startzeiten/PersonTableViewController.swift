//
//  PersonTableViewController.swift
//  TableView
//
//  Created by Tim Kreuzer on 18/10/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import UIKit
import CoreData

class PersonTableViewController: UITableViewController, PersonClickedProtocol
{
    
    var persons = [Person]()
    var maxWidth = CGFloat()
    var finishing = false
    
    var eventTitle = "Neues Event"
    
    // Viewcontroller methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        navigationItem.title = eventTitle
        finishing = false
        
        let notificationCenter = NotificationCenter.default;
        notificationCenter.addObserver(self, selector: #selector(PersonTableViewController.reopenApp), name:Notification.Name("reopenApp"), object: nil)
        
        var myDict = [Int:Person]()
        UserDefaults.standard.dictionaryRepresentation().keys.forEach(
        {key in
            if(Int(key) != nil)
            {
                myDict[Int(key)!] = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.data(forKey: key)!) as? Person
            }
        })
        
        var i = 0
        
        while(i<myDict.count)
        {
            persons.append(myDict[i]!)
            i+=1
        }
        
        i = 0
        persons.reverse()
        for person in persons
        {
            createCell(person, i)
            i+=1
        }
        persons.reverse()
        
        // Add the placeholder if it's a new event
        if(persons.count==0)
        {
            persons.append(Person())
        }
      
        tableView.reloadData()

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        print("viewWillDisappear")
        saveData()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        let notificationCenter = NotificationCenter.default;
        notificationCenter.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="backToMainScreen")
        {
            finishing = true
            
            let event = Event(name: eventTitle, date: Date(),persons: persons)
            
            
            
            print("Clearing data...")
            clearData()
            let navController = segue.destination as! UINavigationController
            (navController.viewControllers.first as! MainViewController).eventFinished(event: event)
        }
    }
    
    // Tableview methods
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return persons.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "PersonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonTableViewCell else
        {
            fatalError("The dequeued cell is not an instance of PersonTableViewCell")
        }
        
        cell.cellDelegate = self
        //cell.initialize(persons[indexPath.row])
        //maxWidth = cell.personTextField.frame.width
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        
        if(indexPath.row==persons.count-1)
        {
            return false;
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let cell = tableView.cellForRow(at: indexPath) as! PersonTableViewCell
            cell.finish()
            
            persons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Löschen"
    }

    // IBActions
    
    
    @IBAction func completeEvent(_ sender: UIBarButtonItem)
    {
        var allFinished = true
        for person in persons
        {
            if(!person.finished && person.started)
            {
                allFinished = false
                break
            }
        }
        
        if(allFinished)
        {
            performSegue(withIdentifier: "backToMainScreen", sender: self)
        }
        else
        {
            let alert = UIAlertController.init(title: "Abschließen", message: "Alle verbleibenden Zeiten stoppen?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: {_ in self.performSegue(withIdentifier: "backToMainScreen", sender: self)}))
            
            alert.addAction(UIAlertAction.init(title: "Abbrechen", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    // Custom methods
    func addPerson()
    {
        persons.append(Person())
        tableView.reloadData()
    }
    
    func clearData()
    {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        defaults.synchronize()
    }
    
    func saveData()
    {
        
        if(finishing)
        {
            return
        }
        clearData()
        print("Saving data...")
        var i = 0
        for person in persons
        {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: person)
            UserDefaults.standard.set(encodedData,forKey:String(i))
            i+=1
        }
    }
    
    func createCell(_ person: Person,_ row:Int)
    {
        let cell = tableView(tableView, cellForRowAt: IndexPath.init(row: row, section: 0))
        (cell as! PersonTableViewCell).initialize(person)
    }
    
    func reopenApp()
    {
        for cell in tableView.visibleCells
        {
            let cell2 = cell as! PersonTableViewCell
            cell2.synchronizeTime()
        }
    }
    
    
    // Function for aligning the start-buttons on the same x
    // Doesnt work yet... delete text -> Move the buttons
    // Write text in another line -> Button resets to middle
    // Do that later at some point
    func widthChanged(cell: PersonTableViewCell, width: CGFloat)
    {
        if(width >= maxWidth)
        {
            maxWidth = width
            
            for cell in tableView.visibleCells
            {
                (cell as! PersonTableViewCell).startButton.frame.origin.x = maxWidth
            }
        }
    }
    
}

