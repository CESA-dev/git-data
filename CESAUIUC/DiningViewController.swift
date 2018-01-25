//
//  DiningViewController.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 3/5/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

protocol diningViewVCDelegate {
    func refreshDetail()
}


class DiningViewController: UIViewController, diningListViewDelegate {
    var delegate : diningViewVCDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let diningListView = DiningListView()
        diningListView.delegate = self
        self.view.addSubview(diningListView)
        
        
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pushToDiningDetail(indexRow: Int) {
        UserDefaults.standard.set(indexRow, forKey: "diningIndex")
        
        //refresh
        self.delegate.refreshDetail()
        
        self.dismiss(animated: true) {
            
            
        }
        
        
    }
    
    func dismissFirstView(){
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
