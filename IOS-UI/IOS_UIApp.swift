//
//  IOS_UIApp.swift
//  IOS-UI
//
//  Created by jpineros on 5/03/22.
//

import SwiftUI

@main
struct IOS_UIApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                SearchView()
            }
        }
    }
}
