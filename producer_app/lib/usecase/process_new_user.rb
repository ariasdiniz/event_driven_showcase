# frozen_string_literal: true
require 'json'
require 'logger'

class ProcessNewUser

  def initialize(sqs, logger = Logger.new($stdout))
    @logger = logger
    @sqs = sqs
  end

  def process(message)
    validate_body(message)
    send_message(message)
    ['{ "message": "User sent to processing app" }', 200]
  rescue StandardError => e
    ["{ \"message\": \"#{e.message}\" }", 500]
  end

  private
  def send_message(message, queue_url = 'http://172.18.0.2:4566/000000000000/test-queue')
    @logger.info("Sending message #{message} to queue test-queue")
    @sqs.send_message(
      queue_url: queue_url,
      message_body: message
    )
    @logger.info('Message sent with success')
  end

  def validate_body(body)
    raise 'Body should be in JSON format and cannot be empty' if body.nil?

    @logger.info('Converting body to hash')
    body = JSON.parse(body)
    raise 'You should inform the primary_id!' if body['primary_id'].nil?
    raise 'You should inform the secondary_id!' if body['secondary_id'].nil?
  end
end
