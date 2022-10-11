//
//  WorklistView.swift
//  karla17
//
//  Created by Amir Mac Pro 2019 on 2022-10-10.
//

import SwiftUI



struct WorklistView_Previews: PreviewProvider {
    static var previews: some View {
        WorklistView(worklist: WorkList())
        WorklistView(worklist: WorkList()).preferredColorScheme(.dark)
    }
}
