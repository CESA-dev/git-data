//
//  DiningDetailViewController.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 3/4/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

class DiningDetailViewController: UIViewController, diningDetailViewDelegate, diningViewVCDelegate {
    var diningDetail : DiningDetailView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        var firstLaunch = false
        var residentHallNameIndex = 0
        if UserDefaults.standard.value(forKey: "diningIndex") == nil{
            //show resident hall view controller
            firstLaunch = true
            let residentHallListVC = DiningViewController()
            residentHallListVC.delegate = self
            self.present(residentHallListVC, animated: true, completion: {
                
                
            })
            
        }else{
            residentHallNameIndex = UserDefaults.standard.object(forKey: "diningIndex")! as! Int
        }
        
            
        diningDetail = DiningDetailView(residentHallNameIndex: residentHallNameIndex , firstLaunch: firstLaunch)
        diningDetail.delegate = self
        self.view.addSubview(diningDetail)
            
            
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func backToMain(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func changeResidentHall() {
        let residentHallListVC = DiningViewController()
        residentHallListVC.delegate = self
        self.present(residentHallListVC, animated: true, completion: {
            
            
        })
        
        
    }
    
    
    func refreshDetail() {
        let residentHallNameIndex = UserDefaults.standard.object(forKey: "diningIndex")!
        
        if diningDetail != nil{
            diningDetail.removeFromSuperview()
        }
        
        diningDetail = DiningDetailView(residentHallNameIndex: residentHallNameIndex as! Int, firstLaunch: false)
        diningDetail.delegate = self
        diningDetail.diningTableView.frame = CGRect(x: 0, y: 80, width: screen_width, height: screen_height-60)
        self.view.addSubview(diningDetail)
        
        
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
