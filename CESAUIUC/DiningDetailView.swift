//
//  DiningDetailView.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 3/4/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

protocol diningDetailViewDelegate {
    
    func backToMain()
    func changeResidentHall()
}


class DiningDetailView: UIView, UITableViewDelegate, UITableViewDataSource, ikenDelegate{
    var diningTableView : UITableView!
    var selectedResidentIndex : Int!
    var myBandView : UIView!
    var ikenList : DiningIkenberryView!
    var restBtn : UIButton!
    var ikenListExist : Bool!
    var menuInfo : Array<AnyObject>!
    var restaurantInfo : Array<AnyObject>!
    var selectedDate : String!
    var delegate : diningDetailViewDelegate!
    convenience init(residentHallNameIndex : Int, firstLaunch : Bool) {
        self.init()
        self.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        self.backgroundColor = UIColor.white
        self.menuInfo = []
        self.restaurantInfo = []
        self.selectedResidentIndex = residentHallNameIndex
        self.ikenListExist = false
        
        diningTableView = UITableView(frame: CGRect(x: 0, y: 60, width: screen_width, height: screen_height-60), style: .plain)
        diningTableView.delegate = self
        diningTableView.dataSource = self
        diningTableView.separatorStyle = .singleLine
        diningTableView.separatorColor = UIColor(white: 151/255, alpha: 0.3)
        diningTableView.backgroundColor = UIColor.clear
        diningTableView.showsVerticalScrollIndicator = false
        diningTableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)
        diningTableView.register(DiningDetailTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        diningTableView.alpha = 0.0
        diningTableView.tableFooterView = UIView()
        self.addSubview(diningTableView)
        
        
        
        
        
        myBandView = UIView(frame: CGRect(x: 0, y: 0, width:screen_width,height: 80))
        myBandView.backgroundColor = orangeTheme
        myBandView.layer.shadowColor = UIColor(white: 155.0/255, alpha: 0.9).cgColor
        myBandView.layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
        myBandView.layer.shadowOpacity = 0.9
        self.addSubview(myBandView)
        
        let functionTitle = UILabel(frame: CGRect(x: 0, y: 20, width: screen_width, height: 60))
        functionTitle.text = "Dining"
        if firstLaunch == false{
            functionTitle.text = residentHallMenuList[self.selectedResidentIndex]
        }
        functionTitle.textColor = UIColor.white
        functionTitle.textAlignment = .center
        functionTitle.font = UIFont(name: "Avenir-Light", size: 19)
        myBandView.addSubview(functionTitle)
        
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 60, height: 60))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(DiningDetailView.backToMainMenu), for: .touchUpInside)
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(18, 18, 18, 18)
        self.addSubview(backBtn)
        
        
        let changeBtn = UIButton(frame: CGRect(x: screen_width-60, y: 19, width: 60, height: 60))
        changeBtn.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        changeBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        changeBtn.backgroundColor = UIColor.clear
        changeBtn.setTitleColor(UIColor.white, for: .normal)
        changeBtn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
        changeBtn.addTarget(self, action: #selector(DiningDetailView.changeResidentHall), for: .touchUpInside)
        self.addSubview(changeBtn)
        
        
        if firstLaunch == false{
            if self.selectedResidentIndex == 4{
                restBtn = UIButton(frame: CGRect(x: screen_width/2 - 30, y: 26, width: 110, height: 50))
                restBtn.backgroundColor = UIColor.clear
                //restBtn.setImage(#imageLiteral(resourceName: "down"), for: .normal)
                restBtn.addTarget(self, action: #selector(DiningDetailView.ikenListShow), for: .touchUpInside)
                //restBtn.imageEdgeInsets = UIEdgeInsetsMake(18, 18, 18, 18)
                self.addSubview(restBtn)
                
                
                let restBtnImage = UIButton(frame: CGRect(x: 60, y: 0, width: 50, height: 50))
                restBtnImage.setImage(#imageLiteral(resourceName: "down"), for: .normal)
                restBtnImage.imageEdgeInsets = UIEdgeInsetsMake(18, 18, 18, 18)
                restBtnImage.addTarget(self, action: #selector(DiningDetailView.ikenListShow), for: .touchUpInside)
                restBtn.addSubview(restBtnImage)
                
                
            }
            
            
            
            
            
            let today = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM_dd_yyyy"
            let dateString = dateFormatter.string(from: today)
            self.selectedDate = dateString
            
            
            self.getDiningInfoWith(hallName: residentHallMenuList[self.selectedResidentIndex],
                                   date: self.selectedDate,
                                   ikenIndex: 0)
        
        
        }else{
            self.emptyState(firstLaunch: firstLaunch)
        }
        
        
        
    }
    
    init(){
        super.init(frame : CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.menuInfo.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let periodSection = self.menuInfo[section] as! [String:AnyObject]
        
        return periodSection["period"] as! String?
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let periodSection = self.menuInfo[section] as! [String:AnyObject]
        //print(section)
        let foodContent = periodSection["food"] as! Array<AnyObject>
        let rowsInSection = foodContent.count
        
        return rowsInSection
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DiningDetailTableViewCell(style: .default, reuseIdentifier: "Cell")
        
        let sections = self.menuInfo[indexPath.section] as! [String:AnyObject]
        let period = sections["food"] as! Array<AnyObject>
        cell.initCellView(menu: period[indexPath.row] as! [String:AnyObject])
        //print(indexPath.section)
        
        
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let sections = self.menuInfo[indexPath.section] as! [String:AnyObject]
        let period = sections["food"] as! Array<AnyObject>
        let foodClassContext = period[indexPath.row] as! [String:AnyObject]
        let foodMenu = foodClassContext["details"] as! Array<String>
        let foodDetailStr = foodMenu.joined(separator: ", ")
        
        
        
        let rowHeight = foodDetailStr.heightWithConstrainedWidth(width: CGFloat(screen_width-Double(100)), font: UIFont(name: "Avenir-Book", size: 12)!)
        
        if rowHeight > 15{
            return 50 + (rowHeight-15)
        }else{
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: 50))
        headerView.backgroundColor = UIColor.white
        let askingText = UILabel(frame: CGRect(x: 15, y: 10, width: screen_width, height: 45))
        askingText.textAlignment = .left
        askingText.textColor = UIColor(white: 70/255, alpha: 0.5)
        let periodSection = self.menuInfo[section] as! [String:AnyObject]
        askingText.text = periodSection["period"] as! String?
        askingText.font = UIFont(name: "Avenir-Heavy", size: 19)
        
        

        
        headerView.addSubview(askingText)
        //headerView.addSubview(changeBtn)
        
        return headerView
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    
    func getDiningInfoWith(hallName : String, date : String, ikenIndex : Int){
        print("Resident Info Loading...")
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = CGPoint(x: screen_width/2, y: screen_height/2)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        let urlString = "http://ec2-54-201-52-64.us-west-2.compute.amazonaws.com:5000/dining/" + hallName + "/" + date
        let url = URL.init(string: urlString)! as URL
        
        DispatchQueue.global(qos: .background).async {
            do{
                
                let urlData = try Data(contentsOf: url)
                print(urlData)
                let urlInfo = try JSONSerialization.jsonObject(with: urlData as Data, options: .allowFragments) as! [String:AnyObject]
                
                
                
                
                self.restaurantInfo = urlInfo["dining_service_unit"] as! Array<AnyObject>
                if !self.restaurantInfo.isEmpty{
                    let mealPeriodInfo = self.restaurantInfo[ikenIndex] as! Dictionary<String, AnyObject>
                    let foodList = mealPeriodInfo["meal_period"] as! Array<AnyObject>
                    self.menuInfo = foodList
                }
                
                //print(foodList)
                
            }catch{
                print(error)
            }
            
            DispatchQueue.main.async {
                print("Done")
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.diningTableView.reloadData()
                
                if self.menuInfo.isEmpty{
                    self.emptyState(firstLaunch: false)
                }else{
                
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                        self.diningTableView.alpha = 1.0
                        
                    }) { (Bool) in
                        
                    }
                }
            }
            
        }
        
        
        
    }
    
    
    
    func backToMainMenu(){
        
        
        
        
        self.delegate.backToMain()
        
    }
    
    
    func changeResidentHall(){
        self.delegate.changeResidentHall()
    }
    
    
    
    func emptyState(firstLaunch: Bool){
        
        let emptyView = UIView(frame: self.diningTableView.frame)
        self.addSubview(emptyView)
        
        let emptyImage = UIImageView(frame: CGRect(x: screen_width/2 - 50, y: screen_height/2-100, width: 100, height: 100))
        emptyImage.image = #imageLiteral(resourceName: "dining")
        emptyView.addSubview(emptyImage)
        
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: Double(emptyImage.frame.origin.y + emptyImage.frame.height), width: screen_width, height: 40))
        if firstLaunch == false{
            emptyLabel.text = "There is no food today"
        }else{
            emptyLabel.text = "Please Select a Resident Hall"
        }
        emptyLabel.font = UIFont(name: "Avenir-Book", size: 15)
        emptyLabel.textColor = UIColor(white: 141.0/255, alpha: 1.0)
        emptyLabel.textAlignment = .center
        emptyView.addSubview(emptyLabel)
    }
    
    
    
    //MARK: IKEN
    func ikenListShow(){
        print("ikenList")
        if self.ikenListExist == false{
            
            self.ikenListExist = true
            
            
            ikenList = DiningIkenberryView()
            ikenList.delegate = self
            ikenList.nameList = self.restaurantInfo
            self.addSubview(ikenList)
            self.insertSubview(ikenList, aboveSubview: self.diningTableView)
            self.insertSubview(ikenList, belowSubview: self.myBandView)
            
            
            myBandView.layer.shadowColor = UIColor.clear.cgColor
            myBandView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            myBandView.layer.shadowOpacity = 0.0
            
            
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.ikenList.ikenNameTableView.frame = CGRect(x: 0, y: 0, width: screen_width, height: 200)
                self.ikenList.dismissBackground.alpha = 1.0
            }) { (Bool) in
                
                
                
            }
        }else{
            
            self.ikenListExist = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.ikenList.ikenNameTableView.frame = CGRect(x: 0, y: -200, width: screen_width, height: 200)
                self.ikenList.dismissBackground.alpha = 0.0
            }) { (Bool) in
                
                self.ikenList.removeFromSuperview()
                self.myBandView.layer.shadowColor = UIColor(white: 155.0/255, alpha: 0.9).cgColor
                self.myBandView.layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
                self.myBandView.layer.shadowOpacity = 0.9
                
            }
            
            
        }
    }
    
    
    func refreshForIken(index : Int){
        
        
        
        self.getDiningInfoWith(hallName: "Ikenberry", date: self.selectedDate, ikenIndex: index)
        self.dismissIkenView()
    }
    
    func dismissIkenView(){
        ikenListExist = false
        UIView.animate(withDuration: 0.3, animations: {
            self.ikenList.ikenNameTableView.frame = CGRect(x: 0, y: -200, width: screen_width, height: 200)
            self.ikenList.dismissBackground.alpha = 0.0
        }) { (Bool) in
            
            self.ikenList.removeFromSuperview()
            
        }

    }
    
    
    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
