# frozen_string_literal: true

require 'aws-sdk-sqs'
require 'aws-sdk-dynamodb'
require 'macaw_framework'

macaw = MacawFramework::Macaw.new

macaw.get('list') do |headers, body, parameters|

end

macaw.start!
