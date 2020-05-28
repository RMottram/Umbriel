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
    @State var isAnimated = false
    
    var state = 4
    
    var body: some View
    {
        ZStack
        {
            
            // weak password
            if state == 1
            {
                // background wave
                    Wave(interval: universalSize.width, amplitude:100)
                        .foregroundColor(Color.init(red: 253/255, green: 169/255, blue: 169/255, opacity: 0.4))
                        .offset(x: isAnimated ? -1 * universalSize.width : 0)
                        .animation(Animation.linear(duration: 6)
                        .repeatForever(autoreverses: false))
                    
                    // midground wave
                    Wave(interval: universalSize.width * 2, amplitude: 80)
                        .foregroundColor(Color.init(red: 255/255, green: 101/255, blue: 101/255, opacity: 0.6))
                    .offset(x: isAnimated ? -1 * (universalSize.width * 2) : 0)
                    .animation(Animation.linear(duration: 4)
                    .repeatForever(autoreverses: false))
                    
                    //foreground
                    Wave(interval: universalSize.width * 4, amplitude: 60, baseline: 60 + universalSize.height/2)
                        .foregroundColor(Color.init(red: 255/255, green: 101/255, blue: 101/255, opacity: 0.8))
                    .offset(x: isAnimated ? -1 * (universalSize.width * 4) : 0)
                    .animation(Animation.linear(duration: 4)
                    .repeatForever(autoreverses: false))
            }
            
            // average password
            if state == 2
            {
                // background wave
                    Wave(interval: universalSize.width, amplitude:100)
                        .foregroundColor(Color.init(red: 253/255, green: 205/255, blue: 169/255, opacity: 0.4))
                        .offset(x: isAnimated ? -1 * universalSize.width : 0)
                        .animation(Animation.linear(duration: 6)
                        .repeatForever(autoreverses: false))
                    
                    // midground wave
                    Wave(interval: universalSize.width * 2, amplitude: 80)
                        .foregroundColor(Color.init(red: 255/255, green: 190/255, blue: 101/255, opacity: 0.6))
                    .offset(x: isAnimated ? -1 * (universalSize.width * 2) : 0)
                    .animation(Animation.linear(duration: 4)
                    .repeatForever(autoreverses: false))
                    
                    //foreground
                    Wave(interval: universalSize.width * 4, amplitude: 60, baseline: 60 + universalSize.height/2)
                        .foregroundColor(Color.init(red: 255/255, green: 190/255, blue: 101/255, opacity: 0.8))
                    .offset(x: isAnimated ? -1 * (universalSize.width * 4) : 0)
                    .animation(Animation.linear(duration: 4)
                    .repeatForever(autoreverses: false))
            }
            
            // strong password
            if state == 3
            {
                // background wave
                    Wave(interval: universalSize.width, amplitude:100)
                        .foregroundColor(Color.init(red: 185/255, green: 253/255, blue: 169/255, opacity: 0.4))
                        .offset(x: isAnimated ? -1 * universalSize.width : 0)
                        .animation(Animation.linear(duration: 6)
                        .repeatForever(autoreverses: false))
                    
                    // midground wave
                    Wave(interval: universalSize.width * 2, amplitude: 80)
                        .foregroundColor(Color.init(red: 117/255, green: 211/255, blue: 99/255, opacity: 0.6))
                    .offset(x: isAnimated ? -1 * (universalSize.width * 2) : 0)
                    .animation(Animation.linear(duration: 4)
                    .repeatForever(autoreverses: false))
                    
                    //foreground
                    Wave(interval: universalSize.width * 4, amplitude: 60, baseline: 60 + universalSize.height/2)
                        .foregroundColor(Color.init(red: 117/255, green: 211/255, blue: 99/255, opacity: 0.8))
                    .offset(x: isAnimated ? -1 * (universalSize.width * 4) : 0)
                    .animation(Animation.linear(duration: 4)
                    .repeatForever(autoreverses: false))
            }
            
            // very strong password
            if state == 4
            {
                // background wave
                    Wave(interval: universalSize.width, amplitude:100)
                        .foregroundColor(Color.init(red: 149/255, green: 140/255, blue: 255/255, opacity: 0.4))
                        .offset(x: isAnimated ? -1 * universalSize.width : 0)
                        .animation(Animation.linear(duration: 6)
                        .repeatForever(autoreverses: false))
                    
                    // midground wave
                    Wave(interval: universalSize.width * 2, amplitude: 80)
                        .foregroundColor(Color.init(red: 127/255, green: 73/255, blue: 255/255, opacity: 0.6))
                    .offset(x: isAnimated ? -1 * (universalSize.width * 2) : 0)
                    .animation(Animation.linear(duration: 4)
                    .repeatForever(autoreverses: false))
                    
                    //foreground
                    Wave(interval: universalSize.width * 4, amplitude: 60, baseline: 60 + universalSize.height/2)
                        .foregroundColor(Color.init(red: 127/255, green: 73/255, blue: 255/255, opacity: 0.8))
                    .offset(x: isAnimated ? -1 * (universalSize.width * 4) : 0)
                    .animation(Animation.linear(duration: 4)
                    .repeatForever(autoreverses: false))
            }
            
        }.onAppear()
            {
                self.isAnimated = true
            }
    }
}

    func Wave(interval:CGFloat, amplitude:CGFloat = 100, baseline: CGFloat = UIScreen.main.bounds.height/2) -> Path
    {
        //let universalSize = UIScreen.main.bounds
        
        Path
            {path in
                path.move(to: CGPoint(x: 0, y: baseline))
                path.addCurve(
                    to: CGPoint(x: 1 * interval, y: baseline),
                    control1: CGPoint(x: interval * (0.35), y: amplitude + baseline),
                    control2: CGPoint(x: interval * (0.65), y: -amplitude + baseline))
                path.addCurve(
                    to: CGPoint(x: 2 * interval, y: baseline),
                    control1: CGPoint(x: interval * (1.35), y: amplitude + baseline),
                    control2: CGPoint(x: interval * (1.65), y: -amplitude + baseline))
                path.addLine(to: CGPoint(x: 2 * interval, y: UIScreen.main.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.height))
        }
    }

enum trafficLights
{
    case weak
    case average
    case strong
    case veryStrong
}

struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()
    }
}
