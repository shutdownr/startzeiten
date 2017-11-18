//
//  NewPerson.swift
//  Startzeiten
//
//  Created by Tim Kreuzer on 11/11/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPerson: NSManagedObject
{
    @NSManaged var name:String
    @NSManaged var timePassed:Int32
}
