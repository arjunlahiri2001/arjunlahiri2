//
//  MainViewController.swift
//  wMutater
//
//  Created by Arjun Lahiri on 17/08/2017.
//  Copyright © 2017 Arjun Lahiri. All rights reserved.
//

import UIKit

var name = ""


class MainViewController: UIViewController {
    
    
    @IBOutlet weak var enterName: UITextField!
    
    @IBAction func playGame(_ sender: Any) {
        if(enterName.text != ""){
            name = enterName.text!
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
