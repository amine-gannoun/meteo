//
//  DailyMeteoCell.swift
//  Meteo
//
//  Created by Amine on 27/09/2022.
//

import UIKit

class DailyMeteoCell: UITableViewCell {
    
    //MARK: - UI Outelts
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var minMaxLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    //MARK: - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
