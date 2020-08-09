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
import Combine

struct VaultView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: Vault.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Vault.title, ascending: true)]
    ) var createdPasswords: FetchedResults<Vault>
    
    @State private var noBiometrics:Bool = false
    @State private var isUnlocked: Bool = false
    @State private var isAllInformationEntered:Bool = false
    
    @State var passwordTitle:String = ""
    @State var loginItem:String = ""
    @State var passwordEntry:String = ""
    
    var body: some View {
        
        ZStack {
            
            if isUnlocked {
                
                VStack {
                    NavigationView {
                        
                        VStack {
                            VStack {
                                
                                Text("TheVault is where you can safely store any passwords you may want to keep in a safe and secure environment using Apples own security built-in to every device and iOS.").font(.system(.footnote, design: .rounded)).fontWeight(.regular)
                                
                                Divider()
                                
                                TextField("*Password Description", text: self.$passwordTitle).font(.system(.title, design: .rounded))
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                TextField("Login Item", text: self.$loginItem).font(.system(.body, design: .rounded))
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                TextField("*Password", text: self.$passwordEntry).font(.system(.body, design: .rounded))
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                
                            }.padding(.horizontal, 20)
                            
                            List {
                                ForEach(createdPasswords){ passwords in
                                    
                                    NavigationLink(destination: PasswordDetailView(description: passwords, loginItem: passwords, password: passwords)) {
                                        EntryRow(passwordEntry: passwords)
                                    }
                                }.onDelete(perform: removePasswordEntry)
                                
                            }
                        }
                            
                        .navigationBarTitle("TheVault")
                        .navigationBarItems(leading: EditButton(), trailing:
                            HStack {
                                Button(action: {
                                    if self.passwordTitle == "" || self.passwordEntry == "" {
                                        self.isAllInformationEntered = true
                                    } else {
                                        self.addPassword()
                                    }
                                    
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.largeTitle)
                                }.foregroundColor(Color.init(red: 117/255, green: 211/255, blue: 99/255))
                                    .alert(isPresented: self.$isAllInformationEntered) {
                                        Alert(title: Text("Missing Information"), message: Text("One or more required fields were left blank, please ensure to enter all required information"), dismissButton: .default(Text("OK")))
                                }
                        })
                    }.onDisappear(perform: lockVault)
                    
                }
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
                        
                        Text("Unlock TheVault")
                        .font(.system(.title, design: .rounded))
                        .onTapGesture {
                                self.authenticate()
                        }
                    }
                    
                }
            }
        }
        .alert(isPresented: $noBiometrics) {
            Alert(title: Text("No biometrics available"), message: Text("This device has no biometric security setup. Please setup biometrics in device settings to use TheVault."), dismissButton: .default(Text("OK")))
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            
            self.lockVault()
        }
    }
    
    func addPassword() {
        
        let newPassword = Vault(context: context)
        
        newPassword.id = UUID()
        newPassword.title = passwordTitle
        newPassword.loginItem = loginItem
        newPassword.password = passwordEntry
        newPassword.dateCreated = Date()
        
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

struct VaultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VaultView()
        }
    }
}
