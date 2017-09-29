//
//  CESAMainMenuTableViewCell.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 10/23/16.
//  Copyright © 2016 Tianyu Li. All rights reserved.
//

import UIKit

class CESAMainMenuTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCardView(function : [String:String]){
        
        let cardView = UIView(frame: CGRect(x: 25, y: 7.5, width: screen_width-50, height: 85))
        cardView.backgroundColor = UIColor.white
        cardView.layer.cornerRadius = 3
        cardView.layer.shadowOffset = CGSize(width: 0.5, height: 0.3)
        cardView.layer.shadowColor = UIColor(white: 155/255, alpha: 1.0).cgColor
        cardView.layer.shadowOpacity = 0.50
        cardView.layer.shadowRadius = 3
        self.addSubview(cardView)
        
        
        let functionIcon = UIImageView(frame: CGRect(x: 20, y: 22.5, width: 40, height: 40))
        functionIcon.backgroundColor = UIColor.clear
        functionIcon.image = UIImage(named: function["functionIcon"]!)
        cardView.addSubview(functionIcon)
        
        let functionLabel = UILabel(frame: CGRect(x: 80, y: 22.5, width: 200, height: 20))
        functionLabel.text = function["functionName"]! as String
        functionLabel.textColor = orangeTheme
        functionLabel.font = UIFont(name: "Avenir-Roman", size: 15)
        cardView.addSubview(functionLabel)
        
        let functionDescrip = UILabel(frame: CGRect(x: 80, y: 42.5, width: 200, height: 20))
        functionDescrip.text = function["functionDescrip"]! as String
        functionDescrip.textColor = UIColor(white: 155/255, alpha: 0.9)
        functionDescrip.font = UIFont(name: "Avenir-Light", size: 13)
        cardView.addSubview(functionDescrip)
        
    }
    
    
    

}
