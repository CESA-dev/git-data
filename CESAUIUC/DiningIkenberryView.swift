//
//  DiningIkenberryView.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 3/11/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

protocol ikenDelegate {
    func refreshForIken(index : Int)
    func dismissIkenView()
}

class DiningIkenberryView: UIView, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    var nameList : Array<AnyObject>!
    var delegate : ikenDelegate!
    var ikenNameTableView : UITableView!
    var dismissBackground : UIView!
    init(){
        super.init(frame: CGRect(x: 0, y: 80, width: screen_width, height: screen_height-80))
        
        self.nameList = []
        
        self.backgroundColor = UIColor.clear
        dismissBackground = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        dismissBackground.backgroundColor = UIColor(white: 120/255, alpha: 1.0)
        dismissBackground.alpha = 0.0
        self.addSubview(dismissBackground)
        
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(DiningIkenberryView.tapBackground(_:)))
        tapDismiss.delegate = self
        dismissBackground.addGestureRecognizer(tapDismiss)
        
        
        ikenNameTableView = UITableView(frame: CGRect(x: 0, y: -200, width: screen_width, height: 200), style: .plain)
        ikenNameTableView.delegate = self
        ikenNameTableView.dataSource = self
        ikenNameTableView.backgroundColor = orangeTheme
        ikenNameTableView.separatorColor = UIColor.white
        ikenNameTableView.isScrollEnabled = false
        ikenNameTableView.tableFooterView = UIView()
        self.addSubview(ikenNameTableView)
        
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameList.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let name = nameList[indexPath.row] as! Dictionary<String, AnyObject>
        cell.textLabel?.text = name["name"] as? String
        cell.textLabel?.textColor = UIColor(white: 255/255, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = orangeTheme
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.delegate.refreshForIken(index: indexPath.row)
        
    }
    
    
    
    func tapBackground(_ sender: UITapGestureRecognizer){
        self.delegate.dismissIkenView()
        print("tap")
    }
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
