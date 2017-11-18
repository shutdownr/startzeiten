//
//  NewEvent.swift
//  Startzeiten
//
//  Created by Tim Kreuzer on 11/11/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import UIKit
import CoreData

class CoreDataEvent: NSManagedObject
{
    @NSManaged var title:String
    @NSManaged var date:Date
    @NSManaged var persons:NSOrderedSet
}
