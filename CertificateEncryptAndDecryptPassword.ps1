#------------------------------

#Encrypt Password
$NewCertificate = New-SelfSignedCertificate -NotAfter (Get-Date).AddYears(10) -KeyAlgorithm RSA -KeyLength 2048 -Provider 'Microsoft Enhanced RSA and AES Cryptographic Provider' -Subject "Password encryption (test)" -CertStoreLocation Cert:\LocalMachine\My

$Password = 'Lösenordet' # The password to be encrypted
$Certificate = Get-ChildItem Cert:\LocalMachine\My\$($NewCertificate.Thumbprint) # The Certificate used to encrypt the password

$PasswordBytes = [System.Text.Encoding]::UTF8.GetBytes($Password) # Convert password to bytes (encrypt method overloads are Encrypt(Byte[], Boolean) Encrypts data with the RSA algorithm.)
$EncryptedBytes = $Certificate.PublicKey.Key.Encrypt($PasswordBytes, $true) # Encrypt password bytes
$EncryptedPassword = [System.Convert]::ToBase64String($EncryptedBytes) # Convert encrypted password bytes into base64


#Decrypt Password
$Certificate = Get-ChildItem Cert:\LocalMachine\My\E929E18F3337A8AF71AC7CBAA758681474F41475
$EncryptedPassword = 'ZU2lvKWApu/eh6DGmBlgNlrlu+xa+TVqdhJlLnYbpJdY5AYGua9tVIsp2xBd1oGKHH3Skzh49+2TleogWq+2vp4+QDxfxo2TTGW8ZF6iro0dujs/UYWixnPt5ucZqP0Ob6jn1MOHiEqRI7ZdaLDG0eDAeErCGvJfdiH49YBXZwStV9zChBzJBZIETCXeZh+VLxg5yT6tATM14jkPgjCDIQWl7n73Bn3XEiinRCY7sZ2veoydX7dy7eH5kuEph++wml23bs3pAKcDSyFixIzT8VNo4r//R2OgCPExvYog29JJUxSORtwgboHAjWqh0cLmqAyEAGXzQCKOwERqyCfmjg=='

$EncryptedBytes = [System.Convert]::FromBase64String($EncryptedPassword)
$DecryptedBytes = $Certificate.PrivateKey.Decrypt($EncryptedBytes, $true)
$DecryptedPassword = [System.Text.Encoding]::UTF8.GetString($DecryptedBytes)

$DecryptedPassword

#------------------------------

function Encrypt-Password {
    param($ClearTextPassword,$CertificateThumbprint,$CertificateStore = 'Cert:\LocalMachine\My')
    $Certificate = Get-Item "$CertificateStore\$CertificateThumbprint"
    $PasswordBytes = [System.Text.Encoding]::UTF8.GetBytes($ClearTextPassword)
    $EncryptedBytes = $Certificate.PublicKey.Key.Encrypt($PasswordBytes, $true)
    $EncryptedPassword = [System.Convert]::ToBase64String($EncryptedBytes)
    return $EncryptedPassword
}

Encrypt-Password -ClearTextPassword "DettaÄrEttHemligtLösenord!" -CertificateThumbprint 944E7431805344BB491318B4F59ECFD6277C7D6B

function Decrypt-Password {
    param($EncryptedBase64Password,$CertificateThumbprint,$CertificateStore = 'Cert:\LocalMachine\My')
    $Certificate = Get-Item "$CertificateStore\$CertificateThumbprint"
    $EncryptedBytes = [System.Convert]::FromBase64String($EncryptedBase64Password)
    $DecryptedBytes = $Certificate.PrivateKey.Decrypt($EncryptedBytes, $true)
    $DecryptedPassword = [System.Text.Encoding]::UTF8.GetString($DecryptedBytes)
    return ConvertTo-SecureString $DecryptedPassword -AsPlainText -Force
}

Decrypt-Password -EncryptedBase64Password BRN4oekHqguhbvSk/2s5xUslpIZ6MQS0IThwxPi6ZKmPOQjjLMcUYRaFgsHcnQjkTQQUTmYBKcZwVMlbclunW7OpQxSl0KViWLWwNXtOubpGPD/Dje9tQeM11KVhrV7e3YfCoqUAIDsfFHMgHpJKKuvea5dvqtkiVSy38ZZT8wqkXDzIhecwwPw9c7ta7Xk0rBsUW9gQHyDwPHfkav931e0sVjME2I+A4DX1IMTO41F/sUN1Rs4/xq3AgxGAvqDCJFuoh/TQJP2e4U2tQqOXZLPbXYMy0yNc4Ps49wcu5yJT9mYRjzAjP4au9Ed5zhhO4wHn6yiyEkoP7C9g18rDYQ== -CertificateThumbprint 944E7431805344BB491318B4F59ECFD6277C7D6B
