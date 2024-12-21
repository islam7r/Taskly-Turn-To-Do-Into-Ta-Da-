//
//  RegisterView.swift
//  Taskly
//
//  Created by Islam Rzayev on 05.12.24.
//

import SwiftUI
import FirebaseAuth
import AuthenticationServices
import Combine

struct RegisterView: View {
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var showAlert: Bool = false
   
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
       
        NavigationStack {
            
                ZStack {
                    LinearGradient(colors: [
                        Color(red: 0.14, green: 0.21, blue: 0.26),
                        Color(red: 0.89, green: 0.95, blue: 0.91)
                    ], startPoint: .bottom, endPoint: .top)
                    .ignoresSafeArea()
                    
                    ScrollView {
                        VStack {
                            Text("Taskly")
                                .font(Font.custom("LondrinaSketch-Regular", size: 70))
                                .padding(.top)
                                .foregroundStyle(Color(red: 0.14, green: 0.21, blue: 0.26))
                                
                            
                            Text("Register")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .padding()
                            
                            Group {
                                TextField("Name", text: $name)
                                TextField("Email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                SecureField("Password", text: $password)
                                ZStack(alignment: .trailing) {
                                    SecureField("Confirm Password", text: $confirmPassword)
                                    if !password.isEmpty && !confirmPassword.isEmpty {
                                        if password == confirmPassword {
                                            Image(systemName: "checkmark.circle.fill")
                                                .imageScale(.large)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(.systemGreen))
                                        } else {
                                            Image(systemName: "xmark.circle.fill")
                                                .imageScale(.large)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(.systemRed))
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.6))
                            .border(Color.white, width: 1)
                            .frame(width: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            
                            Button{
                                Task{
                                    try await viewModel.signUp(name: name, email: email, password: password)
                                    if viewModel.errorMessage != nil {
                                                showAlert = true
                                            }
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 300, height: 55)
                                    .foregroundStyle(Color.black)
                                    .padding()
                                    .shadow(color: Color.black.opacity(0.8), radius: 10, x: -10, y: 5)
                                
                                    .overlay {
                                        Text("Register")
                                            .foregroundStyle(.cyan)
                                            .font(Font.system(size: 20))
                                    }
                            }
                            .disabled(!formIsValid)
                            .opacity(formIsValid ? 1.0 : 0.5)
                            .alert("Failed to register", isPresented: $showAlert) {
                                    Button("OK", role: .cancel) { }
                                } message: {
                                    Text(viewModel.errorMessage ?? "An unknown error occurred.")
                                }
                            
                            Spacer()
                            
                            HStack {
                                VStack { Divider() }
                                Text("or")
                                VStack { Divider() }
                            }
                            .padding()
                            
                            HStack {
                                Text("Already have an account?")
                                    .foregroundStyle(.white)
                                NavigationLink(destination: LoginView()) {
                                    Text("Login")
                                        .foregroundStyle(.cyan)
                                        .fontWeight(.bold)
                                }
                                .navigationBarBackButtonHidden(true)
                            }
                            .padding()
                        }
                    }
                }
            
            }
        }
    }

extension RegisterView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 5
            && confirmPassword == password
            && !name.isEmpty
    }
}


#Preview {
    NavigationStack{
        RegisterView()
            .environmentObject(DailyTaskViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(MeetingViewModel())
           
    }
    
}
