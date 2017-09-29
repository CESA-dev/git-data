//
//  DiningDetailTableViewCell.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 3/4/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

class DiningDetailTableViewCell: UITableViewCell {

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
    
    func initCellView(menu : [String:AnyObject]){
        
        let foodMenu = menu["details"] as! Array<String>
        let foodClass = menu["food_class"] as! String
        print(menu)
        
        let foodClassLabel = UILabel(frame: CGRect(x: 15, y: 25-10, width: 80, height: 20))
        foodClassLabel.text = foodClass
        if foodClass ==  "Salads & Salad Bar"{
            foodClassLabel.text = "Salad Bar"
        }
        foodClassLabel.textColor = UIColor(white: 180/255, alpha: 1.0)
        foodClassLabel.font = UIFont(name: "Avenir-Roman", size: 13)
        self.contentView.addSubview(foodClassLabel)
        
        
        let foodDetailStr = foodMenu.joined(separator: ", ")
        
        let foodDetailLabelOriginX = Double(foodClassLabel.frame.origin.x + foodClassLabel.frame.width)
        let foodDetailLabel = UITextView(frame: CGRect(x: foodDetailLabelOriginX, y: 25-7.5, width: screen_width-foodDetailLabelOriginX, height: 15))
        foodDetailLabel.font = UIFont(name: "Avenir-Book", size: 12)
        foodDetailLabel.text = foodDetailStr
        foodDetailLabel.textColor = UIColor(white: 130/255, alpha: 1.0)
        foodDetailLabel.isEditable = false
        foodDetailLabel.isUserInteractionEnabled = false
        foodDetailLabel.textContainerInset = UIEdgeInsets.zero
        foodDetailLabel.textContainer.lineFragmentPadding = 0
        
        let textHeight = foodDetailStr.heightWithConstrainedWidth(width: CGFloat(screen_width-Double(100)), font: UIFont(name: "Avenir-Book", size: 12)!)
        if textHeight > 15{
            foodDetailLabel.frame = CGRect(x: foodDetailLabelOriginX, y: 25-7.5, width: screen_width-foodDetailLabelOriginX, height: Double(textHeight))
        }
        
        
        
        self.contentView.addSubview(foodDetailLabel)

        
        
        
    }

}
