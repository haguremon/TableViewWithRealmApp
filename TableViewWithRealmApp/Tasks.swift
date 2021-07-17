//
//  Tasks.swift
//  TableViewWithRealmApp
//
//  Created by IwasakIYuta on 2021/07/16.
//

import Foundation
import RealmSwift

class Tasks : Object {
    @objc dynamic var task: String = ""
    @objc dynamic var createAt = ""

}

class TasksList: Object {
    var tasksList = List<Tasks>() //Tasks型の配列みたいな感じにできる
}

