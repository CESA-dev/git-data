//
//  CESAMainMenuView.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 10/23/16.
//  Copyright © 2016 Tianyu Li. All rights reserved.
//

import UIKit


protocol mainMenuViewDelegate {
    func pushFunctionPage(identifier : String)
}


let screen_width = Double(UIScreen.main.bounds.size.width)
let screen_height = Double(UIScreen.main.bounds.size.height)
let functionMenu = [["functionName" : "Laundry",
                     "functionIcon" : "laundry",
                     "functionIdentifier" : "laundryDetail",
                     "functionDescrip" : "Laundry device usage"],
                   /* ["functionName" : "Post",
                     "functionIcon" : "bus",
                     "functionIdentifier" : "post",
                     "functionDescrip" : "Create or join activities"],*/
                    /*["functionName" : "Transportation",
                     "functionIcon" : "bus",
                     "functionIdentifier" : "foo",
                     "functionDescrip" : "Bus scheudle"],*/
                    ["functionName" : "Dining",
                     "functionIcon" : "dining",
                     "functionIdentifier" : "dining",
                     "functionDescrip" : "Menu for all resident halls"],
                    ["functionName" : "EWS",
                     "functionIcon" : "ews",
                     "functionIdentifier" : "ews",
                     "functionDescrip" : "EWS Status"],]

let orangeTheme = UIColor(red: 255/255, green: 174/255, blue: 79/255, alpha: 1.0)


class CESAMainMenuView: UIView, UITableViewDelegate, UITableViewDataSource {
    var menuTableView : UITableView!
    var delegate : mainMenuViewDelegate!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        self.backgroundColor = orangeTheme
        
        //self.fadeCreate()
        
        let schoolLogo = UIButton(frame: CGRect(x: screen_width/2 - 30, y: 43, width: 60, height: 60))
        schoolLogo.setImage(#imageLiteral(resourceName: "cesa logo clear"), for: .normal)
        schoolLogo.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.addSubview(schoolLogo)
        
        
        
        
        
        
        
        menuTableView = UITableView(frame: CGRect(x: 0, y: 120, width: screen_width, height: screen_height-120), style: .plain)
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(CESAMainMenuTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        menuTableView.separatorStyle = .none
        menuTableView.backgroundColor = UIColor.clear
        self.addSubview(menuTableView)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return functionMenu.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CESAMainMenuTableViewCell(style: .default, reuseIdentifier: "Cell")
        
        //cell.textLabel?.text = functionMenu[indexPath.row]
        cell.initCardView(function:functionMenu[indexPath.row])
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        
        
        
        
        ///////这里要改成每个view有一个viewcontroller！！！！！！！！！！！！！
        print(functionMenu[indexPath.row]["functionIdentifier"]!)
        self.delegate.pushFunctionPage(identifier: functionMenu[indexPath.row]["functionIdentifier"]!)
        

        
        
    }
    
    
    
    func fadeCreate(){
        let topOrange : UIColor = UIColor(red: 244/255, green: 173/255, blue: 97/255, alpha: 1.0)
        let bottomRed : UIColor = UIColor(red: 235/255, green: 100/255, blue: 95/255, alpha: 1.0)
        
        let fadeBottom = UIView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        fadeBottom.backgroundColor = topOrange
        fadeBottom.isUserInteractionEnabled = false
        fadeBottom.layer.cornerRadius = 4.0
        self.addSubview(fadeBottom)
        
        
        
        
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = fadeBottom.bounds
        gradientLayer.colors = [
            topOrange.cgColor,
            bottomRed.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0);
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0);
        // Use the gradient layer as the mask
        fadeBottom.layer.mask = gradientLayer;
        
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
