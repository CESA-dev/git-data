//
//  PostFirstView.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 2/12/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

let postInfo = [["read" : true, "title":"PS2 Released","detail":"PS2 is now available on the course website","author":"CESA","postTime":"02/11/2017 10:20AM"],["read" : true, "title":"PS2 Released","detail":"PS2 is now available on the course website","author":"CESA","postTime":"02/11/2017 10:20AM"],["read" : false, "title":"PS2 Released","detail":"PS2 is now available on the course website","author":"CESA","postTime":"02/11/2017 10:20AM"],["read" : false, "title":"PS2 Released","detail":"PS2 is now available on the course website","author":"CESA","postTime":"02/11/2017 10:20AM"],["read" : true, "title":"PS2 Released","detail":"PS2 is now available on the course website","author":"CESA","postTime":"02/11/2017 10:20AM"]]


protocol postFirstViewDelegate {
    func pushBackToMainMenu()
    func pushToPostDetail()
}

class PostFirstView: UIView, UITableViewDelegate, UITableViewDataSource  {
    var postTableView : UITableView!
    var delegate : postFirstViewDelegate!
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        
        self.backgroundColor = UIColor.white
        
        
        postTableView = UITableView(frame: CGRect(x: 0, y: 80, width: screen_width, height: screen_height-80), style: .plain)
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.separatorStyle = .singleLine
        postTableView.separatorColor = UIColor(white: 200/255, alpha: 1.0)
        postTableView.register(PostFirstViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        postTableView.backgroundColor = UIColor.clear
        postTableView.showsVerticalScrollIndicator = false
        postTableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0)
        self.addSubview(postTableView)
        
        
        
        let myBandView = UIView(frame: CGRect(x: 0, y: 0, width:screen_width,height: 80))
        myBandView.backgroundColor = orangeTheme
        myBandView.layer.shadowColor = UIColor(white: 155.0/255, alpha: 0.9).cgColor
        myBandView.layer.shadowOffset = CGSize(width: 0.5, height: 2.0)
        myBandView.layer.shadowOpacity = 0.9
        self.addSubview(myBandView)
        
        let functionTitle = UILabel(frame: CGRect(x: 0, y: 20, width: screen_width, height: 60))
        functionTitle.text = "Post"
        functionTitle.textColor = UIColor.white
        functionTitle.textAlignment = .center
        functionTitle.font = UIFont(name: "Avenir-Light", size: 19)
        myBandView.addSubview(functionTitle)
        
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 60, height: 60))
        backBtn.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        backBtn.addTarget(self, action: #selector(PostFirstView.backToMainMenu), for: .touchUpInside)
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        self.addSubview(backBtn)
        
        /// confirm Btn
        //        let confirmBtn = UIButton(frame: CGRect(x: screen_width-120, y: screen_height-80, width: 90, height: 50))
        //        confirmBtn.backgroundColor = UIColor(red: 115/255, green: 225/255, blue: 119/255, alpha: 1.0)
        //        confirmBtn.layer.cornerRadius = 25
        //        confirmBtn.setTitle("Confirm", for: .normal)
        //        confirmBtn.titleLabel?.textAlignment = .center
        //        confirmBtn.titleLabel?.textColor = UIColor.white
        //        confirmBtn.titleLabel?.font = UIFont(name: "Avenir-Light", size: 15)
        //        self.addSubview(confirmBtn)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postInfo.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostFirstViewCell(style: .default, reuseIdentifier: "Cell")
        
        
        cell.initCellView(info: postInfo[indexPath.row])
        
        //full width for cell seperator
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate.pushToPostDetail()
        
        
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
