require './app/models/dynamo_record'
require './app/models/build_info'

class Build < DynamoRecord
  include BuildInfo

  def commit_link
    "#{git_repo_url}/commit/#{commit_hash}"
  end

  def short_hash
    commit_hash[0..7]
  end
end
