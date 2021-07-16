//
//  AsyncImage.swift
//  TraveFuture
//
//  Created by Becky Henderson on 7/16/21.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()

    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

struct CustomAsyncImage: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()

    init(with url: String) {
        imageLoader = ImageLoader(urlString: url)
    }

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onReceive(imageLoader.didChange, perform: { imageData in
                image = UIImage(data: imageData) ?? UIImage()
            })
    }
}

struct CustomAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CustomAsyncImage(with: "https://s3.amazonaws.com/travefy-storage/travefy-storage/user-content/55e6d4414354af14f1dc8460962a3e761137d6e44e507749702e7ad39f4fcd_640.jpg")
            .frame(width: 100, height: 100)
    }
}
