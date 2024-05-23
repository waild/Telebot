# Readme for Telebot project
t.me/mpanch_bot

# set env variable
1. SET TELE_TOKEN=token

# install dependencies
2. go get

# build
3. go build -ldflags="-X 'Telebot/cmd.appVersion=versions'"

# run
4. ./Telebot start

# usage commands:
 /hello


 # dev notes:
 1. Installing gitleaks
`
git clone https://github.com/gitleaks/gitleaks.git
cd gitleaks
make build
`
