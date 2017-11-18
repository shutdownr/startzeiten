//
//  OldEventTableViewController.swift
//  Startzeiten
//
//  Created by Tim Kreuzer on 11/11/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import UIKit

class OldEventTableViewController: UITableViewController
{

    var persons = [Person]()
    var myTitle = ""
    var myDate = ""
    
    // Viewcontroller methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = myTitle + " am " + myDate
        tableView.separatorStyle = .none
        
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "oldEventTableViewCell", for: indexPath)
        (cell as! OldEventTableViewCell).initialize(person: persons[indexPath.row])
        return cell
    }
    
    // Custom methods
    
    func initialize(event:Event)
    {
        persons = event.persons
        myTitle = event.name
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        myDate = formatter.string(from: event.date)
        persons.sort(by: {
            return $0.0.timePassed < $0.1.timePassed
        })
        for person in persons
        {
            print(person.name)
        }
        
        
        
    }
    
    
}
