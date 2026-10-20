//
//  ProfileSetupView.swift
//  UserProfileFeature
//
//  Created by COMATOKI on 2026-08-24.
//

import SwiftUI
import WakTrainerCoreModels

public struct ProfileSetupView: View {
    @StateObject
    private var viewModel: ProfileSetupViewModel

    @Environment(\.presentationMode)
    private var presentationMode

    @State
    private var previousHeightUnit:
        ProfileSetupViewModel.HeightUnit

    @State
    private var previousWeightUnit:
        ProfileSetupViewModel.WeightUnit

    public init(
        viewModel:
            ProfileSetupViewModel =
                ProfileSetupViewModel()
    ) {
        let vm = viewModel

        _viewModel =
            StateObject(
                wrappedValue: vm
            )

        _previousHeightUnit =
            State(
                initialValue:
                    vm.heightUnit
            )

        _previousWeightUnit =
            State(
                initialValue:
                    vm.weightUnit
            )
    }

    public var body: some View {
        NavigationView {
            Form {
                Section(
                    header:
                        Text(
                            L10n.string(
                                "profile.gender"
                            )
                        )
                ) {
                    Picker(
                        L10n.string(
                            "profile.gender"
                        ),
                        selection:
                            $viewModel.gender
                    ) {
                        ForEach(
                            UserProfile.Gender.allCases,
                            id: \.self
                        ) { gender in
                            Text(
                                genderTitle(
                                    gender
                                )
                            )
                            .tag(gender)
                        }
                    }
                    .pickerStyle(
                        SegmentedPickerStyle()
                    )
                }

                Section(
                    header:
                        Text(
                            L10n.string(
                                "profile.birth_date"
                            )
                        )
                ) {
                    DatePicker(
                        L10n.string(
                            "profile.birth_date"
                        ),
                        selection:
                            $viewModel.birthDate,
                        displayedComponents:
                            .date
                    )
                    .datePickerStyle(
                        CompactDatePickerStyle()
                    )
                }

                Section(
                    header:
                        Text(
                            L10n.string(
                                "profile.height"
                            )
                        )
                ) {
                    HStack {
                        TextField(
                            L10n.string(
                                "profile.height_placeholder"
                            ),
                            text:
                                $viewModel.heightInput
                        )
                        .keyboardType(
                            .decimalPad
                        )

                        Picker(
                            L10n.string(
                                "profile.unit"
                            ),
                            selection:
                                $viewModel.heightUnit
                        ) {
                            ForEach(
                                ProfileSetupViewModel
                                    .HeightUnit
                                    .allCases
                            ) { unit in
                                Text(
                                    unit.rawValue
                                )
                                .tag(unit)
                            }
                        }
                        .pickerStyle(
                            MenuPickerStyle()
                        )
                        .onChange(
                            of:
                                viewModel.heightUnit
                        ) { newUnit in
                            viewModel
                                .convertHeight(
                                    from:
                                        previousHeightUnit,
                                    to:
                                        newUnit
                                )

                            previousHeightUnit =
                                newUnit
                        }
                    }
                }

                Section(
                    header:
                        Text(
                            L10n.string(
                                "profile.weight"
                            )
                        )
                ) {
                    HStack {
                        TextField(
                            L10n.string(
                                "profile.weight_placeholder"
                            ),
                            text:
                                $viewModel.weightInput
                        )
                        .keyboardType(
                            .decimalPad
                        )

                        Picker(
                            L10n.string(
                                "profile.unit"
                            ),
                            selection:
                                $viewModel.weightUnit
                        ) {
                            ForEach(
                                ProfileSetupViewModel
                                    .WeightUnit
                                    .allCases
                            ) { unit in
                                Text(
                                    unit.rawValue
                                )
                                .tag(unit)
                            }
                        }
                        .pickerStyle(
                            MenuPickerStyle()
                        )
                        .onChange(
                            of:
                                viewModel.weightUnit
                        ) { newUnit in
                            viewModel
                                .convertWeight(
                                    from:
                                        previousWeightUnit,
                                    to:
                                        newUnit
                                )

                            previousWeightUnit =
                                newUnit
                        }
                    }
                }

                Section {
                    Button {
                        viewModel.saveProfile()

                        presentationMode
                            .wrappedValue
                            .dismiss()
                    } label: {
                        Text(
                            L10n.string(
                                "profile.save"
                            )
                        )
                        .font(.headline)
                        .frame(
                            maxWidth:
                                .infinity,
                            alignment:
                                .center
                        )
                    }
                }
            }
            .navigationTitle(
                L10n.string(
                    "profile.navigation_title"
                )
            )
        }
    }

    private func genderTitle(
        _ gender:
            UserProfile.Gender
    ) -> String {
        switch gender {
        case .male:
            return L10n.string(
                "profile.gender.male"
            )

        case .female:
            return L10n.string(
                "profile.gender.female"
            )

        case .other:
            return L10n.string(
                "profile.gender.other"
            )
        }
    }
}

struct ProfileSetupView_Previews:
    PreviewProvider {

    static var previews: some View {
        ProfileSetupView()
    }
}
