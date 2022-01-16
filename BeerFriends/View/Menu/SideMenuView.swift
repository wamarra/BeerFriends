//
//  SideMenuView.swift.swift
//  BeerFriends
//
//  Created by Wesley Marra on 08/12/21.
//

import SwiftUI
import simd

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    @StateObject var viewModel = ProfileViewModel()
    
    func getProfile() {
        if userSessionStoreViewModel.userSession?.uid != nil {
            viewModel.findProfile(by: userSessionStoreViewModel.userSession?.uid ?? "")
        }
    }
    
    func getSettings() -> Settings {
        return Settings(
            isDarkMode: viewModel.profile.isDarkMode ?? false,
            isBlockInvitation: viewModel.profile.isBlockInvitation ?? false,
            isPhoneHide: viewModel.profile.isPhoneHide ?? false)
    }
    
    @ViewBuilder
    func navigate(with menuOption: SideMenuOptions) -> some View {
        switch menuOption {
        case .configurations: SettingsView(settings: getSettings())
        case .profile: ProfileView().navigationBarHidden(true)
        case .friends: FriendListView().navigationBarHidden(true)
        case .terms: Text(menuOption.description)
        case .loggout: Text(menuOption.description)}
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.secondaryColor, Color.primaryColor]),
                           startPoint: .top,
                           endPoint: .bottom
            ).ignoresSafeArea()
            
            VStack(alignment: .leading) {
                SideMenuHeaderView(isShowing: $isShowing, profile: $viewModel.profile)
                    .frame(height: 240)
                
                ForEach(SideMenuOptions.allCases, id: \.self) { option in
                    if option == SideMenuOptions.loggout {
                        SideMenuOptionsView(menuOption: option)
                            .onTapGesture {
                                let result = userSessionStoreViewModel.signOut()
                                if (result) { print("Usuário saiu da sessão") }
                            }
                    } else {
                        NavigationLink(
                            destination: navigate(with: option),
                            label: {
                              SideMenuOptionsView(menuOption: option)
                            }
                        ).navigationTitle(option.description)
                    }
                }
                
                Spacer()
            }
            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: getProfile)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true))
            //.preferredColorScheme(.dark)
    }
}
