//
//  TaskTableViewCell.swift
//  Final_ToDoList_App
//
//  Created by Jeremiah Wu  on 15/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
