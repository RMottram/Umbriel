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
    //let universalSize = UIScreen.main.bounds
    let test = PasswordLogic()

    @State var password = ""
    @State var hidden = false
    @State var score: Double = 0
    @State var standby = true
    @State var weak = false
    @State var average = false
    @State var strong = false
    @State var veryStrong = false
    
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
                                if self.hidden
                                {
                                    SecureField("Enter Password...", text: self.$password).padding(10)
                                        .padding(.horizontal, 10).padding(.top, 20)
                                        .font(.system(size: 30, design: .rounded))
                                } else
                                {
                                    TextField("Enter Password...", text: self.$password).padding(10)
                                        .padding(.horizontal, 10).padding(.top, 20)
                                        .font(.system(size: 30, design: .rounded))
                                }
                                
                                Button(action: { self.hidden.toggle() })
                                {
                                    Image(systemName: self.hidden ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor((self.hidden == false ) ? Color.init(red: 117/255, green: 211/255, blue: 99/255) : (Color.init(red: 255/255, green: 101/255, blue: 101/255)))
                                        .padding(.horizontal, 30).padding(.top, 30)
                                }
                        }.padding(.top, 60)
                }
                
                Divider()
                    .padding(.horizontal, 20)
                
                Button(action: {
                    self.standby = false
                    
                    switch self.test.TestStrength(password: self.password)
                    {
                        case .Blank, .Weak:
                            self.weak = true
                            self.average = false
                            self.strong = false
                            self.veryStrong = false
                        case .Average:
                            self.weak = false
                            self.average = true
                            self.strong = false
                            self.veryStrong = false
                        case .Strong:
                            self.weak = false
                            self.average = false
                            self.strong = true
                            self.veryStrong = false
                        case .VeryStrong:
                            self.weak = false
                            self.average = false
                            self.strong = false
                            self.veryStrong = true
                    }
                    
                })
                {
                    Text("Test Password")
                        .font(.system(size: 30, design: .rounded))
                }
                
                Text("\(OneDecimal(number: score))").font(.system(size: 30, design: .rounded))
                
                ZStack
                    {
                        if weak
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $weakRed, green: $weakGreen, blue: $weakBlue, opacity: $opacity)
                        }
                        if average
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $avgRed, green: $avgGreen, blue: $avgBlue, opacity: $opacity)
                        }
                        if strong
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $strongRed, green: $strongGreen, blue: $strongBlue, opacity: $opacity)

                        }
                        if veryStrong
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $vstrongRed, green: $vstrongGreen, blue: $vstrongBlue, opacity: $opacity)
                        }
                        if standby
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $stbRed, green: $stbGreen, blue: $stbBlue, opacity: $opacity)
                        }
                }
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
