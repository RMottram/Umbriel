//
//  VaultView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 24/07/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct VaultView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: Vault.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Vault.dateCreated, ascending: false)]
    ) var createdPasswords: FetchedResults<Vault>
    
    @State private var isUnlocked: Bool = false
    @State var passwordTitle = ""
    @State var passwordEntry = ""
    
    var body: some View {
        
        ZStack {
            
            if isUnlocked {
                
                VStack {
                    NavigationView {
                        
                        VStack {
                            VStack {
                                
                                TextField("Password Description", text: self.$passwordTitle).font(.system(.largeTitle, design: .rounded))
                                TextField("Password", text: self.$passwordEntry).font(.system(.subheadline, design: .rounded))
                                
                            }.padding()
                            
                            List {
                                ForEach(createdPasswords){ passwords in
                                    EntryRow(passwordEntry: passwords)
                                }.onDelete(perform: removePasswordEntry)
                            }
                        }
                            
                        .navigationBarTitle("TheVault")
                        .navigationBarItems(leading: EditButton(), trailing:
                            HStack {
                                Button(action: { self.addPassword() }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.largeTitle)
                                }.foregroundColor(.green)
                        })
                    }
                }
            } else {
                
                Button("Unlock TheVault") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
            }
        }
    }
    
    func addPassword() {
        
        let newPassword = Vault(context: context)
        
        newPassword.id = UUID()
        newPassword.title = passwordTitle
        newPassword.password = passwordEntry
        newPassword.dateCreated = Date()
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        passwordTitle = ""
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
        }
    }
}

struct EntryRow: View {
    
    var passwordEntry: Vault
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(passwordEntry.title ?? "No title given").font(.title).bold()
            Text("\(passwordEntry.password!)").font(.body)
        }
        
    }
}


struct VaultView_Previews: PreviewProvider {
    static var previews: some View {
        VaultView()
    }
}
