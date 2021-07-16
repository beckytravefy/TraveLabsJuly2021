//
//  TripsView.swift
//  TraveFuture
//
//  Created by Becky Henderson on 7/15/21.
//

import SwiftUI

struct TripsView: View {
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \TripReport.name, ascending: true)],
//        animation: .default)
//    private var trips: FetchedResults<TripReport>

    let trips = Bundle.main.decode([TripReportTemp].self, from: "tripreports.json")

    var body: some View {
        NavigationView {
            List {
                ForEach(trips) { trip in
                    ItemPreview(data: trip.previewData)
                }
            }
            .navigationTitle("Trips")
        }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
    }
}
