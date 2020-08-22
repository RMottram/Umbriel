//
//  PasswordDetailView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 04/08/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct PasswordDetailView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: Vault.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Vault.notes, ascending: true)])
    var createdNotes: FetchedResults<Vault>
    
    var passwordTester = PasswordLogic()
    var hapticGen = Haptics()
    
    @State var description:Vault
    @State var loginItem:Vault
    @State var password:Vault
    @State var note:Vault
    
    @State var passwordNotes:String = ""
    
    var newDescription = ""
    var newLog = ""
    var newPass = ""
    var newNote = ""
    
    @State var showLoginCopyNote:Bool = false
    @State var showPasswordCopyNote:Bool = false
    @State var showNotesCopyNote:Bool = false
    
    @State var isHidden:Bool = true
    @State var isKeyboardHidden:Bool = false
    @State var isEdit = false
    @State var isEditingNotes = false
    @State var isDeleteAlert = false
    @State private var isCopied:Bool = false
    @State private var isBlank:Bool = false
    @State private var isWeak:Bool = false
    @State private var isAverage:Bool = false
    @State private var isStrong:Bool = false
    @State private var isVeryStrong:Bool = false
    
    // weak/blank
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
    
    // copy
    @State private var stbRed:Double = 58
    @State private var stbGreen:Double = 146
    @State private var stbBlue:Double = 236
    
    let timer = Timer.publish(every: 2, tolerance: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack {
                
                ZStack {
                    /*
                     ================================================================================================================================
                     MARK: Description
                     ================================================================================================================================
                     */
                    VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/8)
                        .cornerRadius(16)
                    
                    Text("\(description.title ?? "No title given")")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/8)
                        .font(.system(.largeTitle, design: .rounded))
                        .minimumScaleFactor(0.0001)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                    
                }
                
                Group {
                    VStack {
                        NotificationBannerView()
                            .offset(x: self.showLoginCopyNote ? UIScreen.main.bounds.width/2 : UIScreen.main.bounds.width, y: 50)
                            .animation(.interpolatingSpring(mass: 1, stiffness: 80, damping: 10, initialVelocity: 1))
                            .onTapGesture {
                                withAnimation {
                                    self.showLoginCopyNote = false
                                }
                        }
                        .onDisappear(perform: {
                            self.showLoginCopyNote = false
                        })
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Login").font(.system(.headline, design: .rounded)).padding(.top, 20)
                        ZStack {
                            /*
                             ============================================================================================================================
                             MARK: Login Item
                             ============================================================================================================================
                             */
                            VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                                .cornerRadius(16)
                            
                            Text("\(loginItem.loginItem ?? "No login issued")")
                                .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/8)
                                .font(.system(.body, design: .rounded))
                                .minimumScaleFactor(0.0001)
                                .lineLimit(1)
                                .multilineTextAlignment(.center)
                            
                        }
                    }
                    
                    HStack(alignment: .center) {
                        ZStack {
                            /*
                             ============================================================================================================================
                             MARK: Login Copy Buttons
                             ============================================================================================================================
                             */
                            VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.height/14)
                                .background(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                                .cornerRadius(16)
                                .onTapGesture {
                                    self.hapticGen.simpleSelectionFeedback()
                                    UIPasteboard.general.string = self.loginItem.loginItem
                                    self.showLoginCopyNote = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 4)
                                    {
                                        withAnimation { self.showLoginCopyNote = false }
                                    }
                                    
                            }
                            Image(systemName: "doc.on.clipboard")
                                .foregroundColor(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                                .onTapGesture {
                                    self.hapticGen.simpleSelectionFeedback()
                                    UIPasteboard.general.string = self.loginItem.loginItem
                                    self.showLoginCopyNote = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 4)
                                    {
                                        withAnimation { self.showLoginCopyNote = false }
                                    }
                            }
                        }
                    }
                }
                
                
                Group {
                    VStack {
                        NotificationBannerView()
                            .offset(x: self.showPasswordCopyNote ? UIScreen.main.bounds.width/2 : UIScreen.main.bounds.width, y: 50)
                            .animation(.interpolatingSpring(mass: 1, stiffness: 80, damping: 10, initialVelocity: 1))
                            .onTapGesture {
                                withAnimation {
                                    self.showPasswordCopyNote = false
                                }
                        }
                        .onDisappear(perform: {
                            self.showPasswordCopyNote = false
                        })
                    }
                    VStack(alignment: .leading) {
                        /*
                         ================================================================================================================================
                         MARK: Password
                         ================================================================================================================================
                         */
                        Text("Password").font(.system(.headline, design: .rounded))
                        HStack {
                            ZStack {
                                VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                                    .cornerRadius(16)
                                
                                Text("\(password.password ?? "No password given")")
                                    .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/8)
                                    .font(.system(.body, design: .rounded))
                                    .minimumScaleFactor(0.0001)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.center)
                                    .blur(radius: isHidden ? 6 : 0)
                                
                            }
                            
                        }
                    }.padding(.top, 20)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        ZStack {
                            /*
                             ============================================================================================================================
                             MARK: Password Buttons
                             ============================================================================================================================
                             */
                            VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.height/14)
                                .background(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                                .cornerRadius(16)
                                .onTapGesture {
                                    self.hapticGen.simpleSelectionFeedback()
                                    UIPasteboard.general.string = self.password.password
                                    self.showPasswordCopyNote = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 4)
                                    {
                                        withAnimation { self.showPasswordCopyNote = false }
                                    }
                                    
                            }
                            Image(systemName: "doc.on.clipboard")
                                .foregroundColor(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                        }
                        ZStack {
                            VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.height/14)
                                .background((self.isHidden == false ) ? Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255) : Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255))
                                .cornerRadius(16)
                                .onTapGesture {
                                    self.hapticGen.simpleSelectionFeedback()
                                    self.isHidden.toggle()
                            }
                            Image(systemName: self.isHidden ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor((self.isHidden == false ) ? Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255) : (Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255)))
                                .onTapGesture {
                                    self.hapticGen.simpleSelectionFeedback()
                                    self.isHidden.toggle()
                            }
                        }
                        Spacer()
                    }
                }
                
                Group {
                    VStack(alignment: .leading) {
                        /*
                         ================================================================================================================================
                         MARK: Password Strength
                         ================================================================================================================================
                         */
                        Text("Password Strength").font(.system(.headline, design: .rounded))
                        ZStack {
                            if isWeak {
                                VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                                    .background(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255))
                                    .cornerRadius(16)
                                
                                Text("WEAK").foregroundColor(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                            }
                            if isAverage {
                                VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                                    .background(Color.init(red: avgRed/255, green: avgGreen/255, blue: avgBlue/255))
                                    .cornerRadius(16)
                                
                                Text("AVERAGE").foregroundColor(Color.init(red: avgRed/255, green: avgGreen/255, blue: avgBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                            }
                            if isStrong {
                                VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                                    .background(Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255))
                                    .cornerRadius(16)
                                
                                Text("STRONG").foregroundColor(Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                            }
                            if isVeryStrong {
                                VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                                    .background(Color.init(red: vstrongRed/255, green: vstrongGreen/255, blue: vstrongBlue/255))
                                    .cornerRadius(16)
                                
                                Text("VERY STRONG").foregroundColor(Color.init(red: vstrongRed/255, green: vstrongGreen/255, blue: vstrongBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                            }
                        }
                    }
                }.padding(.top, 60)
                
                /*
                 ====================================================================================================================================
                 MARK: Notes Section
                 ====================================================================================================================================
                 */
                Group {
                    VStack {
                        NotificationBannerView()
                            .offset(x: self.showNotesCopyNote ? UIScreen.main.bounds.width/2 : UIScreen.main.bounds.width, y: 50)
                            .animation(.interpolatingSpring(mass: 1, stiffness: 80, damping: 10, initialVelocity: 1))
                            .onTapGesture {
                                withAnimation {
                                    self.showNotesCopyNote = false
                                }
                        }
                        .onDisappear(perform: {
                            self.showNotesCopyNote = false
                        })
                    }
                    VStack(alignment: .leading) {
                        Text("Notes").font(.system(.headline, design: .rounded)).padding(.bottom, 10)
                        // display the note
                        HStack(alignment: .center) {
                            ZStack {
                                VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/8)
                                    .cornerRadius(16)
                                
                                Text("\(note.notes ?? "No note given")")
                                    .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/8)
                                    .minimumScaleFactor(0.0001)
                                    .lineLimit(10)
                                    .multilineTextAlignment(.center)
                                    .font(.system(.body, design: .rounded))
                            }
                        }
                        
                    }.padding(.top, 20)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        ZStack {
                            /*
                             ============================================================================================================================
                             MARK: Copy Notes Button
                             ============================================================================================================================
                             */
                            VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.height/14)
                                .background(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                                .cornerRadius(16)
                                .onTapGesture {
                                    self.hapticGen.simpleSelectionFeedback()
                                    UIPasteboard.general.string = self.note.notes
                                    self.showNotesCopyNote = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 4)
                                    {
                                        withAnimation { self.showNotesCopyNote = false }
                                    }
                                    
                            }
                            Image(systemName: "doc.on.clipboard")
                                .foregroundColor(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                                .onTapGesture {
                                    self.hapticGen.simpleSelectionFeedback()
                                    UIPasteboard.general.string = self.note.notes
                                    self.showNotesCopyNote = true
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                /*
                 ====================================================================================================================================
                 MARK: Edit and Delete Buttons
                 ====================================================================================================================================
                 */
                HStack(alignment: .center) {
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/3, height: UIScreen.main.bounds.size.height/14)
                            .background(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                            .cornerRadius(16)
                            .onTapGesture {
                                self.hapticGen.simpleSelectionFeedback()
                                self.isEdit = true
                        }
                        
                        Text("Edit").font(.system(.body, design: .rounded)).fontWeight(.bold)
                            .foregroundColor((Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255)))
                            .onTapGesture {
                                self.hapticGen.simpleSelectionFeedback()
                                self.isEdit = true
                        }
                    }
                    
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/3, height: UIScreen.main.bounds.size.height/14)
                            .background(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255))
                            .cornerRadius(16)
                            .onTapGesture {
                                self.hapticGen.simpleWarning()
                                self.isDeleteAlert = true
                        }
                        
                        Text("Delete").foregroundColor(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255))
                            .font(.system(.body, design: .rounded)).fontWeight(.bold)
                            .onTapGesture {
                                self.hapticGen.simpleWarning()
                                self.isDeleteAlert = true
                        }.alert(isPresented: self.$isDeleteAlert) {
                            Alert(title: Text("Are you sure you want to delete this entry?"), primaryButton: .destructive(Text("Delete")) {
                                self.hapticGen.simpleSuccess()
                                self.deleteEntry()
                                self.presentationMode.wrappedValue.dismiss()
                                }, secondaryButton: .cancel(Text("Cancel")))
                        }
                    }
                }
                .padding(.bottom, 30)
                .padding(.top, 60)
                .onAppear() {
                    // test the password when view appears
                    self.TestPass()
                }
            }
        }
        .onReceive(timer) { time in
            self.TestPass()
        }
        .animation(.easeInOut)
        .sheet(isPresented: self.$isEdit) {
            EditView(description: self.description, loginItem: self.loginItem, password: self.password, note: self.note, newDesc: self.newDescription, newLogin: self.newLog, newPassword: self.newPass, newNote: self.newNote)
        }
        
    }
    
    /*
     ================================================================================================================================
     MARK: PasswordDetailView Functions
     ================================================================================================================================
     */
    
    func deleteEntry() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestTitle:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Vault")
        
        fetchRequestTitle.predicate = NSPredicate(format: "title = %@", description.title!)
        
        
        do {
            let fetchReturnTitle = try managedContext.fetch(fetchRequestTitle)
            let titleToDelete = fetchReturnTitle[0] as! NSManagedObject
            
            managedContext.delete(titleToDelete)
            
            do {
                try managedContext.save()
            } catch let err as NSError {
                print("DEBUG: Could not save new entry information \(err), \(err.userInfo)")
            }
        } catch let error as NSError {
            print("DEBUG: Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func addNote(newNote: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestNote:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Vault")
        
        fetchRequestNote.predicate = NSPredicate(format: "notes = %@", note.notes!)
        
        do {
            let fetchReturnNote = try managedContext.fetch(fetchRequestNote)
            let noteUpdate = fetchReturnNote[0] as! NSManagedObject
            print("DEBUG: fetchReturnNote[0] = \(noteUpdate)")
            
            noteUpdate.setValue(newNote, forKey: "notes")
            print("DEBUG: noteUpdate.setValue() = \(noteUpdate)")
            
            do {
                try managedContext.save()
                print("DEBUG: Saved new note information")
            } catch let error as NSError {
                print("DEBUG: Could not save new note information \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("DEBUG: Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func TestPass() {
        
        switch self.passwordTester.TestStrength(password: self.password.password ?? "No Password")
        {
            case .Blank:
                self.isBlank = true
                self.isWeak = false
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = false
            case .Weak:
                
                self.isBlank = false
                self.isWeak = true
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = false
            case .Average:
                self.isBlank = false
                self.isWeak = false
                self.isAverage = true
                self.isStrong = false
                self.isVeryStrong = false
            case .Strong:
                self.isBlank = false
                self.isWeak = false
                self.isAverage = false
                self.isStrong = true
                self.isVeryStrong = false
            case .VeryStrong:
                self.isBlank = false
                self.isWeak = false
                self.isAverage = false
                self.isStrong = false
                self.isVeryStrong = true
        }
    }
}

/*
 ================================================================================================================================
 MARK: Frosted Glass Effect View
 ================================================================================================================================
 */
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

/*
 ================================================================================================================================
 MARK: EditView
 ================================================================================================================================
 */
struct EditView: View {
    
    var hapticGen = Haptics()
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) private var presentationMode
    
    @State var description:Vault
    @State var loginItem:Vault
    @State var password:Vault
    @State var note:Vault
    
    @State var newDesc:String
    @State var newLogin:String
    @State var newPassword:String
    @State var newNote:String
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section(header: Text("Blank fields will preserve current information for \"\(description.title!)\"").font(.system(size: 12, design: .rounded))) {
                    TextField("New description", text: $newDesc).font(.system(.body, design: .rounded))
                        .autocapitalization(.words)
                        .disableAutocorrection(false)
                    TextField("New login", text: $newLogin).font(.system(.body, design: .rounded))
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    TextField("New password", text: $newPassword).font(.system(.body, design: .rounded))
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    TextField("New note", text: $newNote).font(.system(.body, design: .rounded))
                        .disableAutocorrection(false)
                }
                
                Button(action: {
                    
                    if self.newDesc == "" {
                        self.newDesc = self.description.title!
                    }
                    if self.newLogin == "" {
                        self.newLogin = self.loginItem.loginItem!
                    }
                    if self.newPassword == "" {
                        self.newPassword = self.password.password!
                    }
                    if self.newNote == "" {
                        self.newNote = self.note.notes!
                    }
                    
                    self.hapticGen.simpleSuccess()
                    self.updateEntry(currentDesc: self.description.title!, newDesc: self.newDesc, currentLog: self.loginItem.loginItem!, newLogin: self.newLogin, currentPass: self.password.password!, newPass: self.newPassword, currentNote: self.note.notes!, newNote: self.newNote)
                    self.presentationMode.wrappedValue.dismiss()
                    
                })
                {
                    Text("Save").font(.system(.body, design: .rounded))
                }
                
            }
            .navigationBarTitle("Enter New Details")
            .navigationBarItems(trailing: Button(action: { self.presentationMode.wrappedValue.dismiss() }) { Text("Cancel").font(.system(.body, design: .rounded)) })
        }
    }
    
    /*
     ================================================================================================================================
     MARK: EditView Functions
     ================================================================================================================================
     */
    
    func updateEntry(currentDesc:String, newDesc:String, currentLog:String, newLogin:String, currentPass:String, newPass:String, currentNote:String, newNote:String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestLogin:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Vault")
        let fetchRequestPassword:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Vault")
        let fetchRequestDescription:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Vault")
        let fetchRequestNote:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Vault")
        
        fetchRequestLogin.predicate = NSPredicate(format: "loginItem = %@", currentLog)
        fetchRequestPassword.predicate = NSPredicate(format: "password = %@", currentPass)
        fetchRequestDescription.predicate = NSPredicate(format: "title = %@", currentDesc)
        fetchRequestNote.predicate = NSPredicate(format: "notes = %@", currentNote)
        
        do {
            let fetchReturnLogin = try managedContext.fetch(fetchRequestLogin)
            let fetchReturnPassword = try managedContext.fetch(fetchRequestPassword)
            let fetchReturnDescription = try managedContext.fetch(fetchRequestDescription)
            let fetchReturnNote = try managedContext.fetch(fetchRequestNote)
            
            let loginUpdate = fetchReturnLogin[0] as! NSManagedObject
            let passwordUpdate = fetchReturnPassword[0] as! NSManagedObject
            let descriptionUpdate = fetchReturnDescription[0] as! NSManagedObject
            let noteUpdate = fetchReturnNote[0] as! NSManagedObject
            
            loginUpdate.setValue(newLogin, forKey: "loginItem")
            passwordUpdate.setValue(newPass, forKey: "password")
            descriptionUpdate.setValue(newDesc, forKey: "title")
            noteUpdate.setValue(newNote, forKey: "notes")
            
            do {
                try managedContext.save()
                print("DEBUG: Saved new entry information")
            } catch let error as NSError {
                print("DEBUG: Could not save new entry information \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("DEBUG: Could not fetch \(error), \(error.userInfo)")
        }
        
    }
}

/*
 ================================================================================================================================
 MARK: Preview
 ================================================================================================================================
 */
//struct PasswordDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordDetailView(description: <#Vault#>, loginItem: <#Vault#>, password: <#Vault#>, note: <#Vault#>)
//    }
//}
