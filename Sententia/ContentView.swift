//
//  ContentView.swift
//  Sententia
//
//  Created by Dave Gumba on 2019-08-30.
//  Copyright © 2019 Dave's Organization. All rights reserved.
//

import SwiftUI

// MARK:- User Model
struct User: Identifiable {
    var id: Int
    
    let displayName, userName, userImage, message, datePosted, location: String
    let numLikes, numDislikes: Int
}

// MARK:- User Row
struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack {
//            Image("veronica")
//                .resizable()
//                .clipShape(Circle())
//                .overlay(Circle().stroke(Color.gray, lineWidth: 0.5))
//                .frame(width: 70, height: 70)
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
            }.padding(.leading, 5)
            
        }
    }
}


// MARK:- Content View
struct ContentView : View {
    
    let users: [User] = [
        .init(id: 0, displayName: "Cicero", userName: "TulliusCicero", userImage: "veronica", message: "Blah blah blah blah blah", datePosted: "129 AD", location: "Roma", numLikes: 200, numDislikes: 100),
        .init(id: 1, displayName: "Caesar", userName: "GaiusIulius", userImage: "veronica", message: "Veni, vidi, vici.", datePosted: "33 BC", location: "Roma", numLikes: 900, numDislikes: 200),
        .init(id: 2, displayName: "Hadrianus", userName: "AntoninusAmo", userImage: "veronica", message: "I like traveling and GreekI like traveling and GreekI like traveling and GreekI like traveling and Greek", datePosted: "200 AD", location: "Roma", numLikes: 22, numDislikes: 90),
        .init(id: 3, displayName: "Cicero", userName: "TullisadsadusCicero", userImage: "veronica", message: "Blah blah blah blah blah", datePosted: "24 AD", location: "Roma", numLikes: 200, numDislikes: 100),
        .init(id: 4, displayName: "Cicero", userName: "sadada", userImage: "veronica", message: "Blah blah blah blah blah", datePosted: "400 BC", location: "Roma", numLikes: 200, numDislikes: 100),
        
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users.identified(by: \.id)) { user in
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
