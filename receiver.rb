# encoding: utf-8
require "bunny"
require_relative 'sender.rb'

CLIENT_NAME = ARGV.empty? ? 'guest_1' : ARGV.join(" ")

conn = Bunny.new
conn.start
ch = conn.create_channel

q = ch.queue(CLIENT_NAME)

Sender.new("server", CLIENT_NAME).send({order: {id: 3434546, articles: [{id: 23, name: 'Cola'}, {id: 55, name: 'RedBull'}]}}.to_json, 'customer_1')

puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"
q.subscribe(:block => true) do |delivery_info, properties, body|
  puts " [x] Received #{body.inspect} from #{properties.app_id}"

  # cancel the consumer to exit
  #delivery_info.consumer.cancel
end