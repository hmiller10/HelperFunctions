# **To generate a secret for Github or PS Gallery**
***Pre-requisites:***
Download and install Kleopatra at: [https://gnupg.org](https://)
Download and install Git for Windows at:[ https://git-scm.com](https://)

***Steps:***
Open Git Bash
View ant existing secrets, this will determine whether or not you will need to continue or not.
Type: **gh secret list**

To generate a new key:
* Type: gpg --full-generate-key
* Select encryption method. I chose RSA and RSA (default) or Option 1
* Set the key length to at least 4096
* Choose how long the key will be valid. Select 0 if you don't want the key to expire.
* Confirm key validity choice
* Enter your name and a valid e-mail address
* Enter a secure passphrase
* Follow any instructions shown on the console to create key entropy
* To view the neew key type: gpg --list-secret-keys --keyid-format=long
* Select the key id (the alphanumeric sequence after the /) and copy it to the clipboard

To export the key for import into Kleopatra:
* Type: gpg --armor --export paste key id from clipboard
* Using your mouse select everything between:
* -----BEGIN PGP PUBLIC KEY BLOCK-----
* 
* -----END PGP PUBLIC KEY BLOCK-----
* 
* NOTE **Be sure to remove any leading or trailing white spaces.**

Add the GPG key to your Github account:

* Mouse click on your profile icon in the upper, right-hand corner of your Github site page.
* Choose Settings.
* Inside the 'Action' settings, mouse click on 'SSH and GPG keys'
* Click 'New GPG key'
* In the 'Key' window, paste the contents that were copied to the keyboard from the Git Bash session.
* Click 'Add GPG key'
* Confirm your Github password

Links:
https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-new-gpg-key-to-your-github-account