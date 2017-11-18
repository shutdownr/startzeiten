//
//  PersonClickedProtocol.swift
//  Startzeiten
//
//  Created by Tim Kreuzer on 20/10/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import UIKit


protocol PersonClickedProtocol {
    func widthChanged(cell:PersonTableViewCell, width:CGFloat)
    func addPerson()
}
