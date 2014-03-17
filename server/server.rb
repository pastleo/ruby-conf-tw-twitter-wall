require 'bundler/setup'
require 'em-websocket'
require 'em-twitter'
require 'json'
require 'settingslogic'
require 'settings'

EM.run {
  @channel = EM::Channel.new
  # ref: https://dev.twitter.com/docs/streaming-apis/parameters#track
  client = EM::Twitter::Client.connect(Settings.twitter)
  client.each do |tweet|
    # ref: https://dev.twitter.com/docs/platform-objects/tweets
    @channel.push(%Q({"op": "tweet", "data": #{tweet}}))
  end
  EM::WebSocket.start(host: "0.0.0.0", port: 8080, debug: true) do |ws|
    ws.onopen {
      sid = @channel.subscribe { |msg| ws.send msg }
      puts "##{sid} connected."
      ws.send({op: :msg, data: 'Welcome!'}.to_json)

      ws.onmessage { |msg|
        @channel.push "<##{sid}>: #{msg}"
      }

      ws.onclose {
        @channel.unsubscribe(sid)
        puts "##{sid} closed."
      }
    }
  end

  puts "Server started"
}