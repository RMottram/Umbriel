//
//  SwiftUIView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 28/06/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI

struct PasswordGeneratorView: View {
    
    var hapticGen = Haptics()
    
    @State var showCopyNote:Bool = false
    @State var generatedPassword = "Password generates here!"
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
            
            NotificationBannerView()
                .offset(x: self.showCopyNote ? UIScreen.main.bounds.width/3 : UIScreen.main.bounds.width)
                .animation(.interpolatingSpring(mass: 1, stiffness: 80, damping: 10, initialVelocity: 1))
                .onTapGesture {
                    withAnimation {
                        self.showCopyNote = false
                    }
            }
            .onDisappear(perform: {
                self.showCopyNote = false
            })
            
            /*
             ================================================================================================================================
             MARK: Password Generator Field
             ================================================================================================================================
            */
            TextField("", text: $generatedPassword)
                .padding(.vertical, 30)
                .font(Font.custom("Menlo", size: 30))
                .minimumScaleFactor(0.0001)
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .offset(y: 20)
                .disabled(true)
            
            
            Form {
                /*
                 ================================================================================================================================
                 MARK: Password Length Slider
                 ================================================================================================================================
                */
                Section(header: Text("Length: \(NoDecimal(number: passwordLength))").font(.system(size: 12, design: .rounded))) {
                    
                    HStack {
                        Text("8").font(.system(.body, design: .rounded))
                        ZStack {
                            
                            LinearGradient(
                                gradient: Gradient(colors: [Color.init(red: 255/255, green: 190/255, blue: 101/255), Color.init(red: 117/255, green: 211/255, blue: 99/255), Color.init(red: 127/255, green: 73/255, blue: 236/255)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                                .mask(Slider(value: $passwordLength, in: 8...40, step: 1))
                            Slider(value: $passwordLength, in: 8...40, step: 1, onEditingChanged: {_ in
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
                            })
                                .opacity(0.02)
                            
                        }
                        Text("40").font(.system(.body, design: .rounded))
                    }
                }
                /*
                 ================================================================================================================================
                 MARK: Password Options
                 ================================================================================================================================
                */
                Section(header: Text("Configurations").font(.system(size: 12, design: .rounded))) {
                    
                    Toggle(isOn: self.$isNumbers) {
                        Text("Numbers").font(.system(.body, design: .rounded))
                    }
                    .onTapGesture {
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
                        self.hapticGen.simpleSelectionFeedback()
                    }
                    Toggle(isOn: self.$isSymbols) {
                        Text("Symbols").font(.system(.body, design: .rounded))
                    }.onTapGesture {
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
                        self.hapticGen.simpleSelectionFeedback()
                    }
                    
                }
                /*
                 ================================================================================================================================
                 MARK: Generate and Copy Buttons
                 ================================================================================================================================
                */
                Section {
                    Button(action: {
                        
                        self.buttonPressed = true
                        self.hapticGen.simpleSuccess()
                        
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
                        Text("Generate").font(.system(.body, design: .rounded))
                    }
                    Button(action: {
                        self.hapticGen.simpleSuccess()
                        UIPasteboard.general.string = self.generatedPassword
                        self.showCopyNote = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4)
                        {
                            withAnimation { self.showCopyNote = false }
                        }
                        
                    })
                    {
                        Text("Copy password").font(.system(.body, design: .rounded))
                    }
                }
            }.offset(y: 30)
        }
    }
}

/*
 ================================================================================================================================
 MARK: PasswordGenView Functions
 ================================================================================================================================
*/
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

/*
 ================================================================================================================================
 MARK: Preview
 ================================================================================================================================
*/
struct PasswordGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView()
    }
}
