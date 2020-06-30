//
//  SwiftUIView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 28/06/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI

struct PasswordGeneratorView: View {
    
    @State var showBanner:Bool = false
    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(detail: "Password copied!", type: .Info)
    
    @State var generatedPassword = "PASSWORD"
    @State var passwordLength:Double = 8
    @State var numbersLength:Double = 2
    @State var symbolsLength:Double = 2
    
    @State var isNumbers = false
    @State var isSymbols = false
    @State var isUppercase = false
    @State var buttonPressed = false
    
    var fraction: CGFloat = 1.0
    
    var body: some View {
        
        VStack {
            
            TextField("", text: $generatedPassword)
                .padding(.vertical, 30)
                .font(Font.custom("Menlo", size: 30))
                .minimumScaleFactor(0.0001)
                .lineLimit(1)
                //.background(Color.red)
                .multilineTextAlignment(.center)
                .foregroundColor(self.buttonPressed ? .primary : .white)
                .offset(y: 20)
                .disabled(true)
            
            
            Form {
                
                Section(header: Text("Length: \(NoDecimal(number: passwordLength))")) {
                    
                    HStack {
                        Text("8")
                        ZStack {
                            
                            LinearGradient(
                                gradient: Gradient(colors: [Color.init(red: 255/255, green: 190/255, blue: 101/255), Color.init(red: 117/255, green: 211/255, blue: 99/255), Color.init(red: 127/255, green: 73/255, blue: 236/255)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                                .mask(Slider(value: $passwordLength, in: 8...40, step: 1))
                            Slider(value: $passwordLength, in: 8...40, step: 1)
                                .opacity(0.05)
                            
                        }
                        Text("40")
                    }
                }
                
                Section(header: Text("Configurations")) {
                    
                    Toggle(isOn: self.$isNumbers) {
                        Text("Numbers")
                    }
                    Toggle(isOn: self.$isSymbols) {
                        Text("Symbols")
                    }
                    
                }
                
                Section {
                    Button(action: {
                        
                        self.buttonPressed = true
                        
                        self.generatedPassword = randomPasswordUpLow(length: Int(self.passwordLength))
                        
                        if self.isNumbers {
                            self.generatedPassword = randomPasswordWithNumbers(length: Int(self.passwordLength))
                        }
                        if self.isSymbols {
                            self.generatedPassword = randomPasswordWithSymbols(length: Int(self.passwordLength))
                        }
                        if self.isSymbols && self.isNumbers {
                            self.generatedPassword = randomPasswordWithAll(length: Int(self.passwordLength))
                        }
                        
                    }) {
                        Text("Generate")
                    }
                    Button(action: {
                        UIPasteboard.general.string = self.generatedPassword
                        self.showBanner = true
                    })
                    {
                        Text("Copy password")
                    }
                }
            }.offset(y: 30)
        }.banner(data: $bannerData, show: $showBanner)
    }
}

func NoDecimal(number: Double) -> String
{
    return String(format: "%.0f", number)
}

func randomPasswordUpLow(length: Int) -> String
{
    let letters = "QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

func randomPasswordWithNumbers(length: Int) -> String
{
    let letters = "13245678964598712300QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

func randomPasswordWithSymbols(length: Int) -> String
{
    let letters = "!@£$%^&*()-_?}{:;.,/!@£$%^&*()-_?}{:;.,/QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

func randomPasswordWithAll(length: Int) -> String
{
    let letters = "12345607896549870123QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm!@£$%^&*()-_?}{:;.,/!@£$%^&*()-_?}{:;.,/"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

struct PasswordGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView()
    }
}
