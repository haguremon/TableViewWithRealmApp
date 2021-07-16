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
    let realm = try! Realm()
    //var tasks: Results<Element>オブジェクトクエリから返される Realm の自動更新コンテナタイプでクリエなどで操作することができる7/16 22:20
    
    var tasks: Results<Tasks>! //⇦これの意味がわからないから調べる7/16 20時
    //var tasks = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tasks = realm.objects(Tasks.self)//表示した時にTasksのデータを全て取得してる状態にしたい
        tableView.reloadData()
        //print(tasks.count)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    func dialog(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        guard !taskTextField.text!.isEmpty else {
            dialog(title: "追加", message: "値が入っていません")
            return
        }
        let tasks = Tasks()
        tasks.task = taskTextField.text!
        let f = DateFormatter()
        f.setTemplate(.full)
        let now = Date()
        tasks.createAt = f.string(from: now) + "に作成されました"
        do {
            try realm.write({
                realm.add(tasks)
                //self.tasks.append(tasks.task)
            print(tasks)
            })
        } catch {
            print(error)
        }
        print(tasks)
        //print(self.tasks)
      testLabel.text = tasks.task
        tableView.reloadData()

    }
    
    @IBAction func deleteAllButton(_ sender: UIButton) {
        do {
           
            try realm.write {
                realm.deleteAll()
                //self.tasks.removeAll()
                tableView.reloadData()
            }
        } catch  {
            print(error)
        }
    }
    @IBAction func exit(segue: UIStoryboardSegue){}
    

}
extension ViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.tasks.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        let realm = try! Realm()
//        let tasks = realm.objects(Tasks.self)
        let tasks = self.tasks[indexPath.row]
        cell.textLabel!.text = tasks.task
        return cell
    }
    //スワイプして任意のセルを削除する処理追加 7/16 23時
    //セルのindexPathのeditingStyleを決める
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
           try! realm.write { //realm.writeで削除処理することができる
            self.realm.delete(tasks[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    //accessoryButtonがTappedされた時タスクを追加した日とタスクを表示する画面に遷移するようにした7/16　23時40分　明日早くから仕事だから寝ないヤバ杉内
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "VC") as! CreateDateTaskViewController
        vc.task = tasks[indexPath.row].task
        vc.createdLabel = tasks[indexPath.row].createAt
        self.present(vc, animated: true)
    
    
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


