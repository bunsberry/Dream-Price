//
//  Base.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import Foundation

public struct Base {
    static let projectsID = "ProjectsCell"
    static let actionsID = "ActionsCell"
    static let addProjectCellID = "AddProjectCell"
    static let projectCID = "ProjectCCell"
}

extension Notification.Name {
    static let realmError = Notification.Name("Realm Error")
}
