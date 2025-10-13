//
//  PhoneNumberInputView.swift
//  TavelsBuddies
//
//  Created by tarek on 12/10/2025.
//

import SwiftUI

struct PhoneNumberInputView: View {
    @Binding var phoneNumber: String
    @Binding var selectedCountryCode: CountryCode
    
    var body: some View {
        HStack {
            // Country Code Dropdown
            Menu {
                ForEach(CountryCode.allCodes) { countryCode in
                    Button {
                        selectedCountryCode = countryCode
                    } label: {
                        Label {
                            Text("\(countryCode.flag) \(countryCode.code)")
                        } icon: {
                            Text(countryCode.flag)
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selectedCountryCode.flag)
                        .font(.title3)
                    Text(selectedCountryCode.code)
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            Spacer()
            
            // Phone Number TextField
            TextField("Mobile Number", text: $phoneNumber)
                .textFieldStyle(BorderedTextFieldStyle())
                .textContentType(.telephoneNumber)
                .keyboardType(.phonePad)
        }
    }
}

