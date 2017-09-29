//
//  PostDetailViewController.swift
//  CESAUIUC
//
//  Created by Tianyu Li on 2/19/17.
//  Copyright © 2017 Tianyu Li. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, postDetailDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postDetailView = PostDetailView()
        postDetailView.delegate = self
        self.view.addSubview(postDetailView)
        

        // Do any additional setup after loading the view.
    }
    
    
    func backToLastView(){
        
        _ = self.navigationController?.popViewController(animated: true)
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
