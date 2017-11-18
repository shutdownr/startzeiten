//
//  Event.swift
//  Startzeiten
//
//  Created by Tim Kreuzer on 05/11/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import Foundation

class Event
{
    var persons: [Person]
    var name: String
    var date: Date
    var personCount : Int
    
    init(name:String,date:Date,persons:[Person]) {
        self.persons = [Person]()
        self.name = name
        self.date = date
        self.persons = persons
        personCount = persons.count
    }
    
    
    
    
}
