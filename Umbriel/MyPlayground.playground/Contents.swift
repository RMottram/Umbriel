import UIKit

let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[A-z])(?=.*[0-9])(?=.*[!@£$%^&*-=+_#?]).{8,26}$")

password.evaluate(with: "pas$worD1")
password.evaluate(with: "passW0rd")
password.evaluate(with: "password1")


