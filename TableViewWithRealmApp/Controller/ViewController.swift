//
//  ViewController.swift
//  TableViewWithRealmApp
//
//  Created by IwasakIYuta on 2021/07/16.
//

import UIKit
import RealmSwift
class ViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var taskTextField:
        UITextField!
    
    @IBOutlet weak var testLabel: UILabel!
    
    let realm = try! Realm()
    //var tasks: Results<Element>オブジェクトクエリから返される Realm の自動更新コンテナタイプでクリエなどで操作することができる7/16 22:20
    var tasksList: List<Tasks>!
    var tasks: Results<Tasks>! //⇦これの意味がわからないから調べる7/16 20時
    private var count = 0
    
    //タスクを作成する機能
    func addTask(){
        let tasks = Tasks()//addされた時に毎回インスタン化する
        tasks.task = taskTextField.text!
        let f = DateFormatter()
        f.setTemplate(.full)
        let now = Date()
        tasks.createAt = f.string(from: now) + "に作成されました"
        count += 1
        tasks.id = count
        
        do {
            
            try realm.write({
                
                if tasksList == nil {
                    
                    let tasksList = TasksList()
                    
                    tasksList.tasksList.append(tasks)
                    
                    realm.add(tasksList)
                    
                    self.tasksList = realm.objects(TasksList.self).first?.tasksList
                
                    print(tasks)
                
                } else {
                    
                    self.tasksList.append(tasks)
                
                }
            })
        } catch {
            
            print(error)
        
        }
       
      testLabel.text = tasks.task
        
        tableView.reloadData()
        
        taskTextField.text = ""
        
    }
    
    func taskUpDate(){
       
        guard let selected = self.tableView.indexPathForSelectedRow  else {
            
            dialog(title: "アップデート", message: "タスクが選択されていません")
            
            return
            
        }
            
            let predicate = NSPredicate(format: "task == %@",tasks[selected.row].task)//task一致したやつを指定
            
            if let task = tasks.filter(predicate).first {//一致したデータを作る
                
            try! realm.write({
                task.task = taskTextField.text! //taskTextFieldの値を入れる
                let f = DateFormatter()
                f.setTemplate(.full)
                let now = Date()
                task.createAt = f.string(from: now) + "に変更されました"
                realm.add(task) //それを加えて書き換える
            })
                
                tableView.reloadData()
                
        }
          
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        taskTextField.delegate = self
        allData()
        //        tasks = realm.objects(Tasks.self)//表示した時にTasksのデータを全て取得してる状態にしたい
       
        tableView.allowsSelectionDuringEditing = true
        //tableView.isEditing = true
        //print(tasks.count)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        taskTextField.resignFirstResponder()
    }
    func dialog(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.dismiss(animated: true)
            }
        }
    }
    func allData(){
        
        tasks = realm.objects(Tasks.self)
        
        if let tasksListdata = realm.objects(TasksList.self).first?.tasksList {
       
            tasksList = tasksListdata
       
        }
        tableView.reloadData()
        
    }
    
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        guard !taskTextField.text!.isEmpty else {
            dialog(title: "追加", message: "値が入っていません")
            return
        }
        addTask()
        //tableView.scrollRectToVisible(.infinite, animated: true)
        tableView.scrollToNearestSelectedRow(at: .middle, animated: true)
        taskTextField.resignFirstResponder()
        taskTextField.text = ""
    }
   //タスクをアップデートするボタン 7/18 18時
    @IBAction func taskUpDateButton(_ sender: UIButton) {
        taskUpDate()
    
    }
    @IBAction func deleteAllButton(_ sender: UIButton) {
        
        do {
            tasks = realm.objects(Tasks.self)
            try realm.write {
                //self.tasks.removeAll()
                realm.delete(tasks)
                tableView.reloadData()
            }
        } catch  {
            print(error)
        }
    }
    //昇順と降順にセルを並び替える
    @IBAction func ascSwitchdec(_ sender: UISwitch) {
        
        if sender.isOn {
            //この二つでちゃんと昇順と降順で表示するよになった
            tasks = realm.objects(Tasks.self).sorted(byKeyPath: "task", ascending: false)
            tasks = realm.objects(Tasks.self).sorted(byKeyPath: "createAt", ascending: false)
            //tasks = realm.objects(Tasks.self).sorted(byKeyPath: "id", ascending: false)
            
            try! realm.write({
                realm.add(tasks)
            })
            tableView.reloadData()
            
        } else {
            tasks = realm.objects(Tasks.self).sorted(byKeyPath: "task", ascending: true)
            tasks = realm.objects(Tasks.self).sorted(byKeyPath: "createAt", ascending: true)
            //tasks = realm.objects(Tasks.self).sorted(byKeyPath: "id", ascending: true)
            try! realm.write({
                realm.add(tasks)
            })
        
            tableView.reloadData()


        }
        
        
    
    
    }
    //セルの編集モード切り替えボタン
    @IBAction func editingSwitch(_ sender: UISwitch) {
        if sender.isOn {
            tableView.isEditing = true
        } else {
            tableView.isEditing = false
        }
    
    }
    
    
    @IBAction func exit(segue: UIStoryboardSegue){}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
        self.view.endEditing(true)
    }
}

extension DateFormatter {
    enum Template: String {
        case date = "yMd"     // 2021/1/1
        case time = "Hms"     // 12:39:22
        case full = "yMdkHms" // 2021/1/1 12:39:22
        case onlyHour = "k"   // 17時
        case era = "GG"       // "西暦" (default) or "平成" (本体設定で和暦を指定している場合)
        case weekDay = "EEEE" // 日曜日
    }

    func setTemplate(_ template: Template) {
        // optionsは拡張用の引数だが使用されていないため常に0
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }
}



