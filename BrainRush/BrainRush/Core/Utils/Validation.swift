//
//  Validation.swift
//  BrainRush
//
//  Input validation utilities
//

import Foundation

struct Validation {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        // At least 8 characters
        guard password.count >= 8 else { return false }
        return true
    }
    
    static func isStrongPassword(_ password: String) -> Bool {
        // At least 8 characters, one uppercase, one lowercase, one number
        guard password.count >= 8 else { return false }
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        return hasUppercase && hasLowercase && hasNumber
    }
    
    static func validateQuizAnswer(_ answer: String, for question: QuizQuestion) -> Bool {
        guard let correctAnswer = question.correctAnswer else { return false }
        return answer.trimmingCharacters(in: .whitespaces).lowercased() == correctAnswer.trimmingCharacters(in: .whitespaces).lowercased()
    }
}

extension String {
    var isValidEmail: Bool {
        Validation.isValidEmail(self)
    }
    
    var isValidPassword: Bool {
        Validation.isValidPassword(self)
    }
    
    var isStrongPassword: Bool {
        Validation.isStrongPassword(self)
    }
}
