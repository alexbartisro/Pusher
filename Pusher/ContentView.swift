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
                    Text("Enter target bundle identifier:").frame(maxWidth: 230, alignment: .leading)
                    TextField("com.mycompany.app", text: $shellInteractor.bundleId).frame(maxWidth: 230, alignment: .leading)
                }.padding()
                
                if $shellInteractor.basicMode.wrappedValue {
                    HStack {
                        Text("Enter icon badge count:").frame(maxWidth: 230, alignment: .leading)
                        TextField("0", text: $shellInteractor.badgeNumber).frame(maxWidth: 230, alignment: .leading)
                        }.padding()
                    HStack {
                        Text("Enter notification title:").frame(maxWidth: 230, alignment: .leading)
                        TextField("Notification Title", text: $shellInteractor.title).frame(maxWidth: 230, alignment: .leading)
                    }.padding()
                    HStack {
                        Text("Enter notification subtitle:").frame(maxWidth: 230, alignment: .leading)
                        TextField("Notification Subtitle", text: $shellInteractor.subtitle).frame(maxWidth: 230, alignment: .leading)
                    }.padding()
                    HStack {
                        Text("Enter notification body:").frame(maxWidth: 230, alignment: .leading)
                        TextField("Notification body", text: $shellInteractor.body).frame(maxWidth: 230, alignment: .leading)
                    }.padding()
                } else {
                    HStack {
                        Text("Enter raw json for notification content")
                        ScrollView {
                            TextView(text: $shellInteractor.apnsContent).frame(minWidth: 100, idealWidth: 300, maxWidth: 400, minHeight: 44, idealHeight: 100, maxHeight: 400, alignment: .leading)
                        }
                    }.padding()
                }
                
                Text("Found Running Sim: ")
                Text(self.shellInteractor.shellOutput).fontWeight(.semibold)
                
                HStack {
                    Button(action: {
                        self.shellInteractor.basicMode.toggle()
                    }) {
                        if $shellInteractor.basicMode.wrappedValue {
                            Text("Expert Mode")
                                .fontWeight(.semibold)
                        } else {
                            Text("Basic Mode")
                                .fontWeight(.semibold)
                        }
                    }.padding()
                    
                    if $shellInteractor.simulatorsFound.wrappedValue {
                        Button(action: {
                            self.shellInteractor.generateNotification {
                                self.shellInteractor.sendNotification()
                            }
                        }) {
                            Text("SEND!!!")
                                .fontWeight(.semibold)
                        }.padding()
                    } else {
                        Button(action: {
                            self.shellInteractor.refreshSimulators()
                        }) {
                            Text("Refresh")
                                .fontWeight(.semibold)
                        }.padding()
                    }
                }
            }.padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ShellInteractor())
    }
}
