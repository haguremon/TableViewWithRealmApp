//
//  extensionVC.swift
//  TableViewWithRealmApp
//
//  Created by IwasakIYuta on 2021/07/18.
//

import Foundation
import UIKit
//TextFielｄのイベント通知
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()//Returnが押された時にキーボードを閉じるようにする
        
        guard !taskTextField.text!.isEmpty else{
            dialog(title: "未入力", message: "値が入っていません")
            return false
        }
        
        if (self.tableView.indexPathsForSelectedRows != nil) {
            taskUpDate()
        }else {
            addTask()
        }
        
        return true
    }

}
