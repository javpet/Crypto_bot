require "http"
require "json"

# Change the ID in the URL to customize for another cryptocurrency
DOGECOIN_API_URL = "https://api.coinmarketcap.com/v1/ticker/dogecoin/"

# Dogecoin price threshold -- the price, where you still keep your sanitfy
DOGECOIN_PRICE_THRESHOLD = 0.0038


def get_latest_dogecoin_price
  response = HTTP.get(DOGECOIN_API_URL)
  response_json = JSON.parse(response)

  response =  response_json[0]["price_usd"].to_f
end

def post_ifttt_webhook(event, value)
  # Change the IFTTT URL to your own URL -- GET YOUR OWN KEY AT: https://maker.ifttt.com/
  ifttt_api_url = "https://maker.ifttt.com/trigger/#{event}/with/key/PLACE_KEY_HERE"

  # The payload that will be sent to IFTTT service
  HTTP.post(ifttt_api_url, :json => { value1: value })
end

def format_dogecoin_history(dogecoin_history)
    rows = []

    dogecoin_history.each do |dogecoin_price|
        date = dogecoin_price[:date].strftime('%d.%m.%Y %H:%M')  # Formats the date into a string: '22.03.2018 15:09'
        price = dogecoin_price[:price]

        # <b> (bold) tag creates bolded text in the Telegram message
        row = "#{date}: $<b>#{price}</b>"
        rows.push(row)
    end

    # Using a <br> (break) tag to create a new line
    return rows.join('<br>')  # Join the rows delimited by <br> tag: row1<br>row2<br>row3
end

def main
    dogecoin_history = []

    while true
        price = get_latest_dogecoin_price
        time = Time.now
        dogecoin_current_data = {date: time, price: price}
        dogecoin_history << dogecoin_current_data

        # Send an emergency notification
        if price < DOGECOIN_PRICE_THRESHOLD
            post_ifttt_webhook("dogecoin_price_emergency", price)
        end

        # Send a Telegram notification
        # Once we have 5 items in our dogecoin_history send an update
        if dogecoin_history.count == 5
            post_ifttt_webhook("dogecoin_price_update", format_dogecoin_history(dogecoin_history))

            # Reset the history
            dogecoin_history = []
        end

        # Sleep for 5 minutes
        sleep(300)
    end
end

main()
