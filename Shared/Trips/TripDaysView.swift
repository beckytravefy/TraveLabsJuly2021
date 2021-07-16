////
////  SwiftUIView.swift
////  SwiftUIView
////
////  Created by Becky Henderson on 7/16/21.
////
//
//import SwiftUI
//
//struct TripDaysView: View {
//    @ObservedObject var trip: TripReportTemp
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            AsyncImage(url: URL(string: trip.imageUrl)) { image in
//                image.resizable().aspectRatio(.fill, contentMode: .fit)
//            } placeholder: {
//                Color.gray
//            }
//            .frame(height: 100)
//        }
//    }
//}
//
//struct TripDaysView_Previews: PreviewProvider {
//    static var previews: some View {
//        let trip = TripReportTemp(id: 1, name: "Test Trip", imageUrl: "https://s3.amazonaws.com/travefy-storage/travefy-storage/user-content/55e6d4414354af14f1dc8460962a3e761137d6e44e507749702e7ad39f4fcd_640.jpg")
//        TripDaysView(trip: trip)
//    }
//}
