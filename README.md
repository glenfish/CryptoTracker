# CryptoTracker

CryptoTracker v 1.1  
Built with Ruby 2.7.2

## Application Overview

A terminal application for creating and managing a portfolio of cryptocurrency or digital assets using live market rate API data.

CORE features:

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

Additonal planned features post MVP:

- add and display 24hr % change, market cap, asset_buy_date, asset_sell_date, usd_profit, btc_profit
- edit all aspects of portfolio
- display summary profit and loss statement
- save portfolio view or P&L to PDF or print

## Testing

rspec  
< testing data and screenshots here >

## API

The API is using CoinMarketCap.com. 

In testing, the JSON output for the first 100 cryptos on Coin Market Cap was saved to a text file and accessed locally. In v1.1 release, a list of over 8000 cryptos is available to add to the portfolio with pricing data.

Account with CoinMarketCap using the following credentials:  

url: https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC  
account url: https://pro.coinmarketcap.com/account  
data limits: 333 per day. 10k per month

## Github Repository

[> CryptoTracker App on Github](https://github.com/glenfish/CryptoTracker)

## Trello Board - Project Management

[> CryptoTracker App Trello Board](https://trello.com/b/9gKJL3WM/crypto-portfolio-manager-terminal-app)

## Data Persistence

User and user's portfolio data is stored locally in JSON file format. A User class instantiates the current user at login and facilitates attribute passing for personalisation of the user experience as well as writing and reading to the correct portfolio file.

Upon user creation, a user is created as an object of the User class, and a portfolio is created as an object of the Portfolio class. The latter uses a method to build the user's portfolio file in JSON format, which is written locally for storage.

At this stage the Portfolio class is only used in this instance, however it will be incorporated more fully with the addition of more app features.

## Error Handling

- Errors have been handled with logic in many cases, however where code errors may occur, the flow is not complicated by an over-abundance of error output. Instead, retry and clears have been used to improve the user experience and make it more intuative.

## Installation

Ruby 2.7.2 was used to develop CryptoTracker  
The following gems are packaged:  
httparty  
json  
terminal-table  
colorize version
activesupport

## Usage

CryptoTracker is designed for people who buy and sell digital assets or 'cryptocurrency'. A user can create a portfolio of cryptos from the assets listed on CoinMarketCap.com and get real time price data to track the portfolio value.

The user can add a symbol name that represents the cryptocurrency on trading exchanges, and the quantity purchased. The app will display a list of all entries, showing name, symbol, quantity, current USD price of the asset, and the current USD value of the user's assets, with a grand total showing the combined portfolio value.

To minimise API calls, every call is cached locally in a JSON file. If the portfolio is changed in any way the API is called, otherwise the local cache data is used. Local cache is reset every time a user logs in, resulting in a refresh of pricing.

An administrator account has user creation privilliges and can activate or deactivate any user. Admin can also view the full list of users, usernames, passwords, status, account type and date the user was created.

All users are stored together locally in 'users' JSON file, and each puser has their own porfolio JSON file based on their username. The file contains data on the cryptocurrency symbols (for example 'BTC' for Bitcoin, or 'ETH' for Ethereum) and quantities of cryptos being tracked in the portfolio for each given user.

# Screenshots

<img src="./docs/app_screenshots/logged-out.png"
     alt="User not logged in"
     style="float: left; margin-bottom: 20px;" width="400px" />
<div style="clear: both;"></div>
<img src="./docs/app_screenshots/logged-in-user.png"
     alt="User logged in"
     style="float: left; margin-bottom: 20px;" width="400px" />
<div style="clear: both;"></div>
<img src="./docs/app_screenshots/portfolio-view.png"
     alt="User Portfolio view"
     style="float: left; margin-bottom: 20px;" width="800px" />
<div style="clear: both;"></div>
<img src="./docs/app_screenshots/logged-in-admin.png"
     alt="Admin logged in"
     style="float: left; margin-bottom: 20px;" width="300px" />
<div style="clear: both;"></div>
<img src="./docs/app_screenshots/users-view.png"
     alt="Admin show users"
     style="float: left; margin-bottom: 20px;" width="500px" />
<div style="clear: both;"></div>
<img src="./docs/app_screenshots/create-new-user.png"
     alt="Admin create new user"
     style="float: left; margin-bottom: 20px;" width="400px" />
<div style="clear: both;"></div>

# Help

The user can access the following in the help file, listed below:
- Run Instructions
- Using Arguments with the script
- What To Do First
- User options
- Admin options
- Troubleshooting / FAQ

[> CryptoTracker App Help](https://github.com/glenfish/CryptoTracker/docs/help_content.txt)







