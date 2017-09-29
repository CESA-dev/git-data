//
//  EWSFirstView.swift
//  CESAUIUC
//
//  Created by Xiangbin Hu on 3/1/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

protocol EWSFirstViewDelegate {
    func pushBackToMainMenu()
//    func pushToEWSDetail()
}

let ewsURL = "https://my.engr.illinois.edu/labtrack/util_data_json.asp"
let ewsInfo = [["strlabname": "DCL L416","inusecount": 36,"ewscount": 41]]

//
//  LaundryDetailView.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 10/25/16.
//  Copyright © 2016 Tianyu Li. All rights reserved.
//



class EWSFirstView: UIView, UITableViewDelegate, UITableViewDataSource {
    var ewsTableView : UITableView!
    var selectedResidentIndex : Int!
    var ewsStatus : Array<Dictionary<String, Any>>!
    var delegate : EWSFirstViewDelegate!
    var ewsURL : String!
    init() {
        super.init(frame : CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        self.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        self.backgroundColor = UIColor.white
        self.ewsStatus = []
//        self.selectedResidentIndex = residentHallNameIndex
        let path = Bundle.main.path(forResource: "env", ofType: "plist")
        let dic = NSDictionary(contentsOfFile: path!) as? [String: Any]
        ewsURL = dic?["EWS_URL"] as! String
        
        ewsTableView = UITableView(frame: CGRect(x: 0, y: 60, width: screen_width, height: screen_height-60), style: .plain)
        ewsTableView.delegate = self
        ewsTableView.dataSource = self
        ewsTableView.separatorStyle = .singleLine
        ewsTableView.separatorColor = UIColor(white: 151/255, alpha: 0.3)
        ewsTableView.backgroundColor = UIColor.clear
        ewsTableView.showsVerticalScrollIndicator = false
        ewsTableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)
        ewsTableView.register(EWSFirstViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        ewsTableView.alpha = 0.0
        self.addSubview(ewsTableView)
        
        
        
        
        
        let myBandView = UIView(frame: CGRect(x: 0, y: 0, width:screen_width,height: 80))
        myBandView.backgroundColor = orangeTheme
        myBandView.layer.shadowColor = UIColor(white: 155.0/255, alpha: 0.9).cgColor
        myBandView.layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
        myBandView.layer.shadowOpacity = 0.9
        self.addSubview(myBandView)
        
        let functionTitle = UILabel(frame: CGRect(x: 0, y: 20, width: screen_width, height: 60))
        functionTitle.text = "EWS Status"
        functionTitle.textColor = UIColor.white
        functionTitle.textAlignment = .center
        functionTitle.font = UIFont(name: "Avenir-Light", size: 19)
        myBandView.addSubview(functionTitle)
        
        
        self.refresh()
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 60, height: 60))
        backBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backBtn.addTarget(self, action: #selector(EWSFirstView.backToMainMenu), for: .touchUpInside)
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(18, 18, 18, 18)
        self.addSubview(backBtn)
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.ewsStatus.count
//        print(ewsInfo.count)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EWSFirstViewCell(style: .default, reuseIdentifier: "Cell")
        
        
        cell.initCellView(ews: self.ewsStatus[indexPath.row])
        
        
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: 70))
        headerView.backgroundColor = UIColor.white
        let askingText = UILabel(frame: CGRect(x: 40, y: 30, width: screen_width, height: 30))
        askingText.textAlignment = .left
        askingText.textColor = UIColor.gray
        askingText.text = "Machine Location"
        askingText.font = UIFont(name: "Avenir-Medium", size: 14)


        let changeBtn = UILabel(frame: CGRect(x: screen_width-110, y: 30, width: 80, height: 30))
        if iphone5{
            changeBtn.frame = CGRect(x: screen_width-100, y: 30, width: 80, height: 30)
        }
        changeBtn.text = "#Available"
        changeBtn.backgroundColor = UIColor.clear
        changeBtn.textColor = UIColor.gray
        changeBtn.font = UIFont(name: "Avenir-Medium", size: 14)
        

        headerView.addSubview(askingText)
        headerView.addSubview(changeBtn)
        
        return headerView
        
    }

    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func refresh(){
        print("Info Loading...")
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = CGPoint(x: screen_width/2, y: screen_height/2)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        

        let url = URL.init(string: ewsURL)! as URL
        
        DispatchQueue.global(qos: .background).async {
            do{
                
                let urlData = try Data(contentsOf: url)

                let urlInfo = try JSONSerialization.jsonObject(with: urlData as Data, options: .allowFragments) as! [String:Any]
                
                self.ewsStatus = urlInfo["data"] as! Array<Dictionary<String, Any>>!
                
            }catch{
                print(error)
            }
            
            DispatchQueue.main.async {
                print("Done")
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.ewsTableView.reloadData()
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                    self.ewsTableView.alpha = 1.0
                    
                }) { (Bool) in
                    
                }
            }
            
        }
    
        
        
    }
    
    
    
    
    
    func backToMainMenu(){
        
        
        
        
        self.delegate.pushBackToMainMenu()
        
    }
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
