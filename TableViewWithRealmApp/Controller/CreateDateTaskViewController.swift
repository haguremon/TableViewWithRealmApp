//
//  CreateDateTaskViewController.swift
//  TableViewWithRealmApp
//
//  Created by IwasakIYuta on 2021/07/16.
//

import UIKit

class CreateDateTaskViewController: UIViewController {

    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    @IBOutlet weak var taskLabel: UILabel!
    var createdLabel = ""
    var task = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateCreatedLabel.text = createdLabel
        taskLabel.text = task
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
