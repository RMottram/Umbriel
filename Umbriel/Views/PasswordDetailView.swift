//
//  PasswordDetailView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 04/08/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI

struct PasswordDetailView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showBanner:Bool = false
    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(detail: "Copied to clipboard!", type: .Info)
    var passwordTester = PasswordLogic()
    
    @ObservedObject var description:Vault
    @ObservedObject var loginItem:Vault
    @ObservedObject var password:Vault
    
    @State var isHidden:Bool = true
    @State private var isBlank:Bool = false
    @State private var isWeak:Bool = false
    @State private var isAverage:Bool = false
    @State private var isStrong:Bool = false
    @State private var isVeryStrong:Bool = false
    
    // weak/blank
    @State private var weakRed:Double = 255
    @State private var weakGreen:Double = 101
    @State private var weakBlue:Double = 101
    
    // average
    @State private var avgRed:Double = 255
    @State private var avgGreen:Double = 190
    @State private var avgBlue:Double = 101
    
    // strong
    @State private var strongRed:Double = 117
    @State private var strongGreen:Double = 211
    @State private var strongBlue:Double = 99
    
    // very strong
    @State private var vstrongRed:Double = 127
    @State private var vstrongGreen:Double = 73
    @State private var vstrongBlue:Double = 255
    
    var body: some View {
        
        VStack {
            
            Text("\(description.title!)")
                .fontWeight(.bold)
                .font(.system(.largeTitle, design: .rounded))
                //.padding(.top, -30)
            
            Form {
                
                Section(header: Text("Login Item")) {
                    
                    HStack {
                        
                        Text("\(loginItem.loginItem!)")
                        Spacer()
                        Image(systemName: "doc.on.clipboard").onTapGesture {
                            UIPasteboard.general.string = self.loginItem.loginItem
                            self.showBanner = true
                        }
                    }
                }
                
                Section(header: Text("Password")) {
                    
                    HStack {
                        
                        if self.isHidden {
                            Text("\(password.password!)").font(.system(.body, design: .rounded)).blur(radius: 4, opaque: false)
                        } else {
                            Text("\(password.password!)")
                        }
                        
                        
                        Spacer()
                        
                        Image(systemName: self.isHidden ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor((self.isHidden == false ) ? Color.init(red: 117/255, green: 211/255, blue: 99/255) : (Color.init(red: 255/255, green: 101/255, blue: 101/255))).onTapGesture {
                                self.isHidden.toggle()
                        }
                        Divider()
                        Image(systemName: "doc.on.clipboard").onTapGesture {
                            UIPasteboard.general.string = self.password.password
                            self.showBanner = true
                        }
                    }.onAppear() {
                        self.TestPass()
                    }
                }
                
                Section(header: Text("Password Strength")) {
                    if isWeak {
                        Text("Weak").foregroundColor(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255))
                    }
                    if isAverage {
                        Text("Average").foregroundColor(Color.init(red: avgRed/255, green: avgGreen/255, blue: avgBlue/255))
                    }
                    if isStrong {
                        Text("Strong").foregroundColor(Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255))
                    }
                    if isVeryStrong {
                        Text("Very Strong").foregroundColor(Color.init(red: vstrongRed/255, green: vstrongGreen/255, blue: vstrongBlue/255))
                    }
                    if isBlank {
                        Text("Blank").foregroundColor(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255))
                    }
                }
            }
            
        }.banner(data: $bannerData, show: $showBanner)
    }
    
    func TestPass() {
        
        switch self.passwordTester.TestStrength(password: self.password.password!)
        {
            case .Blank:
                self.isBlank = true
                self.isWeak = false
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = false
            case .Weak:
                self.isBlank = false
                self.isWeak = true
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = false
            case .Average:
                self.isBlank = false
                self.isWeak = false
                self.isAverage = true
                self.isStrong = false
                self.isVeryStrong = false
            case .Strong:
                self.isBlank = false
                self.isWeak = false
                self.isAverage = false
                self.isStrong = true
                self.isVeryStrong = false
            case .VeryStrong:
                self.isBlank = false
                self.isWeak = false
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = true
        }
    }
}

//struct PasswordDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordDetailView(description: <#Vault#>, loginItem: <#Vault#>, password: <#Vault#>)
//    }
//}
