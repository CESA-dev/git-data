//
//  LaundryDetailViewController.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 2/19/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

class LaundryDetailViewController: UIViewController, laundryDetailDelegate, laundryFirstVCDelegate{
    var laundryDetail : LaundryDetailView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        var firstLaunch = false
        var residentHallNameIndex = 0
        if UserDefaults.standard.value(forKey: "residentIndex") == nil{
            //show resident hall view controller
            firstLaunch = true
            
            let residentHallListVC = LaundryViewController()
            residentHallListVC.delegate = self
            self.present(residentHallListVC, animated: true, completion: {
                
                
            })
        }else{
            residentHallNameIndex = UserDefaults.standard.object(forKey: "residentIndex")! as! Int
        }
        
        
        laundryDetail = LaundryDetailView(residentHallNameIndex: residentHallNameIndex , firstLaunch: firstLaunch)
        laundryDetail.delegate = self
        self.view.addSubview(laundryDetail)

        
        
        
        // Do any additional setup after loading the view.
    }

    func backToLastView(){
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func changeResidentHall() {
        let residentHallListVC = LaundryViewController()
        residentHallListVC.delegate = self
        self.present(residentHallListVC, animated: true, completion: {
            
            
        })

        
    }
    
    
    func refreshDetail(){

        
        let residentHallNameIndex = UserDefaults.standard.object(forKey: "residentIndex")!
        
        if laundryDetail != nil{
            laundryDetail.removeFromSuperview()
        }
        
        laundryDetail = LaundryDetailView(residentHallNameIndex: residentHallNameIndex as! Int, firstLaunch: false)
        laundryDetail.delegate = self
        laundryDetail.machineTableView.frame = CGRect(x: 0, y: 80, width: screen_width, height: screen_height-60)
        self.view.addSubview(laundryDetail)
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
