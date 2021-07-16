//
//  ItemPreview.swift
//  TraveFuture
//
//  Created by Becky Henderson on 7/8/21.
//

import SwiftUI

struct PreviewData {
    let title: String
    let subtitle: String?
    let badgeBackgroundColor: Color?
    let badgeText: String?
    let badgeImageUrl: String?
}

struct ItemPreview: View {
    var data: PreviewData

    var body: some View {
        HStack {
            ZStack() {
                if let backgroundColor = data.badgeBackgroundColor,
                   let badgeText = data.badgeText {
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: 50, height: 50, alignment: .center)
                    Text(badgeText)
                        .background(backgroundColor)
                        .foregroundColor(Color.white)
                }
                else if let imageUrlString = data.badgeImageUrl,
                        let imageUrl = URL(string: imageUrlString) {
                    AsyncImage(url: imageUrl) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(Circle())
                }
            }
            .padding(4)
            VStack(alignment: .leading, spacing: 4) {
                Text(data.title)
                    .font(.headline)
                if let subtitle = data.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
        }

    }
}

struct ItemPreview_Previews: PreviewProvider {
    static var previews: some View {
        let data = PreviewData(title: "John Smith", subtitle: "jsmith@gmail.com", badgeBackgroundColor: .blue, badgeText: "JS", badgeImageUrl: nil)
        ItemPreview(data: data)

        let imagePreviewData = PreviewData(title: "Image Test", subtitle: nil, badgeBackgroundColor: nil, badgeText: nil, badgeImageUrl: "https://s3.amazonaws.com/travefy-storage/travefy-storage/user-content/55e6d4414354af14f1dc8460962a3e761137d6e44e507749702e7ad39f4fcd_640.jpg")
        ItemPreview(data: imagePreviewData)
    }
}
