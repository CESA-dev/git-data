//
//  LaundryDetialViewCellTableViewCell.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 10/26/16.
//  Copyright © 2016 Tianyu Li. All rights reserved.
//

import UIKit

let iphone5Size = 320.0
let iphone5 = (screen_width == iphone5Size)

class LaundryDetialViewCellTableViewCell: UITableViewCell {
    
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
    
    func initCellView(machine : [String:Any]){
        
        
        
        
        let cardView = UIView(frame: CGRect(x: 25, y: 7.5, width: screen_width-50, height: 85))
        cardView.backgroundColor = UIColor.white
        self.addSubview(cardView)
        
        
        let machineName = UILabel(frame: CGRect(x: 80, y: 22.5, width: 200, height: 20))
        if iphone5{
            machineName.frame = CGRect(x: 60, y: 22.5, width: 200, height: 20)
        }
        machineName.text = machine["description"] as! String?
        machineName.textColor = UIColor(white: 155/255, alpha: 1.0)
        machineName.font = UIFont(name: "Avenir-Roman", size: 15)
        cardView.addSubview(machineName)
        
        let functionDescrip = UILabel(frame: CGRect(x: 80, y: 42.5, width: 200, height: 20))
        if iphone5{
            functionDescrip.frame = CGRect(x: 60, y: 42.5, width: 200, height: 20)
        }
        functionDescrip.text = machine["label"]! as? String
        functionDescrip.textColor = UIColor(white: 155/255, alpha: 0.9)
        functionDescrip.font = UIFont(name: "Avenir-Light", size: 14)
        cardView.addSubview(functionDescrip)
        
        let functionIcon = UIImageView(frame: CGRect(x: 15, y: 22.5, width: 40, height: 40))
        if iphone5{
            functionIcon.frame = CGRect(x: 5, y: 22.5, width: 40, height: 40)
        }
        functionIcon.backgroundColor = UIColor.clear
        
        if (machineName.text?.contains("Dry"))!{
            functionIcon.image = #imageLiteral(resourceName: "dryer")
            
        }else{
            functionIcon.image = #imageLiteral(resourceName: "laundry")
            
        }
        cardView.addSubview(functionIcon)
        var statusViewOriginX = screen_width-120
        if iphone5{
            statusViewOriginX = screen_width-110
        }
        
        if machine["status"] as! String? == "In Use"{
            let statusView = UILabel(frame: CGRect(x: statusViewOriginX, y: 42.5-15, width: 60, height: 30))
            statusView.backgroundColor = UIColor.white
            statusView.textColor = orangeTheme
            
            if machine["timeRemaining"] as! String? != "Unknown"{
                //take substring, delete 'rem'
                let remainTimeStr = machine["timeRemaining"] as! String?
                let endIndex = remainTimeStr?.index((remainTimeStr?.endIndex)!, offsetBy: -4)
                statusView.text = remainTimeStr?.substring(to: endIndex!)
                statusView.frame = CGRect(x: statusViewOriginX, y: 42.5-20, width: 60, height: 25)
                
                
                let remainText = UILabel(frame: CGRect(x: statusViewOriginX, y: 42.5, width: 60, height: 20))
                remainText.backgroundColor = UIColor.white
                remainText.textColor = orangeTheme
                remainText.text = "remain"
                remainText.font = UIFont(name: "Avenir-Book", size: 13)
                remainText.textAlignment = .center
                cardView.addSubview(remainText)
                
                    
                
            }else{
                statusView.text = machine["timeRemaining"] as! String?
            }
            statusView.textAlignment = .center
            statusView.font = UIFont(name: "Avenir-Book", size: 13)
            cardView.addSubview(statusView)
            
            
            
        }else if machine["status"] as! String? == "Available"{
            let statusView = UILabel(frame: CGRect(x: statusViewOriginX, y: 42.5-15, width: 60, height: 30))
            statusView.backgroundColor = orangeTheme
            statusView.textColor = UIColor.white
            statusView.text = "Free"
            statusView.textAlignment = .center
            statusView.layer.cornerRadius = 15
            statusView.clipsToBounds = true
            statusView.font = UIFont(name: "Avenir-Light", size: 12)
            cardView.addSubview(statusView)
        }else{
            let statusView = UILabel(frame: CGRect(x: statusViewOriginX, y: 42.5-15, width: 80, height: 30))
            statusView.backgroundColor = UIColor.white
            statusView.textColor = orangeTheme
            statusView.text = machine["status"] as! String?
            statusView.textAlignment = .center
            statusView.font = UIFont(name: "Avenir-Light", size: 12)
            cardView.addSubview(statusView)
        }
        
        
        
    }
    
    
}
