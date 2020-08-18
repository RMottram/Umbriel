//
//  VaultView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 24/07/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI
import LocalAuthentication
import CloudKit
import CoreData
import Combine
import GoogleMobileAds

struct VaultView: View {
    
    // get Vault contents and sort them
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Vault.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Vault.title, ascending: true)])
    var createdPasswords: FetchedResults<Vault>
    
    @State private var isActionSheetShowing:Bool = false
    @State private var noBiometrics:Bool = false
    @State private var isUnlocked: Bool = false
    @State private var isAnyInfoMissing:Bool = false
    @State var searchText = ""
    
    @State var passwordTitle:String = ""
    // optional at first but added space so can be updated properly in future
    @State var loginItem:String = ""
    @State var passwordEntry:String = ""
    // add note within PasswordDetailView, space is required to avoid erroneous errors
    @State var note:String = " "
    
    var body: some View {
        
        ZStack {
            
            /*
             ====================================================================================================================================
             MARK: Vault Unlocked View Start
             ====================================================================================================================================
             */
            if isUnlocked {
                
                VStack {
                    NavigationView {
                        
                        VStack {
                            VStack {
                                
                                Text("TheVault is where you can safely store any passwords you may want to keep in a safe and secure environment using Apples own security built-in to every device and iOS.")
                                    .font(.system(.footnote, design: .rounded)).fontWeight(.regular)
                                
                                Divider()
                                    .padding(.bottom, 10)
                                /*
                                 ================================================================================================================
                                 MARK: Password Entry Details
                                 ================================================================================================================
                                 */
                                TextField("*Password Description", text: self.$passwordTitle)
                                    .font(.system(.title, design: .rounded))
                                    .autocapitalization(.words)
                                    .disableAutocorrection(false)
                                TextField("*Login Item", text: self.$loginItem)
                                    .font(.system(.body, design: .rounded))
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                TextField("*Password", text: self.$passwordEntry)
                                    .font(.system(.body, design: .rounded))
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                
                                Divider().padding(.top, 10)
                                
                            }.padding(.horizontal, 20)
                            
                            
                            SearchBar(text: $searchText)
                                .padding(.top, 10)
                            
                            /*
                             ====================================================================================================================
                             MARK: Password Entries List
                             ====================================================================================================================
                             */
                            List {
                                ForEach(self.createdPasswords.filter({ searchText.isEmpty ? true : $0.description.contains(searchText) })) { passwords in
                                    NavigationLink(destination: PasswordDetailView(description: passwords, loginItem: passwords, password: passwords, note: passwords)) {
                                        EntryRow(passwordEntry: passwords)
                                    }
                                }.onDelete(perform: self.removePasswordEntry)
                                
                            }
                            // MARK: banner Ad
                            // Google AdMob test banner
                            //BannerAdView(bannerID: "ca-app-pub-6476420126002907/6041826914").frame(width: UIScreen.main.bounds.width, height: 40)
                        }
                            
                            /*
                             ====================================================================================================================
                             MARK: NavBar Items
                             ====================================================================================================================
                             */
                            .navigationBarTitle("TheVault")
                            .navigationBarItems(leading: EditButton(), trailing:
                                // if password description or password is empty, show alert
                                HStack {
                                    Button(action: {
                                        if self.passwordTitle == "" || self.passwordEntry == "" || self.loginItem == "" {
                                            if self.getRecordsCount() == 48 {
                                                print("DEBUG: 48 entries made")
                                            }
                                            self.isAnyInfoMissing = true
                                        } else {
                                            self.addPassword()
                                            
                                            // dismiss keyboard
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        }
                                        
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.largeTitle)
                                    }.foregroundColor(Color.init(red: 117/255, green: 211/255, blue: 99/255))
                                        .alert(isPresented: self.$isAnyInfoMissing) {
                                            Alert(title: Text("Missing Information"), message: Text("One or more required fields were left blank, please ensure to enter all required information"), dismissButton: .default(Text("OK")))
                                    }
                            })
                    }.onDisappear(perform: lockVault)
                    
                }
                /*
                 ================================================================================================================================
                 MARK: Vault Unlocked View End
                 ================================================================================================================================
                 */
                
                /*
                 ================================================================================================================================
                 MARK: Vault Locked View Start
                 ================================================================================================================================
                 */
            } else {
                
                VStack {
                    Text("TheVault requires the use of your devices' TouchID or FaceID sensors to be used. If these have not been activated please activate them in your devices settings.")
                        .multilineTextAlignment(.center).padding(10).font(.system(.body, design: .rounded))
                    
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/1.6, height: UIScreen.main.bounds.size.height/12)
                            .background(Color.init(red: 58/255, green: 146/255, blue: 236/255))
                            .cornerRadius(16)
                            .onTapGesture {
                                self.authenticate()
                        }
                        
                        Text("Unlock TheVault")
                            .font(.system(.title, design: .rounded))
                            .onTapGesture {
                                self.authenticate()
                        }
                    }
                }
            }
            /*
             ====================================================================================================================================
             MARK: Vault Locked View End
             ====================================================================================================================================
             */
        }.alert(isPresented: $noBiometrics) {
            Alert(title: Text("No biometrics available"), message: Text("This device has no biometric security setup. Please setup biometrics in device settings to use TheVault."), dismissButton: .default(Text("OK")))
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            
            self.lockVault()
        }
    }
    
    /*
     ============================================================================================================================================
     MARK: Vault Functions
     ============================================================================================================================================
     */
    
    func getRecordsCount() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Vault")
        var counter = 0
        do {
            counter = try context.count(for: fetchRequest)
            //print(counter)
        } catch {
            print(error.localizedDescription)
        }
        return counter
    }
    
    func addPassword() {
        
        let newPassword = Vault(context: context)
        
        newPassword.id = UUID()
        newPassword.title = passwordTitle
        newPassword.loginItem = loginItem
        newPassword.password = passwordEntry
        newPassword.dateCreated = Date()
        newPassword.notes = note
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        passwordTitle = ""
        loginItem = ""
        passwordEntry = ""
        
    }
    
    func removePasswordEntry(at offsets: IndexSet) {
        for index in offsets {
            let passwordToDelete = createdPasswords[index]
            context.delete(passwordToDelete)
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to enter TheVault"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        // error
                    }
                }
            }
        } else {
            // no biometrics
            self.noBiometrics = true
        }
    }
    
    func lockVault() {
        isUnlocked = false
    }
}

/*
 ================================================================================================================================================
 MARK: Vault EntryRowView
 ================================================================================================================================================
 */
struct EntryRow: View {
    
    var passwordEntry: Vault
    @State private var isHidden: Bool = true
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(passwordEntry.title ?? "No title given").font(.system(.headline, design: .rounded)).bold()
            }
        }
    }
}

/*
 ================================================================================================================================================
 MARK: Vault SearchBarView
 ================================================================================================================================================
 */
struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            
            TextField("Search...", text: $text)
                .font(.system(.body, design: .rounded))
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
            )
                .padding(.horizontal, 10)
                .transition(AnyTransition.move(edge: .leading).combined(with: .opacity))
                .animation(.easeInOut)
                .onTapGesture {
                    self.isEditing = true
            }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                    // dismiss keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                }) {
                    Text("Cancel")
                        .font(.system(.body, design: .rounded))
                }
                .padding(.trailing, 10)
                .transition(AnyTransition.move(edge: .trailing))
                .animation(.easeInOut)
            }
        }
    }
}

/*
 ================================================================================================================================================
 MARK: Preview
 ================================================================================================================================================
 */
struct VaultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VaultView()
        }
    }
}
