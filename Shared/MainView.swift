//
//  MainView.swift
//  TraveFuture
//
//  Created by Becky Henderson on 7/8/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TripsView().tabItem {
                Label("Trips", systemImage: "bag.fill")
            }
            ContactsView().tabItem {
                Label("Contacts", systemImage: "person.fill")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
