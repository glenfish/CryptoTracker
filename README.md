# Crypto Portfolio Tracker

## Application Overview

A terminal application built using Ruby 2.7.2 for creating and managing a portfolio of cryptocurrency or digital assets.

CORE features:

- command line application
- text driven menu
- connect/input live API digital asset data (requires API entry by user for security)
- connect/input static local JSON data for testing
- create user
- login user
- set to live data or test file data
- add to portfolio (buy digital assets)
  - username
  - asset_name
  - asset_symbol
  - asset_quantity
  - asset_buy_date
  - usd_price
  - btc_price
- delete portfolio (delete purchases or delete entire portfolio)
- show current portfolio
- Classes for Users and Portfolios
- JSON file read/write methods for Users and Portfolios
- log out

Additonal planned features post MVP:

- edit portfolio (modify existing portfolio data, sell digital assets)
- display 24hr % change, market cap, asset_buy_date, asset_sell_date, usd_profit, btc_profit
- display summary profit and loss statement
- save portfolio view or P&L to PDF or print
- user password creation and authentication on user accounts

## Testing

rspec
Testing data and screenshots here

## API Data

The API is using CoinMarketCap.com. 

To test, the JSON output for the first 100 cryptos on Coin Market Cap will be saved to a text file and accessed locally. 

Account with CoinMarketCap using the following credentials:  
key: ********-****-****-****-************  (create a free account below and use your own key)
url: https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC  
account url: https://pro.coinmarketcap.com/account  
data limits: 333 per day. 10k per month

The following symbols will be used for this test file:  
`BTC,ETH,XRP,USDT,BCH,LTC,LINK,ADA,DOT,BNB,XLM,USDC,BSV,EOS,XMR,WBTC,TRX,XEM,XTZ,LEO,FIL,CRO,NEO,DAI,VET,REV,ATOM,AAVE,DASH,WAVES,HT,MIOTA,UNI,ZEC,ETC,YFI,THETA,BUSD,COMP,CEL,MKR,SNX,OMG,DOGE,UMA,KSM,FTT,ONT,ZIL,ALGO,SUSHI,OKB,BTT,BAT,TUSD,RENBTC,DCR,NEXO,ZRX,DGB,PAX,HUSD,AVAX,REN,QTUM,HBAR,AMPL,ICX,ABBC,CELO,LRC,EGLD,HEDG,STX,LUNA,KNC,RSR,REP,EWT,LSK,OCEAN,BTG,SC,QNT,RUNE,CVT,NANO,BAND,MANA,ZB,NMR,ENJ,ANT,MAID,SNT,CHSB,XVG,NXM,RVN`

## Github Repo

[Crypto Portfolio Tracker App on Github](https://github.com/glenfish/Crypto-Portfolio-Tracker)

## Trello Board link (public)

[Crypto Portfolio Tracker App Trello Board](https://trello.com/b/9gKJL3WM/crypto-portfolio-manager-terminal-app)

## Data Persistence

The user data should be instantiated as an object via a user class. User account data must be written to a local JSON file. When the user logs in successfully, the user object is created for use within the current session. This stores state information on the user and provides methods for calling the read and write methods json files.

## Error Handling

- If no user object, handle error of null object with custom message

## Installation

info on installing
also packaged gems being used, versioning etc

## Dependencies

Ruby Gems:
httparty
json
terminal-table

## Usage

Documentation for using the program

