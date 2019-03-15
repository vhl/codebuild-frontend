require 'active_support'
require 'active_support/core_ext' # for delegate

class DynamoRecord < Hashie::Mash
  delegate :dynamo_client, :dynamo_table, :region, to: :settings

  def self.settings
    Sinatra::Application
  end

  def settings
    self.class.settings
  end

  def self.dynamo_client
    settings.dynamo_client
  end

  def self.dynamo_table
    settings.dynamo_table
  end

  def self.region
    settings.region
  end
end
