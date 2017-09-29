//
//  EWSViewController.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 2/19/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

class EWSViewController: UIViewController, EWSFirstViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ewsView = EWSFirstView()
        ewsView.delegate = self
        self.view.addSubview(ewsView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func pushBackToMainMenu() {
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func pushToPostDetail(){
        
        let ewsDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ewsDetail")
        self.navigationController?.pushViewController(ewsDetailVC!, animated: true)
        
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
