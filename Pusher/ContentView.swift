//
//  ContentView.swift
//  Pusher
//
//  Created by Alex Bartis on 10/02/2020.
//  Copyright © 2020 Alex Bartis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var shellInteractor: ShellInteractor
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Enter target bundle identifier:")
                    TextField("com.mycompany.app", text: $shellInteractor.bundleId)
                }.padding()
                HStack {
                    Text("Enter icon badge count:")
                    TextField("0", text: $shellInteractor.badgeNumber)
                }.padding()
                HStack {
                    Text("Enter message identifier:")
                    TextField("ABCDEFGHIJ", text: $shellInteractor.messageId)
                }.padding()
                
                Text("Found Running Sim: ")
                Text(self.shellInteractor.shellOutput).fontWeight(.semibold)
                Button(action: {
                    self.shellInteractor.sendNotification()
                }) {
                    Text("SEND!!!")
                    .fontWeight(.semibold)
                }.padding()
            }.padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ShellInteractor())
    }
}
