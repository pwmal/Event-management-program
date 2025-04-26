require 'bunny'
require 'json'
require 'net/http'

max_attempts = 10
attempt = 0
connection = nil

while attempt < max_attempts
  begin
    connection = Bunny.new("amqp://guest:guest@rabbitmq:5672")
    connection.start
    if connection.open?
      puts "Connected to RabbitMQ on attempt #{attempt + 1}"
      break
    end
  rescue Bunny::TCPConnectionFailed, Bunny::HostListDepleted => e
    attempt += 1
    puts "Attempt #{attempt} failed: #{e.message}. Retrying in 5 seconds..."
    sleep 10
  end
end

unless connection && connection.open?
  raise "Could not connect to RabbitMQ after #{max_attempts} attempts"
end

channel = connection.create_channel
queue = channel.queue('visit_logs', durable: true)

puts "Waiting for messages..."

queue.subscribe(block: true) do |_delivery_info, _props, body|
  begin
    data = JSON.parse(body)
    puts "Got message: #{data}"
    
    uri = URI("http://journal-service:3000/logs/record")
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = data.to_json

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    puts "Sent to journal, response: #{response.code}"
  rescue => e
    puts "Failed to send log: #{e.message}"
  end
end