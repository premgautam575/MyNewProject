//
//  FirstTableViewCell.swift
//  MyNewProject
//
//  Created by prem  on 13/09/23.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

    @IBOutlet weak var songTitleLbl: UILabel!
    
    @IBOutlet weak var songArtistLbl: UILabel!
    
    @IBOutlet weak var pushViewBtn: UIButton!
    
    
    var tabledata:ResponseData? {
        didSet{
            
            self.songTitleLbl.text = tabledata?.name
            self.songArtistLbl.text = tabledata?.artist
            
            
        }
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
