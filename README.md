# CryptoTracker
CryptoTracker v1.0

## Install

To Install:
```
git clone https://github.com/glenfish/CryptoTracker.git
```

Requires gems (they will autoinstall with a confirmation prompt)
```
httparty  
json  
terminal-table  
colorize
activesupport
tty-prompt

```

## Run

In the 'src' directory, run:  
 ```
 bash crypto.sh
 ```
Note: Log in using the default admin account and create either admin or regular users  
```
username: admin  
password: fusion22
```

 Optionally to open directly into a user account, run:  
```
crypto.sh -u username -p password
```
log in as default admin user:
```
bash crypto.sh -u admin -p fusion22
```

## Add your API Key

You will need to create an account with CoinMarketCap.com and get an API key. Instructions for this are on the website at the link below. You MUST do this step. The app won't run without a functioning API key:
```
https://pro.coinmarketcap.com/signup
```
Once you have your key, replace the one in the file below and save.

`CryptoTracker/src/api/api_key.txt`

## Statement Of Purpose

A terminal application for creating and managing a portfolio of cryptocurrency or digital assets using live market rate API data. It was designed to be simple, fast, easy to use and light weight. Requires Ruby. Runs on Windows, Mac and Linux systems.

Built with Ruby 2.7.2


## Scope

MVP release of CryptoTracker 

- command line application
- text driven menu
- get live API data (requires API KEY and account with CoinMarketCap.com)
- cache and save price data locally
- read and write local JSON files for long term storage
- admin and user roles
- create regular and admin users (Admin role only)
- activate and deactivate users
- encrypted password storage
- login authentication
- add assets to portfolio
- modify and delete assets in portfolio
- display current portfolio
- Classes for Users and Portfolios
- help file
- bash script to run ruby app
- script flags for auto-login and help
- 8000+ cryptocurrencies and digital assets

## Planned features

- add and display 24hr % change, market cap, asset_buy_date, asset_sell_date, usd_profit, btc_profit
- edit all aspects of portfolio
- display summary profit and loss statement over time
- save portfolio view or P&L to PDF or print
- run as a standalone executable

## CryptoTracker App Features

### Add Cryptocurrency To Portfolio

The user can add a symbol name that represents the cryptocurrency on trading exchanges, and the quantity purchased. The app will display a list of all entries, showing name, symbol, quantity, current USD price of the asset, and the current USD value of the user's assets, with a grand total showing the combined portfolio value.

### API v Local Calls

To minimise API calls, every call is cached locally in a JSON file. If the portfolio is changed in any way the API is called, otherwise the local cache data is used. Local cache is reset every time a user logs in, resulting in a refresh of pricing.

### User Management

An administrator account has user creation privilliges and can activate or deactivate any user. Admin can also view the full list of users, usernames, passwords, status, account type and date the user was created. All users are stored together locally in 'users' JSON file.

## Local Portfolio Files

Each user has their own porfolio JSON file based on their username. The file contains key value pairs for the cryptocurrency symbols (for example 'BTC' for Bitcoin, or 'ETH' for Ethereum) and quantity of assets being tracked in the portfolio for each given user.

## CryptoTracker Screenshots

<img src="./docs/app_screenshots/v1_1/logged_out.png"
     alt="User not logged in"
     style="float: left; margin-bottom: 20px;" width="800px" />
<div style="clear: both;"></div>
<img src="./docs/app_screenshots/v1_1/logged_in_user.png"
     alt="User logged in"
     style="float: left; margin-bottom: 20px;" width="800px" />
<div style="clear: both;"></div>
<img src="./docs/app_screenshots/v1_1/logged_in_admin.png"
     alt="Admin logged in"
     style="float: left; margin-bottom: 20px;" width="800px" />
<div style="clear: both;"></div>
<img src="./docs/app_screenshots/v1_1/show_portfolio.png"
     alt="User Portfolio view"
     style="float: left; margin-bottom: 20px;" width="800px" />
<div style="clear: both;"></div>
<img src="./docs/app_screenshots/v1_1/show_users.png"
     alt="Admin show users"
     style="float: left; margin-bottom: 20px;" width="800px" />
<div style="clear: both;"></div>
<img src="./docs/app_screenshots/v1_0/create-new-user.png"
     alt="Admin create new user"
     style="float: left; margin-bottom: 20px;" width="360px" />
<div style="clear: both;"></div>

# Help

The user can access the following in the help file, listed below:
- Run Instructions
- Using Arguments with the script
- What To Do First
- User options
- Admin options
- Troubleshooting / FAQ

The help file explains in detail how to use the software.

[> View CryptoTracker Help Here](./docs/help_content.txt)

Copyright Nicholas Fehberg 2020. All Rights Reserved. 
Available free for personal use. No redistribution.










