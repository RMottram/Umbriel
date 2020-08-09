//
//  PasswordDetailView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 04/08/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct PasswordDetailView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showBanner:Bool = false
    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(detail: "Copied to clipboard!", type: .Info)
    var passwordTester = PasswordLogic()
    
    @State var description:Vault
    @State var loginItem:Vault
    @State var password:Vault
    
    @State var isHidden:Bool = true
    @State private var isCopied:Bool = false
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
    
    // copy
    @State private var stbRed:Double = 58
    @State private var stbGreen:Double = 146
    @State private var stbBlue:Double = 236
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/8)
                    .cornerRadius(16)
                
                Text("\(description.title!)")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.0001)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            //.offset(y: -20)
            
            VStack(alignment: .leading) {
                Text("Login").font(.system(.headline, design: .rounded)).padding(.top, 20)
                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                        .cornerRadius(16)
                    
                    Text("\(loginItem.loginItem ?? "No login issued")")
                        .font(.system(.body, design: .rounded))
                        .minimumScaleFactor(0.0001)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                    
                }
            }
            
            HStack(alignment: .center) {
                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.height/14)
                        .background(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                        .cornerRadius(16)
                        .onTapGesture {
                            UIPasteboard.general.string = self.loginItem.loginItem
                            self.showBanner = true
                    }
                    Image(systemName: "doc.on.clipboard")
                }
            }
            
            
            VStack(alignment: .leading) {
                Text("Password").font(.system(.headline, design: .rounded))
                HStack {
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                            .cornerRadius(16)
                        
                        Text("\(password.password!)")
                            .font(.system(.body, design: .rounded))
                            .minimumScaleFactor(0.0001)
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                            .blur(radius: isHidden ? 6 : 0)
                        
                    }
                    
                }
            }
            
            HStack(alignment: .center) {
                Spacer()
                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.height/14)
                        .background(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                        .cornerRadius(16)
                        .onTapGesture {
                            UIPasteboard.general.string = self.password.password
                            self.showBanner = true
                    }
                    Image(systemName: "doc.on.clipboard")
                }
                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.height/14)
                        .background((self.isHidden == false ) ? Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255) : Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255))
                        .cornerRadius(16)
                        .onTapGesture {
                            self.isHidden.toggle()
                    }
                    Image(systemName: self.isHidden ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor((self.isHidden == false ) ? Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255) : (Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255)))
                }
                Spacer()
            }
            
            VStack(alignment: .leading) {
                Text("Password Strength").font(.system(.headline, design: .rounded))
                ZStack {
                    if isWeak {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                            .background(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255))
                            .cornerRadius(16)
                        
                        Text("Weak").foregroundColor(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                    }
                    if isAverage {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                            .background(Color.init(red: avgRed/255, green: avgGreen/255, blue: avgBlue/255))
                            .cornerRadius(16)
                        
                        Text("Average").foregroundColor(Color.init(red: avgRed/255, green: avgGreen/255, blue: avgBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                    }
                    if isStrong {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                            .background(Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255))
                            .cornerRadius(16)
                        
                        Text("Strong").foregroundColor(Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                    }
                    if isVeryStrong {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                            .background(Color.init(red: vstrongRed/255, green: vstrongGreen/255, blue: vstrongBlue/255))
                            .cornerRadius(16)
                        
                        Text("Very Strong").foregroundColor(Color.init(red: vstrongRed/255, green: vstrongGreen/255, blue: vstrongBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                    }
                }
            }
            //.padding(.top, 20)
            .onAppear() {
                self.TestPass()
            }
            Spacer()
            
        }
        .banner(data: $bannerData, show: $showBanner)
        
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

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

//struct PasswordDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordDetailView(description: <#Vault#>, loginItem: <#Vault#>, password: <#Vault#>)
//    }
//}
