* I want to change how this works so that it can be run as a command line script
  * Will need a short run deamon that will store the password so that it isn't needed to entered before each command
  * Need a shell that will set environment variables for state
  * Need an infrastructure for sub-commands
* Add support for `use Data::Password::zxcvbn 'password_strength';` to indicate quality of passwords
  * See https://www.perl.com/article/how-strong-is-your-password-/
