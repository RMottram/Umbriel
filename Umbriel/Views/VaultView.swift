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

struct VaultView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: Vault.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Vault.title, ascending: true)]
    ) var createdPasswords: FetchedResults<Vault>
    
    @State private var noBiometrics:Bool = false
    @State private var isUnlocked: Bool = false
    @State var passwordTitle:String = ""
    @State var loginItem:String = ""
    @State var passwordEntry:String = ""
    
    var body: some View {
        
        ZStack {
            
            //if isUnlocked {
                
                VStack {
                    NavigationView {
                        
                        VStack {
                            VStack {
                                
                                Text("TheVault is where you can safely store any passwords you may want to keep in a safe and secure environment using Apples own security built-in to every device and iOS.").font(.system(.footnote, design: .rounded)).fontWeight(.regular)
                                
                                Divider()
                                
                                TextField("Password Description", text: self.$passwordTitle).font(.system(.title, design: .rounded))
                                TextField("Login Item", text: self.$loginItem).font(.system(.body, design: .rounded))
                                TextField("Password", text: self.$passwordEntry).font(.system(.body, design: .rounded))
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
                                Button(action: { self.addPassword() }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.largeTitle)
                                }.foregroundColor(Color.init(red: 117/255, green: 211/255, blue: 99/255))
                        })
                    }.onDisappear(perform: lockVault)
                }
//            } else {
//
//                VStack {
//                    Text("TheVault requires the use of your devices' TouchID or FaceID sensors to be used. If these have not been activated please activate them in your devices settings.")
//                        .multilineTextAlignment(.center).padding(25).font(.system(.body, design: .rounded))
//                    Button("Unlock TheVault") {
//                        self.authenticate()
//                    }
//                    .font(.system(.title, design: .rounded))
//                    .padding()
//                    .background(Color.init(red: 58/255, green: 146/255, blue: 236/255))
//                    .foregroundColor(.white)
//                    .clipShape(Capsule())
//
//                }
//            }
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
            let pword = createdPasswords[index]
            context.delete(pword)
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
//                Text(passwordEntry.loginItem ?? "No login item given").font(.system(.subheadline, design: .rounded))
//                if self.isHidden {
//                    Text("\(passwordEntry.password!)").font(.system(.body, design: .rounded)).blur(radius: 4, opaque: false)
//                } else {
//                    Text("\(passwordEntry.password!)").font(.system(.body, design: .rounded))
//                }
            }
            
//            Image(systemName: self.isHidden ? "eye.slash.fill" : "eye.fill")
//                .foregroundColor((self.isHidden == false ) ? Color.init(red: 117/255, green: 211/255, blue: 99/255) : (Color.init(red: 255/255, green: 101/255, blue: 101/255))).onTapGesture {
//                    self.isHidden.toggle()
//            }
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
