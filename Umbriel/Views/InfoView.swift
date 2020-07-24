//
//  InfoView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 26/06/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI

struct InfoView: View
{
    var body: some View
    {
        
        NavigationView
            {
                ScrollView(.vertical)
                {
                    VStack(spacing: 20)
                    {
                        Text("Test the strength of a password before you sign up for anything, need to change a current password or to see if your current one is strong already.")
                        
                        Text("A password is your first line of defence and a good strong and complex password is the best way to prolong any attempts for someone to try and break into an account or cause them to give up.")
                        
                        Text("The formula for a strong and complex password involves a mixture of uppercase and lowercase letters, numbers, special symbols and length. There are other methods as well such as creating a passwor meaning, 2-3 unrelated words mixed together and something un-pronouncable.")
                        
                        Text("This app helps with getting the right combination of these elements to create the password you will use to protect your accounts. Your password strength is based on a points system with a higher point count equalling a stronger password")
                            
                            
                            
                            
                            .navigationBarTitle("About")
                    }
                        
                    .frame(maxWidth: .infinity)
                    
                }.font(.system(size: 20, design: .rounded))
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
