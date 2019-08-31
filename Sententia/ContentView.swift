//
//  ContentView.swift
//  Sententia
//
//  Created by Dave Gumba on 2019-08-30.
//  Copyright © 2019 Dave's Organization. All rights reserved.
//

import SwiftUI
import Combine

// MARK:- User Model
struct User: Identifiable, Decodable {
    var id: Int
    
    let displayName, userName, userImage, message, datePosted, location: String
    let numLikes, numDislikes: Int
}

// MARK:- Network Manager
class NetworkManager: BindableObject {
    var didChange = PassthroughSubject<NetworkManager, Never>()

    var users = [User]() {
        didSet {
            didChange.send(self)
        }
    }

    init() {
        guard let url = URL(string: "https://api.myjson.com/bins/1fb713") else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in

            guard let data = data else { return }

            let users = try! JSONDecoder().decode([User].self, from: data)
            DispatchQueue.main.async {
                self.users = users
            }

            print("fetched json")
            }.resume()
    }
}

// MARK:- Image View
struct ImageViewWidget: View {
    
    @ObjectBinding var imageLoader: ImageLoader
    
    init(imageUrl: String) {
        imageLoader = ImageLoader(imageUrl: imageUrl)
    }
    
    var body: some View {
        Image(uiImage: (imageLoader.data.count == 0) ? UIImage(named: "globe_light")! : UIImage(data: imageLoader.data)!)
            .resizable()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 1))
            .frame(width: 70, height: 70)
    }
}

// MARK:- User Row
struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack {
            ImageViewWidget(imageUrl: user.userImage)
            VStack (alignment: .leading) {
                HStack {
                    Text(user.displayName).bold()
                    Text("@\(user.userName)").font(.subheadline)
                    
                    HStack {
                        Text(user.datePosted).font(.footnote).italic()
                    }
                    
                }
                
                VStack (alignment: .trailing) {
                    Text(user.message).lineLimit(nil)
                }

                HStack {
                    Image("thumb_up_dark")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("\(user.numLikes)")
                    Image("thumb_down_dark")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("\(user.numDislikes)")
                    Image("globe_dark")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(user.location).italic()
                }
            }
            
        }
    }
}

// MARK:- Image Loader
class ImageLoader: BindableObject {
    var didChange = PassthroughSubject<Data, Never>()
    
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.data = data
            }
            
            }.resume()
    }
}



// MARK:- Content View
struct ContentView : View {
    
    @State var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.users.identified(by: \.id)) { user in
                    UserRow(user: user)
                }
            }.navigationBarTitle(Text("Sententia"))

        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
