//
//  EventTableViewCell.swift
//  Startzeiten
//
//  Created by Tim Kreuzer on 05/11/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import UIKit

class MainViewCell: UITableViewCell
{

    @IBOutlet var personCountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    //Tableviewcell methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        titleLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Custom methods
    func initialize(_ event: Event)
    {
        personCountLabel.text = "\(event.personCount) Teilnehmer"
        print(event.date.description)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: event.date)
        titleLabel.text = event.name
        
    }

}
