//
//  Settings.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 28.07.2020.
//

import Foundation

class Settings {
    
    static public var shared = Settings()
    
    private let kRecordCentsOn = "Settings.kRecordCentsOn"
    private let kChosenLocaleIdentifier = "Settings.kChosenLocaleIdentifier"
    
    var recordCentsOn: Bool? {
        get { return UserDefaults.standard.bool(forKey: kRecordCentsOn) }
        set { UserDefaults.standard.set(newValue, forKey: kRecordCentsOn) }
    }
    
    var chosenLocaleIdentifier: String? {
        get { return UserDefaults.standard.string(forKey: kChosenLocaleIdentifier) }
        set { UserDefaults.standard.set(newValue, forKey: kChosenLocaleIdentifier) }
    }
    
}
