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

let mypassword = "PAAAA"
// "^([A-Za-z0-9!@#$%^&*()\\-_=+{}|?>.<,:;~`’]){2,}$"

// master regex
//func isValidPassword(password: String) -> Bool
//{
//    let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
//    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//}
//isValidPassword(password: mypassword)

// works
func isMoreThanTwoUpper(password: String) -> Bool
{
    let passwordRegex = "^[A-Za-z]{2,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
isMoreThanTwoUpper(password: mypassword)

// works
//func isMoreThanTwoLower(password: String) -> Bool
//{
//    let passwordRegex = "^([a-z]{2,})$"
//    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//}
//isMoreThanTwoLower(password: mypassword)

// works
//func isMoreThanTwoNumbers(password: String) -> Bool
//{
//    let passwordRegex = "^([0-9]{2,})$"
//    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//}
//isMoreThanTwoNumbers(password: mypassword)

// works
//func isMoreThanTwoSpecial(password: String) -> Bool
//{
//    let passwordRegex = "^[!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{2,}$"
//    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//}
//isMoreThanTwoSpecial(password: mypassword)

// works
//func isMoreThanTwoAll(password: String) -> Bool
//{
//    let passwordRegex = "^([A-Za-z0-9!@#$%^&*()\\-_=+{}|?>.<,:;~`’]){2,}$"
//    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//}
//isMoreThanTwoAll(password: mypassword)



func TestStrength(password: String) -> Double
{
    var score:Double = 0
    
    if password.count == 0 {
        score += 0
        print("Nothing entered")
    }
    if password.count > 1 {
        score += 0.5
        print("1+ entered")
    }
    if password.count > 6 {
        score += 0.5
        print("6+ entered")
    }
    if password.count > 11 {
        score += 0.5
        print("11+ entered")
    }
    if password.count > 16 {
        score += 0.5
        print("16+ entered")
    }
    if isMoreThanTwoUpper(password: password)
    {
        score += 1
        print("2 or more upper entered")
    }
    
    return score
}

TestStrength(password: "PAAAAAssword<>?,.")


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

