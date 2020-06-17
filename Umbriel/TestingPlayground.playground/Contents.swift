import UIKit
import Foundation

enum StrengthScore: Int
{
    case Blank = 0
    case Weak = 2
    case Average = 5
    case Strong = 8
    case VeryStrong = 10
}

let mypassword = "passwordBA111"
// "^([A-Za-z0-9!@#$%^&*()\\-_=+{}|?>.<,:;~`’]){2,}$"
// let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{2,}$"

// master regex
//func isValidPassword(password: String) -> Bool
//{
//    let passwordRegex = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,}$"
//    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//}
//isValidPassword(password: mypassword)






// works
func isMoreThanOneUpper(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[A-Z]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanOneUpper(password: mypassword)

// works
func isMoreThanTwoUpper(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[A-Z].*[A-Z]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanTwoUpper(password: mypassword)

// works
func isMoreThanThreeUpper(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[A-Z].*[A-Z].*[A-Z]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanThreeUpper(password: mypassword)

// works
func isMoreThanOneLower(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[a-z]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanOneLower(password: mypassword)

// works
func isMoreThanTwoLower(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[a-z].*[a-z]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanTwoLower(password: mypassword)

// works
func isMoreThanThreeLower(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[a-z].*[a-z].*[a-z]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanThreeLower(password: mypassword)

// works
func isMoreThanOneNumber(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[0-9]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanOneNumber(password: mypassword)

// works
func isMoreThanTwoNumbers(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[0-9].*[0-9]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanTwoNumbers(password: mypassword)

// works
func isMoreThanThreeNumbers(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[0-9].*[0-9].*[0-9]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanThreeNumbers(password: mypassword)

// works
func isMoreThanOneSpecial(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[-{};:,.<>£!@#_$&*]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanOneSpecial(password: mypassword)

// works
func isMoreThanTwoSpecial(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[-{};:,.<>£!@#_$&*].*[-{};:,.<>£!@#_$&*]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanTwoSpecial(password: mypassword)

// works
func isMoreThanThreeSpecial(password: String) -> Bool
{
    let passwordRegex = "^(?=.*[-{};:,.<>£!@#_$&*].*[-{};:,.<>£!@#_$&*].*[-{};:,.<>£!@#_$&*]).{1,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanTwoSpecial(password: mypassword)

func TestStrength(password: String) -> Double
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
    return score
}

//TestStrength(password: "zH3£qQP8*)(m9mB0")


func myFunc(password: String)
{
    let input: StrengthScore
    
    switch input {
        case .Blank:
        print("DEBUG: Password is blank!")
        case .Weak:
        print("DEBUG: Password is weak!")
        case .Average:
        print("DEBUG: Password is average!")
        case .Strong:
        print("DEBUG: Password is strong!")
        case .VeryStrong:
        print("DEBUG: Password is very strong!")
    }
}

myFunc(password: mypassword)





//let passwordRegex = ("^(?=.*[@#$%^&*])$")
//let passwordCheck = NSPredicate(format: "SELF MATCHES %@", passwordRegex)




/*
 total of 2 points for 16+ characters
 one upper and lower = 1
 one number = 0.5
 one special = 0.5
 
 2 lower and upper = 2
 2 numbers = 1
 2 special = 1
 
 3 lower and upper = 3
 3 numbers = 2
 3 special = 2
 
 final point =
 
*/

