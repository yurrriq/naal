#! /usr/bin/env expect

spawn -noecho aws-azure-login --force-refresh --no-prompt

expect "*Password:*" {
    set password [ exec pass show "Azure AD" | head -n1 ]
    send "$password\r"
}

expect "*Verification Code:*" {
    set verification_code [ exec pass otp show "Azure AD" ]
    send "$verification_code\r"
}

interact
