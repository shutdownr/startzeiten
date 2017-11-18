//
//  MainViewController.swift
//  Startzeiten
//
//  Created by Tim Kreuzer on 22/10/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITableViewController
{

    var alert = UIAlertController()
    
    @IBOutlet var addEventButton: UIBarButtonItem!
    @IBOutlet var currentEventButton: UIBarButtonItem!
    
    var savedEvents = [Event]()
    
    // Viewcontroller methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Navigationbar configuration
        navigationItem.rightBarButtonItems = nil
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = addEventButton
        
        
        // Alertdialog configuration
        alert = UIAlertController.init(title: "Event-Name", message: "Den Event-Namen eingeben", preferredStyle:.alert)
        let cancel = UIAlertAction.init(title: "Abbrechen", style: .cancel, handler: nil)
        
        let done = UIAlertAction.init(title: "Erstellen", style: .default, handler: {_ in
            self.navigationItem.rightBarButtonItem = self.currentEventButton
            self.performSegue(withIdentifier: "addNewEvent", sender: self)
        })
        
        alert.addAction(cancel)
        alert.addAction(done)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?[0].autocapitalizationType = .words
        
        // CoreData setup
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        
        // Try to load events
        let eventRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventData")
        eventRequest.returnsObjectsAsFaults = false
        do
        {
            let events = try context.fetch(eventRequest)
            
            if(events.count>0)
            {
                for event in events as! [NSManagedObject]
                {
                    guard let title = event.value(forKey: "title") as? String
                        else { return }
                    guard let date = event.value(forKey: "date") as? Date
                        else { return }
                    
                    let persons = getPersons(set: event.value(forKey: "persons") as! NSOrderedSet)
                    
                    
                    print("Event Title: \(title)")
                    print("Event Date: \(date)")
                    print("Person Count: \(persons.count)")
                    
                    
                    let e = Event(name: title, date: date, persons: persons)
                    e.personCount = persons.count
                    
                    savedEvents.append(e)
                }
            }
            else
            {
                print("No events found")
            }
            
        } catch {
            print("Error while loading events")
        }
        
        //Bring the newest events up
        savedEvents.reverse()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier! {
        case "addNewEvent":
            (segue.destination as! PersonTableViewController).eventTitle = (alert.textFields?[0].text)!
        case "displayOldEvent":
            let row = tableView.indexPathForSelectedRow?.row
            (segue.destination as!OldEventTableViewController).initialize(event: savedEvents[row!])
        default:
            print("Could not prepare for segue...")
        }
    }
    
    
    //Tableview-methods
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return savedEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "MainViewCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MainViewCell else
        {
            fatalError("The dequeued cell is not an instance of EventTableViewCell")
        }
        cell.initialize(savedEvents[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        //Support editing here
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if(editingStyle == .delete)
        {
            savedEvents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "EventData")
            let result = try? context.fetch(fetchRequest)
            context.delete(result?[indexPath.row] as! NSManagedObject)
            

            
            do
            {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Löschen"
    }
   
    
    //IBActions
    
    @IBAction func addNewEvent(_ sender: UIBarButtonItem)
    {
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func currentEvent(_ sender: UIBarButtonItem)
    {
        self.performSegue(withIdentifier: "addNewEvent", sender: self)
    }
    


    
    //Custom methods
    func eventFinished(event:Event)
    {
        navigationItem.rightBarButtonItem = addEventButton
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        
        //Event creation
        let e = CoreDataEvent(entity: NSEntityDescription.entity(forEntityName: "EventData", in: context)!, insertInto: context)
        e.date = event.date
        e.title = event.name
        e.persons = NSOrderedSet()
        //Person creation
        
        //Removing the last element since that's the placeholder
        event.persons.removeLast()
        
        for person in event.persons
        {
            let p = CoreDataPerson(entity: NSEntityDescription.entity(forEntityName: "PersonData", in: context)!, insertInto: context)
            p.name = person.name
            p.timePassed = Int32.init(exactly: person.timePassed)!
            let set = e.persons.mutableCopy() as! NSMutableOrderedSet
            set.add(p)
            e.persons = set.mutableCopy() as! NSOrderedSet
            
        }
        
        do
        {
            try context.save()
            print("Saved!")
        } catch  {
            print("Error while saving events!")
        }
        
    }
    
    func getPersons(set:NSOrderedSet) -> [Person]
    {
        
        var persons = [Person]()
        
        for person in set
        {
            let person2 = person as! PersonData
            let p = Person()
            p.name = person2.name!
            p.timePassed = Int(person2.timePassed)
            persons.append(p)
        }
        
        return persons
    }

}
