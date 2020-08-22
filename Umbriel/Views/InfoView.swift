//
//  InfoView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 26/06/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI
import StoreKit
import Purchases
import MessageUI

struct InfoView: View {
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State var alertNoMail = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("About").font(.system(.largeTitle, design: .rounded)).bold()
                    Spacer()
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.height/22)
                            .background(Color.init(red: 48/255, green: 146/255, blue: 236/255))
                            .cornerRadius(16)
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                        }
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        {
                            Text("Close").font(.system(.body, design: .rounded)).bold()
                        }
                    }
                }.padding(.bottom, 20)
                
                Text("A password is your first line of defence and a good strong and complex password is the best way to prolong any attempts for someone to try and break into an account or cause them to give up. \n\nThe formula for a strong and complex password involves a mixture of uppercase and lowercase letters, numbers, special symbols and length. \n\nThis app helps with getting the right combination of these elements to create the password you will use to protect your accounts. Your password strength is based on a points system with a higher point count equalling a stronger password. \n\nIf you cannot think of a strong enough password or just want one created for you, the password generator will do this for you. Customise this password by choosing its length between 8 and 40 characters and for it to include numbers and symbols which is highly recommended.\n\nUmbriel also comes with a secure vault where you can store your passwords where only you can access using your FaceID or TouchID sensors*. TheVault uses your devices built-in security technology to protect your stored passwords. All passwords are stored on your device with no external database used and uses iCloud to sync these passwords across your other devices.\n\n")
                    .font(.system(.body, design: .rounded))
                
                Text("*TheVault requires you to have your fingerprint or face registered to your device in order to use TheVault. Register these in your device settings if not already.").font(.system(size: 10, design: .rounded)).foregroundColor(Color.init(red: 255/255, green: 101/255, blue: 101/255)).padding(.bottom, 40)
                
                HStack {
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/2.5, height: UIScreen.main.bounds.size.height/14)
                            .cornerRadius(16)
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                        }
                        
                        Button(action: {
                            guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1520674335?action=write-review")
                                else { fatalError("Expected a valid URL") }
                            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                        })
                        {
                            HStack {
                                Image(systemName: "star.circle.fill").foregroundColor(Color.init(red: 255/255, green: 190/255, blue: 101/255)).font(.system(.title, design: .rounded))
                                Text("Rate the app").font(.system(.body, design: .rounded)).foregroundColor(Color.init(red: 48/255, green: 146/255, blue: 236/255)).bold()
                            }
                        }
                    }
                    Spacer()
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/2.5, height: UIScreen.main.bounds.size.height/14)
                            .cornerRadius(16)
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                        }
                        
                        Button(action: {
                            if MFMailComposeViewController.canSendMail() {
                               self.isShowingMailView.toggle()
                            } else if let emailUrl = MailView.createEmailUrl(subject: "Umbriel Feedback and Suggestions", body: "") {
                               UIApplication.shared.open(emailUrl)
                            } else {
                               self.alertNoMail.toggle()
                            }
                        })
                        {
                            HStack {
                                Image(systemName: "envelope.circle.fill").foregroundColor(Color.init(red: 117/255, green: 211/255, blue: 99/255)).font(.system(.title, design: .rounded))
                                Text("Feedback or suggestions").font(.system(.body, design: .rounded)).foregroundColor(Color.init(red: 48/255, green: 146/255, blue: 236/255)).bold()
                            }
                        }
                    }.alert(isPresented: $alertNoMail) {
                        Alert(title: Text("No mail account setup"), dismissButton: .cancel(Text("OK")))
                    }
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(isShowing: self.$isShowingMailView, result: self.$result)
                    }
                }.padding(.bottom, 40)
                
            }.offset(y: 20)
                
                .frame(maxWidth: .infinity)
            
        }
        .offset(y: 20)
        .padding(.horizontal, 20)
    }
    
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
