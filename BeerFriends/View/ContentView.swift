//
//  ContentView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 29/11/21.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
//    @EnvironmentObject var profileViewModel: ProfileViewModel

    @Environment(\.colorScheme) var colorScheme

    @State
    private var dummy: String = UUID().uuidString
    
    func getUser () {
        userSessionStoreViewModel.listen()
//        if userSessionStoreViewModel.userSession != nil && userSessionStoreViewModel.userSession?.uid != nil {
//            profileViewModel.findProfile(by: userSessionStoreViewModel.userSession?.uid ?? "")
//        }
    }

    var body: some View {
        Group {
            if userSessionStoreViewModel.userSession != nil {
                FriendListView().environmentObject(userSessionStoreViewModel)
            } else {
                if UserDefaults.standard.string(forKey: "Onboarding") == nil {
                    OnboardingView()
                } else {
                    LoginWrapperView()
                }
            }
            
        }
        .onAppear(perform: getUser)
//        .preferredColorScheme(profileViewModel.profile.isDarkMode == true ? .dark : .light)
        .onChange(of: isDarkMode) { _ in
            dummy = UUID().uuidString
        }
        .onChange(of: colorScheme) { newValue in
            isDarkMode = newValue == .dark
        }
    }
}
