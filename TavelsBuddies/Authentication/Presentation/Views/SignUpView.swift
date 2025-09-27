//
//  SignUpView.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import SwiftUI
import PhotosUI


struct SignUpView: View {
    
    @StateObject var ViewModel : SignUpViewModel
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                // 👇 PhotosPicker button
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        
                        VStack {
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 200, height: 200)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .font(.title)
                                            .foregroundColor(.blue)
                                    )
                            }
                            
                            Text("Add Your Profile Image")
                        }
                       
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let newItem,
                               let data = try? await newItem.loadTransferable(type: Data.self) {
                                
                                ViewModel.profileImageData = data   // send to ViewModel
                                
                                if let uiImage = UIImage(data: data) {
                                    profileImage = Image(uiImage: uiImage)  // show immediately
                                }
                            }
                        }
                    }
                
            }
            
            VStack(alignment: .center,spacing: 30) {
                TextField("Email", text: $ViewModel.email)
                    .textFieldStyle(BorderedTextFieldStyle())
                SecureField("Password", text: $ViewModel.password)
                    .textFieldStyle(BorderedTextFieldStyle())
                
                TextField("UserName", text: $ViewModel.userName)
                    .textFieldStyle(BorderedTextFieldStyle())
                
                TextField("Description", text: $ViewModel.description)
                    .textFieldStyle(BorderedTextFieldStyle(minHeight: 70))
                
                TextField("Address", text: $ViewModel.address)
                    .textFieldStyle(BorderedTextFieldStyle())
            }
            .padding()
            
            
            Button("Sign Up") {
                ViewModel.handleSignupFlow()
            }
            .buttonStyle(PrimaryButtonStyle())
            
            HStack {
                Text("Already have an account?")
                
                Button("Sign In") {
                    ViewModel.popToSignIn()
                }
            }
            
        }
        .navigationTitle("Join Tavels Buddies Now !")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}


#Preview {
    NavigationStack {
        SignUpView(ViewModel: SignUpFactory(coordinator: AppCoordinator()).getSignupViewModel())
    }
    
}



