//
//  BannerView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 22/06/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI

struct BannerModifier: ViewModifier {
    
    struct BannerData
    {
        //var title:String
        var detail:String
        var type: BannerType
    }
    
    enum BannerType
    {
        case Info
        case Warning
        case Success
        case Error
        
        var tintColor: Color
        {
            switch self
            {
                case .Info:
                    return Color(red: 58/255, green: 146/255, blue: 236/255)
                case .Success:
                    return Color(red: 117/255, green: 211/255, blue: 99/255)
                case .Warning:
                    return Color(red: 255/255, green: 190/255, blue: 101/255)
                case .Error:
                    return Color(red: 255/255, green: 101/255, blue: 101/255)
            }
        }
    }
    
    // Members for the Banner
    @Binding var data:BannerData
    @Binding var show:Bool
    
    func body(content: Content) -> some View {
        ZStack
            {
                content
                if show
                {
                    VStack
                        {
                            HStack
                                {
                                    VStack(spacing: 6)
                                    {
                                        //Text(data.title).bold()
                                        Text(data.detail).font(Font.system(size: 16, weight: Font.Weight.light, design: Font.Design.rounded))
                                    }
                                    //Spacer()
                            }
                            .foregroundColor(Color.white)
                            .padding(6)
                            .background(data.type.tintColor)
                            .cornerRadius(6)
                            Spacer()
                    }
                    .padding()
                    .animation(Animation.spring().speed(0.6))
                    .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .top)))
                
                    //.transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                        .offset(y: -10)
                    .onTapGesture {
                        withAnimation {
                            self.show = false
                        }
                    }.onAppear(perform:
                        {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                            {
                                withAnimation { self.show = false }
                            }
                    })
                }
        }
    }
    
}

extension View
{
    func banner(data: Binding<BannerModifier.BannerData>, show: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(data: data, show: show))
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello, world!")
        }
    }
}
