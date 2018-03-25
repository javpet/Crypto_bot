require "http"
require "json"

# Change the ID in the URL to customize for another cryptocurrency
# DOGECOIN_API_URL = "https://api.coinmarketcap.com/v1/ticker/dogecoin/"

# # Dogecoin price threshold -- the price, where you still keep your sanitfy
# DOGECOIN_PRICE_THRESHOLD = 0.0035

puts "------------------------"
puts "Welcome to CryptoBot 🤖"
puts "------------------------"

def ask_currency
  puts "Which cryptocurrency are you insterested in?"
  @currency_interested = gets.chomp
end

def ask_threshold_price
  puts "What would be threshold(price) you would like to receive an emergency update message to buy / sell?"
  @threshold_price = gets.chomp.to_f

end

def get_latest_coin_price
  response = HTTP.get("https://api.coinmarketcap.com/v1/ticker/#{@currency_interested}/")
  response_json = JSON.parse(response)

  return response_json[0]["price_usd"].to_f
end

def post_ifttt_webhook(event, value)
  # Change the IFTTT URL to your own URL -- GET YOUR OWN KEY AT: https://maker.ifttt.com/
  ifttt_api_url = "https://maker.ifttt.com/trigger/#{event}/with/key/{{PLACE YOUR KEY HERE!!!}}"

  # The payload that will be sent to IFTTT service
  HTTP.post(ifttt_api_url, :json => { value1: value, value2: @currency_interested })
end

def format_coin_history(coin_history)
    rows = []

    coin_history.each do |coin_price|
        date = coin_price[:date].strftime('%d.%m.%Y %H:%M')  # Formats the date into a string: '22.03.2018 15:09'
        price = coin_price[:price]

        # <b> (bold) tag creates bolded text in the Telegram message
        row = "#{date}: $<b>#{price}</b>"
        rows.push(row)
    end

    # Using a <br> (break) tag to create a new line
    return rows.join('<br>')  # Join the rows delimited by <br> tag: row1<br>row2<br>row3
end

def main
    coin_history = []

    while true

        puts "Status: CryptoBot is running on the machine!"

        price = get_latest_coin_price
        time = Time.now
        coin_current_data = {date: time, price: price}
        coin_history << coin_current_data


        # Send an emergency notification
        if price < @threshold_price
            post_ifttt_webhook("coin_price_emergency", price)
        end

        # Send a Telegram notification
        # Once we have 5 items in our dogecoin_history send an update
        if coin_history.count == 5
            post_ifttt_webhook("coin_price_update", format_coin_history(coin_history))

            puts "Message sent with latest prices -- #{time}"
            # Reset the history
            coin_history = []
        end

        # Sleep for 5 minutes
        sleep(100)
    end
end

ask_currency()
ask_threshold_price()
main()
