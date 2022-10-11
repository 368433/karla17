//
//  Diagnosis.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-10.
//

import Foundation

struct Diagnosis: Identifiable, Hashable {
    var id: String
    var name = "Pneumonia"
    var icdCode = "1324"
    var information = ""
    
    init(){
        self.id = self.icdCode
    }
}
