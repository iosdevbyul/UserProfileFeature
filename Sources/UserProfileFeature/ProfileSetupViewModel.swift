//
//  ProfileSetupViewModel.swift
//  UserProfileFeature
//
//  Created by COMATOKI on 2026-08-23.
//

import SwiftUI
import WakTrainerCoreModels

@MainActor
public final class ProfileSetupViewModel: ObservableObject {
    @Published public var gender: UserProfile.Gender = .male
    @Published public var birthDate: Date = Date()
    
    @Published public var heightInput: String = "175"
    @Published public var weightInput: String = "70"
    
    @Published public var heightUnit: HeightUnit = .cm
    @Published public var weightUnit: WeightUnit = .kg
    
    private let profileManager: UserProfileManager
    
    public enum HeightUnit: String, CaseIterable, Identifiable {
        case cm = "cm"
        case ft = "ft/in"
        public var id: String { self.rawValue }
    }
    
    public enum WeightUnit: String, CaseIterable, Identifiable {
        case kg = "kg"
        case lb = "lb"
        public var id: String { self.rawValue }
    }
    
    public init(profileManager: UserProfileManager = DefaultUserProfileManager.shared) {
        self.profileManager = profileManager
        
        if let existing = profileManager.profile {
            self.gender = existing.gender
            self.birthDate = existing.birthDate
            self.heightInput = String(format: "%.1f", existing.heightCm)
            self.weightInput = String(format: "%.1f", existing.weightKg)
        }
    }
    
    public var heightInCm: Double {
        guard let val = Double(heightInput) else { return 0 }
        return heightUnit == .cm ? val : val * 30.48
    }
    
    public var weightInKg: Double {
        guard let val = Double(weightInput) else { return 0 }
        return weightUnit == .kg ? val : val * 0.45359237
    }
    
    public func convertWeight(from oldUnit: WeightUnit, to newUnit: WeightUnit) {
        guard let currentVal = Double(weightInput) else { return }
        if oldUnit == .kg && newUnit == .lb {
            weightInput = String(format: "%.1f", currentVal * 2.20462)
        } else if oldUnit == .lb && newUnit == .kg {
            weightInput = String(format: "%.1f", currentVal / 2.20462)
        }
    }
    
    public func convertHeight(from oldUnit: HeightUnit, to newUnit: HeightUnit) {
        guard let currentVal = Double(heightInput) else { return }
        if oldUnit == .cm && newUnit == .ft {
            heightInput = String(format: "%.2f", currentVal / 30.48)
        } else if oldUnit == .ft && newUnit == .cm {
            heightInput = String(format: "%.1f", currentVal * 30.48)
        }
    }
    
    public func saveProfile() {
        let newProfile = UserProfile(
            gender: gender,
            birthDate: birthDate,
            heightCm: heightInCm,
            weightKg: weightInKg
        )
        profileManager.saveProfile(newProfile)
    }
}
