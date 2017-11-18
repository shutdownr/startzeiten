//
//  PersonTableViewCell.swift
//  TableView
//
//  Created by Tim Kreuzer on 18/10/2017.
//  Copyright © 2017 Tim Kreuzer. All rights reserved.
//

import UIKit
import CoreData

class PersonTableViewCell: UITableViewCell, UITextFieldDelegate
{
    
    //MARK: Properties
    
    @IBOutlet weak var personTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addPersonButton: UIButton!
    
    var timer = Timer()
    
    var cellDelegate:PersonClickedProtocol?
    var person = Person()
    // TableViewCell methods
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        person.name = personTextField.text!
        personTextField.resignFirstResponder()
    }
    
    // IBActions
    @IBAction func returnTextField(_ sender: UITextField)
    {
        person.name = personTextField.text!
        sender.resignFirstResponder()
    }
    
    @IBAction func addPerson(_ sender: UIButton)
    {
        addPerson()
    }
    
    @IBAction func scaleTextField(_ sender: UITextField)
    {
        sender.invalidateIntrinsicContentSize()
        // For future use...
        // cellDelegate?.widthChanged(cell: self, width: startButton.frame.origin.x)
    }
    
    @IBAction func start(_ sender: UIButton)
    {
        start()
        person.timeStarted = NSDate().timeIntervalSince1970
    }
    
    // Custom methods
    
    func addPerson()
    {
        personTextField.isHidden = false
        startButton.isHidden = false
        timeLabel.isHidden = false
        
        addPersonButton.isHidden = true
        
        
        person.created = true
        cellDelegate?.addPerson()
        //cellDelegate?.wasCreated(cell: self, person: person)
        
    }

    func initialize(_ object: Person)
    {
        person = object
        print("initializing cell")
        if(person.created)
        {
            print("creating cell")
            personTextField.isHidden = false
            startButton.isHidden = false
            timeLabel.isHidden = false
            
            addPersonButton.isHidden = true
            personTextField.text = person.name
            
            if(person.started)
            {
                
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PersonTableViewCell.timerSync), userInfo: nil, repeats: true)
                startButton.setTitle("Stop", for: .normal)
                print("starting cell")
                synchronizeTime()
            }
            if(person.finished)
            {
                startButton.setTitle("", for: .normal)
                startButton.setImage(UIImage.init(named: "flag.png"), for: .normal)
                startButton.isUserInteractionEnabled = false
                timeLabel.text = getTime()
            }
        }
    
    }
    
    func start()
    {
        person.name = personTextField.text!
        personTextField.resignFirstResponder()
        if(person.started)
        {
            person.finished = true
            timer.invalidate()
            startButton.setTitle("", for: .normal)
            startButton.setImage(UIImage.init(named: "flag.png"), for: .normal)
            startButton.isUserInteractionEnabled = false
        }
        else
        {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PersonTableViewCell.timerSync), userInfo: nil, repeats: true)
            startButton.setTitle("Stop", for: .normal)
        }
        
        person.started = !person.started
    }
    
    func synchronizeTime()
    {
        if(person.started)
        {
            
            let time = (NSDate().timeIntervalSince1970 - person.timeStarted)
            person.timePassed = Int(time.rounded())
            timeLabel.text = getTime()
        }
    }
    
    func timerSync()
    {
        person.timePassed += 1
        timeLabel.text = getTime()
    }
    
    func getTime() -> String
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func finish()
    {
        timer.invalidate()
        
        timeLabel.isHidden = true
        startButton.isHidden = true
        personTextField.isHidden = true
        addPersonButton.isHidden = false
        
        timeLabel.text = "00:00"
        startButton.setTitle("Start", for: .normal)
        startButton.setImage(nil, for: .normal)
        startButton.isUserInteractionEnabled = true
        personTextField.text = ""
        
        
        person.created = false
        person.started = false
        person.finished = false
        person.timePassed = 0

        
    }
    
    
    
    
}
