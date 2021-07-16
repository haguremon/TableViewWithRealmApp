//
//  ViewController.swift
//  TableViewWithRealmApp
//
//  Created by IwasakIYuta on 2021/07/16.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var taskTextField: UITextField!
    
    
    
    var tasks = [Tasks]()
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @IBAction func addTaskButton(_ sender: UIButton) {
    
    }

}
extension ViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = tasks[indexPath.row].task
     
        return cell
    }
}

