//
//  OldEventTableViewCell.swift
//  Startzeiten
//
//  Created by Tim Kreuzer on 11/11/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import UIKit

class OldEventTableViewCell: UITableViewCell
{

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var timeTextField: UILabel!
    @IBOutlet var startButton: UIButton!
    // Tableviewcell methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // Custom methods
    func initialize(person:Person)
    {
        nameTextField.text = person.name
        timeTextField.text = getTime(person: person)
    }
    
    func getTime(person:Person) -> String
    {
        var result = ""
        
        let minutes = Int(person.timePassed/60)
        let seconds = Int(person.timePassed%60)
        
        let formatter = NumberFormatter()
        formatter.maximumIntegerDigits = 2
        formatter.minimumIntegerDigits = 2
        
        result += formatter.string(from: NSNumber(value: minutes))!
        result += ":"
        result += formatter.string(from: NSNumber(value: seconds))!
        
        
        return result
    }

}
