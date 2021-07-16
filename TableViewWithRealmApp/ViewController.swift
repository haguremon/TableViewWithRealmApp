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
    
    @IBOutlet weak var taskTextField:
        UITextField!
    
    @IBOutlet weak var testLabel: UILabel!
    
    
    
    
    var tasks = [Tasks]()
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    func dialog(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        guard taskTextField.text == nil else { //空文字は入れませんよー
            dialog(title: "登録", message: "emailが登録されていません")
            return
        }
        let tasks = Tasks()
        tasks.task = taskTextField.text!
        let realm = try! Realm()
        do {
            try realm.write({
                realm.add(tasks)
                self.tasks.append(tasks)
            })
        } catch {
            print(error)
        }
        print(tasks)
        print(self.tasks)
        testLabel.text = tasks.task
    }
    
    @IBAction func deleteAllButton(_ sender: UIButton) {
        do {
           let realm = try Realm()
            try realm.write {
                realm.deleteAll()
                self.tasks.removeAll()
            }
        } catch  {
            print(error)
        }
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

