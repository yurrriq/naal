#! /usr/bin/env expect

spawn -noecho aws-azure-login --force-refresh --no-prompt

set password [ exec pass show "Azure AD" | head -n1 ]
expect "*Password:*" { send "$password\n" }

set verification_code [ exec pass otp show "Azure AD" ]
expect "*Verification Code:*" { send "$verification_code\n" }

interact
