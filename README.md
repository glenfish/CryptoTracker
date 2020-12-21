# CryptoTracker
CryptoTracker v 1.2  beta  

## Installation

To Install:
```
git clone https://github.com/glenfish/CryptoTracker.git
```

In the 'src' directory, run:  
 ```
 bash crypto.sh
 ```

 Optionally to open directly into a user account, run:  
```
crypto.sh -u "username" -p "password"
```

CryptoTracker uses bundler and the following gems are packaged:  

```
httparty  
json  
terminal-table  
colorize version  
activesupport
```

## Github Repository

[> CryptoTracker App on Github](https://github.com/glenfish/CryptoTracker)



## Statement Of Purpose

CryptoTracker aims to provide investors in cryptocurrency and other digital assets a tool with which to record buys and sells, output profit and loss statements and offer live pricing functionality for the portfolio.

There are online services that offer similar functionality, however most people are not comfortable entering their investments into an unknown website or cloud based service. They prefer anonymity. Many users rely on manually updated Excel spreadsheets.

This app aims to offer a better crypto tracking solution that is local and private, with real time pricing data and other metrics. It was designed to be simple, fast, easy to use and light weight. It requires Ruby and runs on Windows, Mac and Linux systems.

Built with Ruby 2.7.2


## Scope

A terminal application for creating and managing a portfolio of cryptocurrency or digital assets using live market rate API data.

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
- log out
- 8000+ cryptocurrencies and digital assets

## Additonal planned features post MVP

- add and display 24hr % change, market cap, asset_buy_date, asset_sell_date, usd_profit, btc_profit
- edit all aspects of portfolio
- display summary profit and loss statement
- save portfolio view or P&L to PDF or print
- design and build out a GUI front end
- run as a standalone executable app

## CryptoTracker App Features

### Add Cryptocurrency To Portfolio

The user can add a symbol name that represents the cryptocurrency on trading exchanges, and the quantity purchased. The app will display a list of all entries, showing name, symbol, quantity, current USD price of the asset, and the current USD value of the user's assets, with a grand total showing the combined portfolio value.

This is done by merging hashes and writing to the username.json portfolio file.

### API v Local Calls

To minimise API calls, every call is cached locally in a JSON file. If the portfolio is changed in any way the API is called, otherwise the local cache data is used. Local cache is reset every time a user logs in, resulting in a refresh of pricing. The state management is controlled using an object attribute on the user.

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

[> View CryptoTracker Help Here](https://github.com/glenfish/CryptoTracker/docs/help_content.txt)










