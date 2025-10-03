//
//  CreateTripView.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//

import SwiftUI
import PhotosUI

struct CreateTripView: View {
    @StateObject var viewModel: CreateTripViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        NavigationView {
            Form {
                
                // MARK: - Trip Photos
                Section {
                    
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            VStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 30))
                                    .padding()
                                Text("Trip Photos")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, minHeight: 120)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .foregroundColor(.gray)
                            )
                        }
                    }
                    
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            await MainActor.run {
                                selectedImage = uiImage
                                viewModel.imageData = data
                            }
                        }
                    }
                }
                
                Section {
                    // MARK: - Trip Details
                    VStack(alignment: .center, spacing: 30) {
                       
                        
                        TextField("Title", text: $viewModel.title)
                            .textFieldStyle(BorderedTextFieldStyle())
                        
                        TextField("Location", text: $viewModel.location)
                            .textFieldStyle(BorderedTextFieldStyle())
                        
                        
                        DatePicker("Occurence Date", selection: $viewModel.occurrenceDate, displayedComponents: .date)
                        
                        Stepper("Max Participants: \(viewModel.maxParticipants)", value: $viewModel.maxParticipants, in: 1...100)
                        
                        TextField("Price per Person", value: $viewModel.price, formatter: NumberFormatter.currency)
                            .textFieldStyle(BorderedTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        TextField("Description", text: $viewModel.description)
                            .textFieldStyle(BorderedTextFieldStyle(minHeight: 70))
                    }
                    .padding(3)
                } header: {
                    Text("Trip Details")
                }
                
            
                Section {
                   
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)]) {
                        ForEach(TripTag.allCases, id: \.self) { tag in
                            Text(tag.rawValue.capitalized)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    viewModel.isTagSelected(tag) ? Color.accentColor : Color.gray.opacity(0.15)
                                )
                                .foregroundColor(viewModel.isTagSelected(tag) ? .white : .primary)
                                .clipShape(Capsule())
                                .onTapGesture {
                                    if viewModel.isTagSelected(tag) {
                                        viewModel.removeTag(tag)
                                    } else {
                                        viewModel.insertTag(tag)
                                    }
                                }
                        }
                    }
                } header: {
                    Text("Trip Tags")
                }
            }
            .navigationTitle("Create Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        Task {
                            await viewModel.createTrip()
                            if viewModel.isSuccess {
                                dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Creating Trip…")
                }
            }
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#Preview {
    CreateTripView(viewModel: CreateTripFactory(coordinator: TripCoordinator()).getCreateTripViewModel())
}
