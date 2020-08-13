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
    
    //@FetchRequest(entity: Vault.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Vault.notes, //ascending: true)])
    //var passwordNote: FetchedResults<Vault>
    
    @State private var showBanner:Bool = false
    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(detail: "Copied to clipboard!", type: .Info)
    var passwordTester = PasswordLogic()
    
    @State var description:Vault
    @State var loginItem:Vault
    @State var password:Vault
    //@State var note:Vault
    
    //var notes:String = ""
    
    //@State var passwordNotes:String = ""
    //@State private var value:CGFloat = 0
    
    var newLog = ""
    var newPass = ""
    
    @State var isHidden:Bool = true
    @State var isEdit = false
    @State var isEditingNotes = false
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
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
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
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.0001)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
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
                            UIPasteboard.general.string = self.loginItem.loginItem
                            self.showBanner = true
                    }
                    Image(systemName: "doc.on.clipboard")
                        .foregroundColor(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
                }
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
                            UIPasteboard.general.string = self.password.password
                            self.showBanner = true
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
                            self.isHidden.toggle()
                    }
                    Image(systemName: self.isHidden ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor((self.isHidden == false ) ? Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255) : (Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255)))
                }
                Spacer()
            }
            
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
                        
                        Text("Weak").foregroundColor(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                    }
                    if isAverage {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                            .background(Color.init(red: avgRed/255, green: avgGreen/255, blue: avgBlue/255))
                            .cornerRadius(16)
                        
                        Text("Average").foregroundColor(Color.init(red: avgRed/255, green: avgGreen/255, blue: avgBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                    }
                    if isStrong {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                            .background(Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255))
                            .cornerRadius(16)
                        
                        Text("Strong").foregroundColor(Color.init(red: strongRed/255, green: strongGreen/255, blue: strongBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                    }
                    if isVeryStrong {
                        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/10)
                            .background(Color.init(red: vstrongRed/255, green: vstrongGreen/255, blue: vstrongBlue/255))
                            .cornerRadius(16)
                        
                        Text("Very Strong").foregroundColor(Color.init(red: vstrongRed/255, green: vstrongGreen/255, blue: vstrongBlue/255)).bold().font(.system(.title, design: .rounded)).fontWeight(.bold)
                    }
                }
            }.padding(.top, 20)
            
            /*
             ====================================================================================================================================
             MARK: New Notes Section
             ====================================================================================================================================
             */
//            VStack {
//                ZStack {
//                    VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
//                        .edgesIgnoringSafeArea(.all)
//                        .frame(width: UIScreen.main.bounds.size.width/1.2, height: UIScreen.main.bounds.size.height/8)
//                        .cornerRadius(16)
//
//                    TextField("Notes", text: $passwordNotes)
//                        .frame(width: UIScreen.main.bounds.size.width/1.3, height: UIScreen.main.bounds.size.height/4)
//                        .offset(y: -25)
//                        .padding(.horizontal, 10)
//                        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
//                        .animation(.easeInOut)
//                        .onTapGesture {
//                            self.isEditingNotes = true
//                    }
//
//                    if isEditingNotes {
//                        Button(action: {
//                            self.isEditingNotes = false
//
//                            // dismiss keyboard
//                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//
//                            self.addNote(newNote: self.passwordNotes)
//
//                        }) {
//                            ZStack {
//                                VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
//                                    .edgesIgnoringSafeArea(.all)
//                                    .frame(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.height/14)
//                                    .background(Color.init(red: stbRed/255, green: stbGreen/255, blue: stbBlue/255))
//                                    .cornerRadius(16)
//
//                                Text("Cancel")
//                                    .font(.system(.body, design: .rounded))
//                            }
//                        }
//                        .offset(y: 90)
//                        .transition(AnyTransition.move(edge: .top))
//                        .animation(.easeInOut)
//                    }
//                }
//            }.padding(.bottom, 60)
            
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
                    
                    Button(action: {
                        self.isEdit = true
                    })
                    {
                        Text("Edit Details")
                            .font(.system(.body, design: .rounded)).fontWeight(.bold)
                    }
                }
                
                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.size.width/3, height: UIScreen.main.bounds.size.height/14)
                        .background(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255))
                        .cornerRadius(16)
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        self.deleteEntry()
                    })
                    {
                        Text("Delete")
                            .foregroundColor(Color.init(red: weakRed/255, green: weakGreen/255, blue: weakBlue/255))
                            .font(.system(.body, design: .rounded)).fontWeight(.bold)
                    }
                }
            }.padding(.top, 40)
            .onAppear() {
                self.TestPass()
            }
            Spacer()
            
        }
//        .offset(y: -self.value)
//        .animation(.spring())
//        .onAppear() {
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
//                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//                let height = value.height
//
//                self.value = height
//            }
//
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
//
//                self.value = 0
//            }
//        }
        .sheet(isPresented: self.$isEdit) {
            EditView(description: self.description, loginItem: self.loginItem, password: self.password, newLogin: self.newLog, newPassword: self.newPass)
        }
        .banner(data: $bannerData, show: $showBanner)
        
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
    
//    func addNote(newNote: String) {
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequestNote:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Vault")
//
//        fetchRequestNote.predicate = NSPredicate(format: "notes = %@", note.notes ?? "no note found")
//
//        do {
//            let fetchReturnNote = try managedContext.fetch(fetchRequestNote)
//            let noteUpdate = fetchReturnNote[0] as! NSManagedObject
//
//            noteUpdate.setValue(newNote, forKey: "notes")
//
//            do {
//                try managedContext.save()
//                print("DEBUG: Saved new note information")
//            } catch let error as NSError {
//                print("DEBUG: Could not save new note information \(error), \(error.userInfo)")
//            }
//        } catch let error as NSError {
//            print("DEBUG: Could not fetch \(error), \(error.userInfo)")
//        }
//        
//    }
    
    func TestPass() {
        
        switch self.passwordTester.TestStrength(password: self.password.password!)
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
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State var description:Vault
    @State var loginItem:Vault
    @State var password:Vault
    
    @State var newLogin:String
    @State var newPassword:String
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section{
                    TextField("New login", text: $newLogin)
                    TextField("New password", text: $newPassword)
                }
                
                Button(action: {
                    self.updateEntry(newLogin: self.newLogin, newPass: self.newPassword)
                    self.presentationMode.wrappedValue.dismiss()
                })
                {
                    Text("Save")
                }
                
            }
            .navigationBarTitle("Enter New Details")
        }
    }
    
    /*
     ================================================================================================================================
     MARK: EditView Functions
     ================================================================================================================================
     */
    
    func updateEntry(newLogin:String, newPass:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestLogin:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Vault")
        let fetchRequestPassword:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Vault")
        
        fetchRequestLogin.predicate = NSPredicate(format: "loginItem = %@", loginItem.loginItem!)
        fetchRequestPassword.predicate = NSPredicate(format: "password = %@", password.password!)
        
        do {
            let fetchReturnLogin = try managedContext.fetch(fetchRequestLogin)
            let fetchReturnPassword = try managedContext.fetch(fetchRequestPassword)
            
            let loginUpdate = fetchReturnLogin[0] as! NSManagedObject
            let passwordUpdate = fetchReturnPassword[0] as! NSManagedObject
            
            loginUpdate.setValue(newLogin, forKey: "loginItem")
            passwordUpdate.setValue(newPass, forKey: "password")
            
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
//        PasswordDetailView(description: <#Vault#>, loginItem: <#Vault#>, password: <#Vault#>)
//    }
//}
