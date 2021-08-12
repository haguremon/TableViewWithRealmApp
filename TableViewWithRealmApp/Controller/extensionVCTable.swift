//
//  extensionVCTable.swift
//  TableViewWithRealmApp
//
//  Created by IwasakIYuta on 2021/07/20.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return tasksList?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
//        let realm = try! Realm()
//        let tasks = realm.objects(Tasks.self)
        cell.layer.cornerRadius = 5
        let tasks = tasks[indexPath.row].task
        cell.textLabel!.text = tasks
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
  
    
    //canMoveRowAtでセルを動かすことができる
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      return true
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //並び替えをするときは List<Element>を定義してやった方がやりやすい
        try! realm.write { //realm.writeで削除処理することができる
            let tasks = tasksList[sourceIndexPath.row]//ここをtasksからtasksListに変更してバグがなくった
            tasksList.remove(at: sourceIndexPath.row)
            tasksList.insert(tasks, at: destinationIndexPath.row)
        }
        
    }
     
    
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
         return true
     }

}
