//
//  InfoView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 26/06/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            
            ScrollView(.vertical) {
                
                VStack {
                    
                    Text("A password is your first line of defence and a good strong and complex password is the best way to prolong any attempts for someone to try and break into an account or cause them to give up. \n\nThe formula for a strong and complex password involves a mixture of uppercase and lowercase letters, numbers, special symbols and length. \n\nThis app helps with getting the right combination of these elements to create the password you will use to protect your accounts. Your password strength is based on a points system with a higher point count equalling a stronger password. \n\nUmbriel also comes with a secure vault where you can store your passwords where only you can access using your FaceID or TouchID sensors*.\n\n")
                        .font(.system(.body, design: .rounded))
                        
                    Text("*TheVault requires you to have your fingerprint or face registered to your device in order to use TheVault. Register these in your device settings if not already.").font(.system(size: 10, design: .rounded)).foregroundColor(Color.init(red: 255/255, green: 101/255, blue: 101/255))
                        
                        
                        .navigationBarTitle("About")
                        .navigationBarItems(trailing: Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        {
                            Text("Close") .font(.system(.body, design: .rounded))
                        })
                }
                    
                .frame(maxWidth: .infinity)
                
            }
            .offset(y: 20)
            //.edgesIgnoringSafeArea([.leading, .trailing])
            
        }
        .padding(.horizontal, 10)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
