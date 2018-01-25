//
//  LaundryDetailView.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 10/25/16.
//  Copyright © 2016 Tianyu Li. All rights reserved.
//

import UIKit
let residentHallRequestList = ["1107%20West%20Green", "300%20South%20Goodwin", "Allen", "Barton-Lundgren", "Bousfield%20Rm%20103","Busey-Evans","Daniels%20North","Daniels%20South","FAR:%20Oglesby","FAR:%20Trelease","Hopkins","ISR:%20Townsend","ISR:%20Wardall","LAR:%20Leonard","LAR:%20Shelden","Nugent","Nugent%20Rm%20126","Orchard%20Downs%20North","Orchard%20Downs%20South","PAR:%20Babcock","PAR:%20Blaisdell","PAR:%20Carr","PAR:%20Saunders","Scott","Sherman%20Short","Sherman%20Tall","Snyder","TVD:%20Taft","TVD:%20Van%20Doren","Wassaja%20Room%201109","Weston"]

protocol laundryDetailDelegate {
    func backToLastView()
    func changeResidentHall()
}




class LaundryDetailView: UIView, UITableViewDelegate, UITableViewDataSource {
    var machineTableView : UITableView!
    var selectedResidentIndex : Int!
    
    var machineStatus : Array<Dictionary<String, Any>>!
    var delegate : laundryDetailDelegate!
    convenience init(residentHallNameIndex : Int, firstLaunch : Bool) {
        self.init()
        self.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        self.backgroundColor = UIColor.white
        self.machineStatus = []
        self.selectedResidentIndex = residentHallNameIndex
        
        machineTableView = UITableView(frame: CGRect(x: 0, y: 60, width: screen_width, height: screen_height-60), style: .plain)
        machineTableView.delegate = self
        machineTableView.dataSource = self
        machineTableView.separatorStyle = .singleLine
        machineTableView.separatorColor = UIColor(white: 151/255, alpha: 0.3)
        machineTableView.backgroundColor = UIColor.clear
        machineTableView.showsVerticalScrollIndicator = false
        machineTableView.contentInset = UIEdgeInsetsMake(30, 0, 80, 0)
        machineTableView.register(LaundryDetialViewCellTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        machineTableView.alpha = 0.0
        self.addSubview(machineTableView)
        
        
        
        
        
        let myBandView = UIView(frame: CGRect(x: 0, y: 0, width:screen_width,height: 80))
        myBandView.backgroundColor = orangeTheme
        myBandView.layer.shadowColor = UIColor(white: 155.0/255, alpha: 0.9).cgColor
        myBandView.layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
        myBandView.layer.shadowOpacity = 0.9
        self.addSubview(myBandView)
        
        let functionTitle = UILabel(frame: CGRect(x: 0, y: 20, width: screen_width, height: 60))
        functionTitle.text = "Laundry"
        if firstLaunch == false{
            let titleText = residentHallRequestList[residentHallNameIndex]
            functionTitle.text = titleText.replacingOccurrences(of: "%20", with: " ")
        }
        functionTitle.textColor = UIColor.white
        functionTitle.textAlignment = .center
        functionTitle.font = UIFont(name: "Avenir-Light", size: 18)
        myBandView.addSubview(functionTitle)
        
        if firstLaunch == false{
            self.getResidentInfoWith(hallName: residentHallRequestList[residentHallNameIndex])
        }else{
            self.emptyState()
        }
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 60, height: 60))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(LaundryDetailView.backToMainMenu), for: .touchUpInside)
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(18, 18, 18, 18)
        self.addSubview(backBtn)
        
        
        
        let changeBtn = UIButton(frame: CGRect(x: screen_width-60, y: 19, width: 60, height: 60))
        //changeBtn.setTitle("Change", for: .normal)
        changeBtn.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        changeBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        changeBtn.backgroundColor = UIColor.clear
        changeBtn.setTitleColor(UIColor.white, for: .normal)
        changeBtn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
        changeBtn.addTarget(self, action: #selector(LaundryDetailView.changeResidentHall), for: .touchUpInside)
        self.addSubview(changeBtn)

        
        
        
        
        
    }
    
    init(){
        super.init(frame : CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.machineStatus.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LaundryDetialViewCellTableViewCell(style: .default, reuseIdentifier: "Cell")
        
//        cell.textLabel?.text = self.machineStatus[indexPath.row]["status"] as! String?
//        cell.textLabel?.textColor = UIColor(white: 155/255, alpha: 1.0)
//        cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
        cell.initCellView(machine: self.machineStatus[indexPath.row])
        
        
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 80
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: 80))
//        headerView.backgroundColor = UIColor.white
//        let askingText = UILabel(frame: CGRect(x: 40, y: 10, width: screen_width, height: 80))
//        askingText.textAlignment = .left
//        askingText.textColor = UIColor(white: 135/255, alpha: 0.5)
//        askingText.text = residentHallList[selectedResidentIndex]
//        askingText.font = UIFont(name: "Avenir-Heavy", size: 22)
//        
//        
//        let changeBtn = UIButton(frame: CGRect(x: screen_width-90, y: 35, width: 60, height: 30))
//        changeBtn.setTitle("Change", for: .normal)
//        changeBtn.backgroundColor = UIColor.clear
//        changeBtn.setTitleColor(UIColor.gray, for: .normal)
//        changeBtn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 14)
//        changeBtn.addTarget(self, action: #selector(LaundryDetailView.changeResidentHall), for: .touchUpInside)
//        
//        headerView.addSubview(askingText)
//        headerView.addSubview(changeBtn)
//        
//        return headerView
//        
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func getResidentInfoWith(hallName : String){
        print("Resident Info Loading...")
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = CGPoint(x: screen_width/2, y: screen_height/2)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        let urlString = "http://ec2-54-201-52-64.us-west-2.compute.amazonaws.com:5000/laundry/" + hallName
        let url = URL.init(string: urlString)! as URL
        
        DispatchQueue.global(qos: .background).async {
            do{
                
                let urlData = try Data(contentsOf: url)
                print(urlData)
                let urlInfo = try JSONSerialization.jsonObject(with: urlData as Data, options: .allowFragments) as! [String:Any]
                print(urlInfo)
                
                self.machineStatus = urlInfo["machine"] as! Array<Dictionary<String, Any>>!
                
            }catch{
                print(error)
            }
            
            DispatchQueue.main.async {
                print("Done")
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.machineTableView.reloadData()
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.machineTableView.alpha = 1.0
                    
                }) { (Bool) in
                    
                }
            }
            
        }
        
        
        
    }
    
    
    
    
    
    func backToMainMenu(){
        


        
        self.delegate.backToLastView()
        
    }
    
    
    
    func changeResidentHall(){
        self.delegate.changeResidentHall()
    }
    
    
    
    
    
    func emptyState(){
        
        let emptyView = UIView(frame: self.machineTableView.frame)
        self.addSubview(emptyView)
        
        let emptyImage = UIImageView(frame: CGRect(x: screen_width/2 - 50, y: screen_height/2-100, width: 100, height: 100))
        emptyImage.image = #imageLiteral(resourceName: "laundry")
        emptyView.addSubview(emptyImage)
        
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: Double(emptyImage.frame.origin.y + emptyImage.frame.height+15), width: screen_width, height: 40))
        emptyLabel.text = "Please Select a Resident Hall"
        emptyLabel.font = UIFont(name: "Avenir-Book", size: 16)
        emptyLabel.textColor = UIColor(white: 141.0/255, alpha: 1.0)
        emptyLabel.textAlignment = .center
        emptyView.addSubview(emptyLabel)
    }

    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
