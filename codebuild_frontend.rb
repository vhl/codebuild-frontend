require 'sinatra'
require 'sinatra/content_for'
require 'aws-sdk-dynamodb'
require 'hashie'

if development?
  require 'better_errors'
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

set :root, File.dirname(__FILE__)
set :views, File.expand_path('./app/views/')
set :erb, layout_options: { views: 'app/layouts' }

set :dynamo_table, ENV['CODEBUILD_HISTORY_DYNAMO_TABLE'] || 'codebuild-history'
set :region, ENV['CODEBUILD_HISTORY_AWS_REGION'] || 'us-east-1'
set :dynamo_client, Aws::DynamoDB::Client.new(region: settings.region)

Dir.glob('./app/models/*.rb') { |model_file| require model_file }

get '/' do
  @repos = Repo.all
  @header = 'CodeBuild Project Repositories'
  erb :index
end

get '/repos/:repo_id/projects/:code' do
  @project = Repo.find(params[:repo_id]).project(params[:code])
  @header = "Branches for project #{@project.code}"
  erb :project
end

get '/projects/:code/sources/:id' do
  @source = Source.find(params.to_h.symbolize_keys)
  @header = "Builds for #{@source.source_title}"
  erb :source
end
