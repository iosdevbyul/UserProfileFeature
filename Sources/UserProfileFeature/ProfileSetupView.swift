//
//  ProfileSetupView.swift
//  UserProfileFeature
//
//  Created by COMATOKI on 2026-08-24.
//

import SwiftUI
import WakTrainerCoreModels

public struct ProfileSetupView: View {
    @StateObject private var viewModel: ProfileSetupViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    // 이전 단위 기억용 로컬 State
    @State private var previousHeightUnit: ProfileSetupViewModel.HeightUnit
    @State private var previousWeightUnit: ProfileSetupViewModel.WeightUnit
    
    public init(viewModel: ProfileSetupViewModel = ProfileSetupViewModel()) {
        let vm = viewModel
        _viewModel = StateObject(wrappedValue: vm)
        _previousHeightUnit = State(initialValue: vm.heightUnit)
        _previousWeightUnit = State(initialValue: vm.weightUnit)
    }
    
    public var body: some View {
        NavigationView {
            Form {
                // 1. 성별 선택
                Section(header: Text("성별")) {
                    Picker("성별", selection: $viewModel.gender) {
                        ForEach(UserProfile.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // 2. 생년월일
                Section(header: Text("생년월일")) {
                    DatePicker("생년월일", selection: $viewModel.birthDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                }
                
                // 3. 신장 (단위 변환)
                Section(header: Text("신장 (키)")) {
                    HStack {
                        TextField("신장 입력", text: $viewModel.heightInput)
                            .keyboardType(.decimalPad)
                        
                        Picker("단위", selection: $viewModel.heightUnit) {
                            ForEach(ProfileSetupViewModel.HeightUnit.allCases) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: viewModel.heightUnit) { newUnit in
                            viewModel.convertHeight(from: previousHeightUnit, to: newUnit)
                            previousHeightUnit = newUnit
                        }
                    }
                }
                
                // 4. 체중 (단위 변환)
                Section(header: Text("체중")) {
                    HStack {
                        TextField("체중 입력", text: $viewModel.weightInput)
                            .keyboardType(.decimalPad)
                        
                        Picker("단위", selection: $viewModel.weightUnit) {
                            ForEach(ProfileSetupViewModel.WeightUnit.allCases) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: viewModel.weightUnit) { newUnit in
                            viewModel.convertWeight(from: previousWeightUnit, to: newUnit)
                            previousWeightUnit = newUnit
                        }
                    }
                }
                
                // 5. 저장 버튼
                Section {
                    Button(action: {
                        viewModel.saveProfile()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("프로필 저장")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("신체 정보 설정")
        }
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView()
    }
}
