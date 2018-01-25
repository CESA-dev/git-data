//
//  EWSFirstViewCell.swift
//  CESAUIUC
//
//  Created by Xiangbin Hu on 3/1/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

//
//  ewsFirstViewCellTableViewCell.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 2/12/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

class EWSFirstViewCell: UITableViewCell {
    
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
    
    func initCellView(ews : [String:Any]){

        
        let cardView = UIView(frame: CGRect(x: 25, y: 7.5, width: screen_width-50, height: 85))
        cardView.backgroundColor = UIColor.white
        self.addSubview(cardView)
        
        
        let functionIcon = UIImageView(frame: CGRect(x: 12, y: 22.5, width: 40, height: 40))
        functionIcon.backgroundColor = UIColor.clear
        functionIcon.image = #imageLiteral(resourceName: "ews")
        cardView.addSubview(functionIcon)
        
        let ewsName = UILabel(frame: CGRect(x: 80, y: 22.5, width: 200, height: 20))
        ewsName.text = ews["strlabname"] as! String?
        ewsName.textColor = UIColor(white: 155/255, alpha: 1.0)
        ewsName.font = UIFont(name: "Avenir-Roman", size: 15)
        cardView.addSubview(ewsName)
        
        let inUseCount = ews["inusecount"] as! Int
        let machineCount = ews["machinecount"] as! Int
        let functionDescrip = UILabel(frame: CGRect(x: 80, y: 42.5, width: 200, height: 20))
        functionDescrip.text = String(inUseCount) + " / " + String(machineCount)
        functionDescrip.textColor = UIColor(white: 155/255, alpha: 0.9)
        functionDescrip.font = UIFont(name: "Avenir-Light", size: 14)
        cardView.addSubview(functionDescrip)
        
        
        let statusView = UILabel(frame: CGRect(x: screen_width-120, y: 42.5-15, width: 30, height: 30))
        
        statusView.font = UIFont(name: "Avenir-Book", size: 15)
        if inUseCount >= machineCount {
            statusView.backgroundColor = UIColor.white
            statusView.textColor = orangeTheme
            statusView.text = "Full"
        }else{
            statusView.backgroundColor = orangeTheme
            statusView.textColor = UIColor.white
            statusView.text = String.init(format: "%d", machineCount-inUseCount)
            statusView.textAlignment = .center
            statusView.layer.cornerRadius = 15
            statusView.clipsToBounds = true
        }
        statusView.frame = CGRect(x: screen_width-120, y: 42.5-12.5, width: 30, height: 30)
        if iphone5{
            statusView.frame = CGRect(x: screen_width-105, y: 42.5-12.5, width: 30, height: 30)
        }
        cardView.addSubview(statusView)
            
        
     
    }
    
    
}
