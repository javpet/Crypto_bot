# Crypto_bot
Crypto_bot 🤖 sending emergency updates if the selected currency is below a certain threshold, or just regular reports every 5 minutes. 💰 

## Background

I can easily fall into the situation where I staring at the screens waiting for currency updates real-time, so instead of wasting time on that, I've created a little bot with the help of Ruby, Telegram and IFTTT.
For this one I've used

![](https://cdn.vox-cdn.com/thumbor/lddh05MIQrPTx2QL93RLRGZHfEM=/21x0:539x345/920x613/filters:focal(21x0:539x345):format(webp)/cdn.vox-cdn.com/assets/3727699/Dogecoin_logo.png)

## How to use (after cloned this repo, of course! 😊)

1. First you will need to register on [IFTTT](https://ifttt.com/discover), and create a webhook with a custom event name and message. It's important to have {{value1}} inserted in the message so you can actually see the values returned from the API.
2. Check the IFTTT documentation to get your IFTTT key, so you can use it in the webhook, I highlighted where to insert in the request link
3. Install the IFTTT app on your phone, this is where the emergency updates are coming (Free service)
4. Install [Telegram](https://telegram.org/) (so you have a number), after you have a registration on IFTTT, you neeed to approve the connection between IFTTT and Telegram to communicate with each other.
5. Run the ruby app on your local machine or on a server and receive updates 💰

ALTERNATIVE OPTIONS
-------------------
- Changing the threshold of the price you want to receive emergency updates
- Changing the frequency of the regular price updates on Telegram

The list of available currencies from coinmarketcap: https://coinmarketcap.com/all/views/all/
Example of JSON coming from the coinmarket API: https://api.coinmarketcap.com/v1/ticker/bitcoin/
