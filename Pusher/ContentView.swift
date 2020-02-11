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
                
                if $shellInteractor.basicMode.wrappedValue {
                    HStack {
                        Text("Enter icon badge count:")
                        TextField("0", text: $shellInteractor.badgeNumber)
                    }.padding()
                    HStack {
                        Text("Enter message identifier:")
                        TextField("ABCDEFGHIJ", text: $shellInteractor.messageId)
                    }.padding()
                } else {
                    HStack {
                        Text("Enter raw json for notification content")
                        ScrollView {
                            TextView(text: $shellInteractor.apnsContent).frame(minWidth: 100, idealWidth: 300, maxWidth: 400, minHeight: 44, idealHeight: 100, maxHeight: 400, alignment: .center)
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
