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
    let universalSize = UIScreen.main.bounds

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
    @State private var red:Double = 255
    @State private var green:Double = 101
    @State private var blue:Double = 101
    
    // average
    @State private var avgred:Double = 255
    @State private var avggreen:Double = 190
    @State private var avgblue:Double = 101
    
    // strong
    @State private var strongred:Double = 117
    @State private var stronggreen:Double = 211
    @State private var strongblue:Double = 99
    
    // very strong
    @State private var vstrongred:Double = 127
    @State private var vstronggreen:Double = 73
    @State private var vstrongblue:Double = 255
    
    // standby
    @State private var stbred:Double = 135
    @State private var stbgreen:Double = 140
    @State private var stbblue:Double = 140
    
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
                    self.standby.toggle()
                    self.veryStrong.toggle()
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
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $red, green: $green, blue: $blue, opacity: $opacity)
                        }
                        if average
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $avgred, green: $avggreen, blue: $avgblue, opacity: $opacity)
                        }
                        if strong
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $strongred, green: $stronggreen, blue: $strongblue, opacity: $opacity)

                        }
                        if veryStrong
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $vstrongred, green: $vstronggreen, blue: $vstrongblue, opacity: $opacity)
                        }
                        if standby
                        {
                            WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $stbred, green: $stbgreen, blue: $stbblue, opacity: $opacity)
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
