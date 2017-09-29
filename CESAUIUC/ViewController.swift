//
//  ViewController.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 10/23/16.
//  Copyright © 2016 Tianyu Li. All rights reserved.
//

import UIKit



class ViewController: UIViewController, mainMenuViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        let mainMenu = CESAMainMenuView()
        mainMenu.delegate = self
        self.view.addSubview(mainMenu)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pushFunctionPage(identifier : String){
        
        if identifier == "foo"{
            return
        }
        
        let functionPage = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(functionPage!, animated: true)
        
//        if row == 0{
//            let functionPage = self.storyboard?.instantiateViewController(withIdentifier: "laundry")
//            self.navigationController?.pushViewController(functionPage!, animated: true)
//        }else if row == 1{
//            let functionPage = self.storyboard?.instantiateViewController(withIdentifier: "post")
//            self.navigationController?.pushViewController(functionPage!, animated: true)
//        }else if row == 4{
//            let functionPage = self.storyboard?.instantiateViewController(withIdentifier: "ews")
//            self.navigationController?.pushViewController(functionPage!, animated: true)
//        }
        
    }


}






