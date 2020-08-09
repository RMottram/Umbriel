//
//  ContentView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 26/05/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI

struct ContentView: View
{
    
    @State private var selectedTab = 0
    
    var passwordTester = PasswordLogic()
    
    @State private var showBanner:Bool = false
    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(detail: "Password copied!", type: .Info)
    
    @State private var showCopyNote = false
    @State private var password = ""
    @State private var isHidden = false
    @State private var score: Double = 0
    @State private var isStandby = true
    @State private var isWeak = false
    @State private var isAverage = false
    @State private var isStrong = false
    @State private var isVeryStrong = false
    
    // wave properties
    @State private var baseline:CGFloat = UIScreen.main.bounds.height/4
    @State private var amplitude:CGFloat = 60
    @State private var animationDuration:Double = 4
    
    // weak
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
    
    // standby
    @State private var stbRed:Double = 58
    @State private var stbGreen:Double = 146
    @State private var stbBlue:Double = 236
    
    @State private var opacity:Double = 0.2
    
    var body: some View
    {
        TabView(selection: $selectedTab)
        {
            // MARK: TextFields and buttons
            
            VStack
                {
                    ZStack
                        {
                            HStack
                                {
                                    if self.isHidden
                                    {
                                        SecureField("Enter Password...", text: self.$password, onCommit: { print("DEBUG: Go pressed")
                                            self.TestPass()
                                        })
                                            .padding(10)
                                            .padding(.horizontal, 10).padding(.top, 20)
                                            .font(.system(size: 20, design: .rounded))
                                            .disableAutocorrection(true)
                                            .autocapitalization(.none)
                                            .keyboardType(.webSearch)
                                    } else
                                    {
                                        TextField("Enter Password...", text: self.$password, onCommit: { print("DEBUG: Go pressed")
                                            self.TestPass()
                                        })
                                            .padding(10)
                                            .padding(.horizontal, 10).padding(.top, 20)
                                            .font(.system(size: 20, design: .rounded))
                                            .disableAutocorrection(true)
                                            .autocapitalization(.none)
                                            .keyboardType(.webSearch)
                                    }

                                    Button(action: { self.isHidden.toggle() })
                                    {
                                        Image(systemName: self.isHidden ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor((self.isHidden == false ) ? Color.init(red: 117/255, green: 211/255, blue: 99/255) : (Color.init(red: 255/255, green: 101/255, blue: 101/255)))
                                            .padding(.top, 30)
                                    }
                                    Button(action: {
                                        UIPasteboard.general.string = self.password
                                        self.showBanner = true
                                    })
                                    {
                                                Image(systemName: "doc.on.clipboard")
                                                    .foregroundColor(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                                                    .padding(.top, 30).padding(.trailing, 25)
                                        
                                    }
                            }.padding(.top, 50)
                    }

                    Divider()
                        .padding(.horizontal, 20)

                    // displays the password score. not for user viewing
                    //Text("\(OneDecimal(number: score))").font(.system(size: 30, design: .rounded))

                    // MARK: Wave Implementations
                    
                    ZStack
                        {
                            if isWeak
                            {
                                WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $weakRed, green: $weakGreen, blue: $weakBlue, opacity: $opacity)

                                Text("Password is blank or too weak. Try make your password 6 characters minimum!")
                                    .font(.system(size: 25, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                    .animation(.easeInOut(duration: 1.2))
                                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                            }
                            if isAverage
                            {
                                WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $avgRed, green: $avgGreen, blue: $avgBlue, opacity: $opacity)

                                Text("Your password is average, try mix upper, lower case letters, numbers and special symbols!")
                                    .font(.system(size: 25, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                    .animation(.easeInOut(duration: 1.2))
                                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))

                            }
                            if isStrong
                            {
                                WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $strongRed, green: $strongGreen, blue: $strongBlue, opacity: $opacity)

                                Text("Your password is strong but can be stronger. Try and incorporate more of what you already have done!")
                                    .font(.system(size: 25, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                    .animation(.easeInOut(duration: 1.2))
                                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))

                            }
                            if isVeryStrong
                            {
                                WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $vstrongRed, green: $vstrongGreen, blue: $vstrongBlue, opacity: $opacity)

                                Text("Well Done, This password is very strong!")
                                    .font(.system(size: 25, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                    .animation(.easeInOut(duration: 1.2))
                                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))

                            }
                            if isStandby
                            {
                                WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $stbRed, green: $stbGreen, blue: $stbBlue, opacity: $opacity)

                                Text("Enter a password to test its strength")
                                    .font(.system(size: 25, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                    .animation(.easeInOut(duration: 1.2))
                                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                            }
                    }.padding(.top, 40)
            }
                .tabItem {
                        Image(systemName: "checkmark.shield")
                        Text("Strength Tester")
            }.tag(0)
            
            PasswordGeneratorView()
                .tabItem {
                        Image(systemName: "wand.and.stars")
                        Text("Password Generator")
            }.tag(1)
            
            VaultView()
                .tabItem {
                        Image(systemName: "lock.shield")
                        Text("TheVault")
            }.tag(2)
            
        }.banner(data: $bannerData, show: $showBanner)
    }
    
    func OneDecimal(number: Double) -> String
    {
        return String(format: "%.1f", number)
    }
    
    func TestPass() {
        
        switch self.passwordTester.TestStrength(password: self.password)
        {
            case .Blank:
                self.isStandby = true
                self.isWeak = false
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = false
            case .Weak:
                self.isStandby = false
                self.isWeak = true
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = false
            case .Average:
                self.isStandby = false
                self.isWeak = false
                self.isAverage = true
                self.isStrong = false
                self.isVeryStrong = false
            case .Strong:
                self.isStandby = false
                self.isWeak = false
                self.isAverage = false
                self.isStrong = true
                self.isVeryStrong = false
            case .VeryStrong:
                self.isStandby = false
                self.isWeak = false
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = true
        }
    }
    
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()//.environment(\.colorScheme, .dark)
    }
}
