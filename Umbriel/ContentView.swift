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
    let passwordTester = PasswordLogic()
    
    @State var password = ""
    @State var isHidden = false
    @State var score: Double = 0
    @State var isStandby = true
    @State var isWeak = false
    @State var isAverage = false
    @State var isStrong = false
    @State var isVeryStrong = false
    
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
    @State private var stbRed:Double = 135
    @State private var stbGreen:Double = 140
    @State private var stbBlue:Double = 140
    
    @State private var opacity:Double = 0.2
    
    var body: some View
    {
        VStack
            {
                
                ZStack
                    {
                        HStack
                            {
                                if self.isHidden
                                {
                                    SecureField("Enter Password...", text: self.$password).padding(10)
                                        .padding(.horizontal, 10).padding(.top, 20)
                                        .font(.system(size: 20, design: .rounded))
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                } else
                                {
                                    TextField("Enter Password...", text: self.$password).padding(10)
                                        .padding(.horizontal, 10).padding(.top, 20)
                                        .font(.system(size: 20, design: .rounded))
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                }
                                
                                Button(action: { self.isHidden.toggle() })
                                {
                                    Image(systemName: self.isHidden ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor((self.isHidden == false ) ? Color.init(red: 117/255, green: 211/255, blue: 99/255) : (Color.init(red: 255/255, green: 101/255, blue: 101/255)))
                                        .padding(.horizontal, 30).padding(.top, 30)
                                }
                        }.padding(.top, 40)
                }
                
                Divider()
                    .padding(.horizontal, 20)
                
                Button(action: {
                    self.isStandby = false
                    
                    switch self.passwordTester.TestStrength(password: self.password)
                    {
                        case .Blank, .Weak:
                            self.isWeak = true
                            self.isAverage = false
                            self.isStrong = false
                            self.isVeryStrong = false
                        case .Average:
                            self.isWeak = false
                            self.isAverage = true
                            self.isStrong = false
                            self.isVeryStrong = false
                        case .Strong:
                            self.isWeak = false
                            self.isAverage = false
                            self.isStrong = true
                            self.isVeryStrong = false
                        case .VeryStrong:
                            self.isWeak = false
                            self.isAverage = false
                            self.isStrong = false
                            self.isVeryStrong = true
                    }
                    
                })
                {
                    Text("Test Password")
                        .font(.system(size: 30, design: .rounded))
                }
                
                // displays the password score. not for user viewing
                //Text("\(OneDecimal(number: score))").font(.system(size: 30, design: .rounded))
                
                Button(action: { UIPasteboard.general.string = self.password })
                {
                    Image(systemName: "doc.on.clipboard")
                        .resizable()
                        .frame(width: 30, height: 35)
                        .foregroundColor(Color.init(red: 135/255, green: 140/255, blue: 140/255, opacity: 0.4))

                }
                
                ZStack
                    {
                        if isWeak
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $weakRed, green: $weakGreen, blue: $weakBlue, opacity: $opacity)
                            
                            Text("Password is blank or too weak. Try make your password 6 characters minimum!")
                                .font(.system(.title, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        if isAverage
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $avgRed, green: $avgGreen, blue: $avgBlue, opacity: $opacity)
                            
                            Text("Your password is average, try mix upper, lower case letters, numbers and special symbols!")
                               .font(.system(.title, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        if isStrong
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $strongRed, green: $strongGreen, blue: $strongBlue, opacity: $opacity)
                            
                            Text("Your password is strong but can be stronger. Try and incorporate more of what you already have done!")
                                .font(.system(.title, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                        }
                        if isVeryStrong
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $vstrongRed, green: $vstrongGreen, blue: $vstrongBlue, opacity: $opacity)
                            
                            Text("Well Done, This password is very strong!")
                                .font(.system(.title, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)

                        }
                        if isStandby
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $stbRed, green: $stbGreen, blue: $stbBlue, opacity: $opacity)
                            
                            Text("Please enter a password to test its strength")
                                .font(.system(.title, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                }.padding(.top, 80)
        }
    }
    
    enum PasswordScore
    {
        case blank(Int)
        case weak(Int)
        case average(Int)
        case strong(Int)
        case veryStrong(Int)
    }
    
    func OneDecimal(number: Double) -> String
    {
        return String(format: "%.1f", number)
    }
    
}



struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
