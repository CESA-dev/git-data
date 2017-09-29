//
//  PostDetailView.swift
//  PostDetailView
//
//  Created by Jiarui Sun on 2/12/17.
//  Copyright © 2017 Jiarui Sun. All rights reserved.
//

import UIKit

protocol postDetailDelegate {
    func backToLastView()
}

class PostDetailView: UIView {

    let screen_width = Double(UIScreen.main.bounds.size.width)
    let screen_height = Double(UIScreen.main.bounds.size.height)
    let orangeTheme = UIColor(red: 255/255, green: 174/255, blue: 79/255, alpha: 1.0)
    var delegate : postDetailDelegate!
    init(){
        
        super.init(frame : CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        self.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        self.backgroundColor = UIColor.white
        
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
        backBtn.addTarget(self, action: #selector(PostDetailView.backToMainMenu), for: .touchUpInside)
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        self.addSubview(backBtn)
        
        
        let myView = UIView(frame: CGRect(x: 30, y: 120, width: 50,height: 50))
        myView.layer.cornerRadius = 25;
        myView.backgroundColor = UIColor.gray
        self.addSubview(myView)
        
        let myTagView = UILabel(frame: CGRect(x: Int(myView.frame.origin.x)+Int(myView.frame.width)+15 , y: 125, width: 60,height: 20))
        myTagView.backgroundColor = UIColor(red: 239/255, green: 88/255, blue: 106/255, alpha: 1.0)
        myTagView.text = "CESA"
        myTagView.layer.cornerRadius = 2
        myTagView.clipsToBounds = true
        myTagView.font = UIFont(name: "Avenir-Heavy", size: 10)
        myTagView.textAlignment = .center
        myTagView.textColor = UIColor.white
        self.addSubview(myTagView)
        
        let myTimeView = UILabel(frame: CGRect(x: Int(myView.frame.origin.x)+Int(myView.frame.width)+15, y: 150, width: 60,height: 20))
        myTimeView.text = "2 days ago"
        myTimeView.font = UIFont(name: "Avenir-Book", size: 9)
        myTimeView.textColor = UIColor.gray
        self.addSubview(myTimeView)
        
        let myCountView = UILabel(frame: CGRect(x: Int(screen_width) - 30 - 50, y: 125, width: 60,height: 20))
        myCountView.text = "1.1k views"
        myCountView.font = UIFont(name: "Avenir-Book", size: 9)
        myCountView.textColor = UIColor.gray
        self.addSubview(myCountView)
        
        
        let myTextView = UITextView(frame: CGRect(x: Int(myView.frame.origin.x), y: 210, width: Int(screen_width - 2*30),height: 80));
        myTextView.text = "This class will introduce you to the concepts and abstractions central to the development of modern computing systems, with an emphasis on the systems software that controls interaction between devices and other hardware and application programs. We will cover input-output semantics, synchronization, interrupts, multitasking, virtualization of resources, protection, and resource management concepts. You will also be introduced to network and storage device abstractions. In terms of practical skills, you will be exposed to software development tools for source control, debugging, dependency management, and compilation, and will work in the context of a real operating system executing in a virtual machine. "
        myTextView.textColor = UIColor(white: 80.0/255, alpha: 1.0)
        myTextView.font = UIFont(name: "Avenir-Book", size: 13)
        myTextView.isEditable = false
        self.addSubview(myTextView)
        

        
        
        
        
        
    }
    
    
    func backToMainMenu(){
        
        
        
        
        self.delegate.backToLastView()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
