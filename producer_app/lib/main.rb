# frozen_string_literal: true

require 'aws-sdk-sqs'
require 'macaw_framework'
require_relative 'usecase/process_new_user'

macaw = MacawFramework::Macaw.new
sqs = Aws::SQS::Client.new(region: 'sa-east-1', endpoint: 'http://172.18.0.3:4566')
new_user = ProcessNewUser.new(sqs)

macaw.post('create_new_user') do |context|
  new_user.process(context[:body])
end

macaw.start!
