//
//  Person.swift
//  Startzeiten
//
//  Created by Tim Kreuzer on 20/10/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import Foundation
import CoreData

class Person : NSObject, NSCoding
{
    var started = false
    var created = false
    var finished = false
    
    var timePassed = 0
    var name = ""
    var timeStarted = TimeInterval()
    
    override init()
    {
        
    }
    
    required init(coder decoder: NSCoder) {
        name = decoder.decodeObject(forKey: "name") as? String ?? ""
        timeStarted = decoder.decodeDouble(forKey: "timeStarted")
        timePassed = decoder.decodeInteger(forKey: "timePassed")
        created = decoder.decodeBool(forKey: "created")
        started = decoder.decodeBool(forKey: "started")
        finished = decoder.decodeBool(forKey: "finished")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(created, forKey: "created")
        coder.encode(started, forKey: "started")
        coder.encode(finished, forKey: "finished")
        coder.encode(timeStarted, forKey: "timeStarted")
        coder.encode(timePassed,forKey: "timePassed")
    }
    
}
