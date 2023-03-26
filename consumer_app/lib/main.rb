# frozen_string_literal: true

require 'aws-sdk-sqs'
require 'aws-sdk-dynamodb'
require 'macaw_framework'
require 'logger'
require_relative 'listener/listener_sqs'
require_relative 'usecase/recover_user_list'

ENV['TESTING'] = nil
logger = Logger.new($stdout)
macaw = MacawFramework::Macaw.new
sqs = Aws::SQS::Client.new(region: 'sa-east-1', endpoint: 'http://172.18.0.2:4566')
dynamo = Aws::DynamoDB::Client.new(region: "sa-east-1", endpoint: "http://172.18.0.2:4566")
list = RecoverUserList.new(dynamo, logger)

Thread.new do
  ListenerSqs.new(sqs, dynamo).listen_queue
end

macaw.get('list') do |headers, body, parameters|
  list.recover_list_of_users.to_s
end

macaw.start!
