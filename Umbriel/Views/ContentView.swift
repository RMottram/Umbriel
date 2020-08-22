//
//  ContentView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 26/05/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct ContentView: View
{
    @State var interstital: GADInterstitial!
    
    @State private var selectedTab = 0
    
    var passwordTester = PasswordLogic()
    var hapticGen = Haptics()
    
    @State private var isPurchased:Bool = false
    @State private var isInfoView = false
    @State private var showCopyNote = false
    @State private var password = ""
    @State private var isHidden = false
    @State private var score: Double = 0
    @State private var isStandby = true
    @State private var isWeak = false
    @State private var isAverage = false
    @State private var isStrong = false
    @State private var isVeryStrong = false
    
    // used to show ad
    @State private var passwordTestCounter = 0
    
    // wave properties
    @State private var baseline:CGFloat = UIScreen.main.bounds.height/50
    @State private var amplitude:CGFloat = 50
    @State private var animationDuration:Double = 6
    
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
            
            /*
             ================================================================================================================================
             MARK: Text Fields and Buttons
             ================================================================================================================================
             */
            VStack
                {
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
                    
                    ZStack(alignment: .leading) {
                        
                        HStack {
                            Button(action: {
                                self.isInfoView = true
                                
                                // dismiss keyboard
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            })
                            {
                                Image(systemName: "info.circle").font(.largeTitle).foregroundColor(Color.init(red: 58/255, green: 146/255, blue: 236/255))
                                }
                            .offset(x: 20, y: -50)
                        }
                        
                        HStack
                            {
                                if self.isHidden
                                {
                                    SecureField("Enter Password...", text: self.$password, onCommit: { print("DEBUG: Go pressed"); self.TestPass()
                                        self.hapticGen.simpleSuccess()
                                        self.passwordTestCounter += 1
                                        
                                        // MARK: Interstital Ad
                                        // interstital ad, comment to remove for own device
//                                        if self.interstital.isReady && self.passwordTestCounter == 15 {
//                                            let root = UIApplication.shared.windows.first?.rootViewController
//                                            self.interstital.present(fromRootViewController: root!)
//                                            self.passwordTestCounter = 0
//                                        } else {
//                                            print("DEBUG: Ad not ready")
//                                        }
                                        SKStoreReviewController.requestReview()
                                    })
                                        .padding(10)
                                        .padding(.horizontal, 10).padding(.top, 20)
                                        .font(.system(size: 20, design: .rounded))
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                        .keyboardType(.webSearch)
                                } else
                                {
                                    TextField("Enter Password...", text: self.$password, onCommit: { print("DEBUG: Go pressed"); self.TestPass()
                                        self.hapticGen.simpleSuccess()
                                        self.passwordTestCounter += 1
                                        
                                        // MARK: Interstital Ad
                                        // interstital ad, comment to remove for own device
//                                        if self.interstital.isReady && self.passwordTestCounter == 15 {
//                                            let root = UIApplication.shared.windows.first?.rootViewController
//                                            self.interstital.present(fromRootViewController: root!)
//                                            self.passwordTestCounter = 0
//                                        } else {
//                                            print("DEBUG: Ad not ready")
//                                        }
                                        SKStoreReviewController.requestReview()
                                    })
                                        .padding(10)
                                        .padding(.horizontal, 10).padding(.top, 20)
                                        .font(.system(size: 20, design: .rounded))
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                        .keyboardType(.webSearch)
                                }
                                
                                Button(action: { self.isHidden.toggle(); self.TestPass(); self.passwordTestCounter += 1
                                    self.hapticGen.simpleSelectionFeedback()
                                    // interstital ad, comment to remove for own device
                                    // MARK: Interstital Ad
//                                    if self.interstital.isReady && self.passwordTestCounter == 15 {
//                                        let root = UIApplication.shared.windows.first?.rootViewController
//                                        self.interstital.present(fromRootViewController: root!)
//                                        self.passwordTestCounter = 0
//                                    } else {
//                                        print("DEBUG: Ad not ready")
//                                    }
                                })
                                {
                                    Image(systemName: self.isHidden ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor((self.isHidden == false ) ? Color.init(red: 117/255, green: 211/255, blue: 99/255) : (Color.init(red: 255/255, green: 101/255, blue: 101/255)))
                                        .padding(.top, 30)
                                }
                                Button(action: {
                                    self.hapticGen.simpleSelectionFeedback()
                                    self.TestPass()
                                    UIPasteboard.general.string = self.password
                                    self.showCopyNote = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 4)
                                    {
                                        withAnimation { self.showCopyNote = false }
                                    }
                                    
                                })
                                {
                                    Image(systemName: "doc.on.clipboard")
                                        .foregroundColor(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                                        .padding(.top, 30).padding(.trailing, 25)
                                    
                                }
                        }.padding(.top, 100)
                    }
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    /*
                     ============================================================================================================================
                     MARK: Wave Implementations
                     ============================================================================================================================
                     */
                    
                    ZStack
                        {
                            if isWeak
                            {
                                WaveView(baselineAdjustment: $baseline, amplitudeAdjustment: $amplitude, animationDuration: $animationDuration, red: $weakRed, green: $weakGreen, blue: $weakBlue, opacity: $opacity)
                                
                                Text("Password is too weak. Try make your password 6 characters minimum!")
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
                    
                    // MARK: Banner Ad
                    // Google AdMob test banner, comment to remove from device
                    //BannerAdView(bannerID: "ca-app-pub-6476420126002907/6041826914").frame(width: UIScreen.main.bounds.width, height: 40)
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
            
        }
        .sheet(isPresented: $isInfoView) {
            InfoView()
        }
        .onAppear() {
            self.interstital =  GADInterstitial(adUnitID: "ca-app-pub-6476420126002907/6114102812")
            let req = GADRequest()
            self.interstital.load(req)
        }
    }
    
    /*
     ================================================================================================================================
     MARK: ContentView Functions
     ================================================================================================================================
     */
    
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

struct BannerAdView: UIViewRepresentable {
    var bannerID:String
    let banner = GADBannerView(adSize: kGADAdSizeBanner)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<BannerAdView>) -> GADBannerView {
        banner.adUnitID = bannerID
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        banner.delegate = context.coordinator
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<BannerAdView>) {}
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        var parent: BannerAdView
        
        init(_ parent: BannerAdView) {
            self.parent = parent
        }
        
        func adViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("DEBUG: Did receive ad")
        }
        
        func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
            print("DEBUG: Failed to get ad")
        }
    }
}

/*
 ================================================================================================================================
 MARK: Preview
 ================================================================================================================================
 */
struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ContentView()//.environment(\.colorScheme, .dark)
    }
}
