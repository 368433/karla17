//
//  CoreData+ObjectExtensions.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-18.
//

import Foundation

struct DefaultValues {
    static var defaultListIcon: String = ""
}

extension Worklist {
    var cardsList: [Workcard] {
        if let cards = self.workcards as? Set<Workcard> {
            return Array(cards)
        }
        return []
    }
    
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }
    
    var listIcon: String {
        get { listIcon_ ?? DefaultValues.defaultListIcon }
        set { listIcon_ = newValue }
    }
}

extension Workcard {
    var patient: Patient {
        get {
            guard let patient = patient_ else { fatalError("Patient not assigned to workcard") }
            return patient
        }
        set {
            patient_ = newValue
        }
    }
    

    var primaryDx: String {
        get { primaryDx_ ?? "" }
        set { primaryDx_ = newValue }
    }
}

extension Patient {
    var name: String {
        get{ name_ ?? "" }
        set{ name_ = newValue }
    }
}
