//
//  PasswordStrengthLogic.swift
//  Umbriel
//
//  Created by Ryan Mottram on 15/06/2020.
//  Copyright © 2020 Ryan Mottram. All rights reserved.
//

import Foundation

class PasswordLogic
{
    let mypassword = ""
    
    // works
    func isMoreThanOneUpper(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[A-Z]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    
    // works
    func isMoreThanTwoUpper(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[A-Z].*[A-Z]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // works
    func isMoreThanThreeUpper(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[A-Z].*[A-Z].*[A-Z]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // works
    func isMoreThanOneLower(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[a-z]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // works
    func isMoreThanTwoLower(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[a-z].*[a-z]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // works
    func isMoreThanThreeLower(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[a-z].*[a-z].*[a-z]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // works
    func isMoreThanOneNumber(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[0-9]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // works
    func isMoreThanTwoNumbers(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[0-9].*[0-9]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // works
    func isMoreThanThreeNumbers(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[0-9].*[0-9].*[0-9]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // works
    func isMoreThanOneSpecial(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[-{};:,.<>£!@#_$&*]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // works
    func isMoreThanTwoSpecial(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[-{};:,.<>£!@#_$&*].*[-{};:,.<>£!@#_$&*]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // works
    func isMoreThanThreeSpecial(password: String) -> Bool
    {
        let passwordRegex = "^(?=.*[-{};:,.<>£!@#_$&*].*[-{};:,.<>£!@#_$&*].*[-{};:,.<>£!@#_$&*]).{1,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func TestStrength(password: String) -> StrengthScore
    {
        var score:Double = 0
        
        if password.count == 0 {
            score += 0
            print("DEBUG: Nothing entered. Score = \(score)")
        }
        if password.count >= 1 {
            score += 0
            print("DEBUG: longer than 1 character entered. Score =  \(score)")
        }
        if password.count >= 6 {
            score += 0.5
            print("DEBUG: longer than 6 characters entered. Score =  \(score)")
        }
        if password.count >= 11 {
            score += 0.5
            print("DEBUG: longer than 11 characters entered. Score =  \(score)")
        }
        if password.count >= 16 {
            score += 1
            print("DEBUG: longer than 16 characters entered. Score =  \(score)")
        }
        if isMoreThanThreeUpper(password: password)
        {
            score += 2
            print("DEBUG: at least 3 upper entered. Score =  \(score)")
        }
        else if isMoreThanTwoUpper(password: password)
        {
            score += 1
            print("DEBUG: at least 2 upper entered. Score =  \(score)")
        }
        else if isMoreThanOneUpper(password: password)
        {
            score += 0.5
            print("DEBUG: at least 1 upper entered. Score =  \(score)")
        }
        if isMoreThanThreeLower(password: password)
        {
            score += 2
            print("DEBUG: at least 3 lower entered. Score =  \(score)")
        }
        else if isMoreThanTwoLower(password: password)
        {
            score += 1
            print("DEBUG: at least 2 lower entered. Score =  \(score)")
        }
        else if isMoreThanOneLower(password: password)
        {
            score += 0.5
            print("DEBUG: at least 1 lower entered. Score =  \(score)")
        }
        if isMoreThanThreeNumbers(password: password)
        {
            score += 2
            print("DEBUG: at least 3 numbers entered. Score =  \(score)")
        }
        else if isMoreThanTwoNumbers(password: password)
        {
            score += 1
            print("DEBUG: at least 2 numbers entered. Score =  \(score)")
        }
        else if isMoreThanOneNumber(password: password)
        {
            score += 0.5
            print("DEBUG: at least 1 numbers entered. Score =  \(score)")
        }
        if isMoreThanThreeSpecial(password: password)
        {
            score += 2
            print("DEBUG: at least 3 special entered. Score =  \(score)")
        }
        else if isMoreThanTwoSpecial(password: password)
        {
            score += 1
            print("DEBUG: at least 2 special entered. Score =  \(score)")
        }
        else if isMoreThanOneSpecial(password: password)
        {
            score += 0.5
            print("DEBUG: at least 1 special entered. Score =  \(score)")
        }
        
        print("DEBUG: End of scoring, final score = \(score)")
        
        switch score {
            case 0:
                return .Blank
            case 1...2:
                return .Weak
            case 3...5:
                return .Average
            case 6...8:
                return .Strong
            case 9...:
                return .VeryStrong
            default:
                return .Blank
        }
    }
    
    enum StrengthScore: Int
    {
        case Blank = 0
        case Weak = 2
        case Average = 5
        case Strong = 8
        case VeryStrong = 10
    }
}

