//
//  NotificationBannerView.swift
//  Umbriel
//
//  Created by Ryan Mottram on 22/08/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import SwiftUI

struct NotificationBannerView: View {
    
    var body: some View {
        
        HStack {
            Image(systemName: "info.circle").font(.system(.body, design: .rounded))
            Text("Copied to clipboard!").font(.system(.caption, design: .rounded))
            Spacer()
        }
        .padding()
        .foregroundColor(.white)
        .frame(width: UIScreen.main.bounds.width/1.2, height: 30)
        .background(Color.init(red: 58/255, green: 146/255, blue: 236/255))
        .cornerRadius(10)
        
    }
}

struct NotificationBannerView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBannerView()
    }
}
