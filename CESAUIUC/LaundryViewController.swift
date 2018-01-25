//
//  LaundryViewController.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 2/19/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

protocol laundryFirstVCDelegate {
    func refreshDetail()
    
}


class LaundryViewController: UIViewController, laundryFirstViewDelegate {
    var delegate : laundryFirstVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let laundryView = LaundryFirstView()
        laundryView.delegate = self
        self.view.addSubview(laundryView)
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissFirstView(){
        
        print("pushBack")
        self.dismiss(animated: true) { 
            
            
        }
        
    }
    
    
    
    
    
    func pushToLaundryDetail(indexRow: Int) {
        UserDefaults.standard.set(indexRow, forKey: "residentIndex")
        
        //refresh
        self.delegate.refreshDetail()
        
        self.dismiss(animated: true) {
            
            
        }
        
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
