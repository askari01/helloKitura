//
//  Schemas.swift
//  CHTTPParser
//
//  Created by Farrukh Askari on 01/04/2019.
//

import Foundation
import SwiftKuery
import SwiftKuerySQLite

class Album: Table {
    let tableName = "Album"
    let Title = Column("Title")
}
