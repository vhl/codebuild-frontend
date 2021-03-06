require 'digest'

class Source < DynamoRecord
  include BuildInfo

  def self.find(code:, id:)
    item = dynamo_client.get_item(
      key: { source_id: code, version_key: id },
      table_name: dynamo_table
    ).item
    item && new(item)
  end

  def builds
    dynamo_client.query(
      expression_attribute_values: { ':source_id' => build_key },
      key_condition_expression: 'source_id = :source_id',
      table_name: dynamo_table
    ).items.map do |item|
      Build.new(item)
    end.sort_by(&:version_key).reverse
  end

  def source_title
    "#{source_ref}#{" (branch #{branch_name})" if pr?}"
  end

  def code
    source_id
  end

  def git_url
    "#{git_repo_url}/#{url_path}"
  end

  private def url_path
    if pr?
      "pull/#{source_ref[3..-1]}"
    else
      "tree/#{branch_name}"
    end
  end

  private def pr?
    %r{\Apr/}.match?(source_ref)
  end

  def build_key
    "#{code}:#{source_ref}"
  end

  def project_url
    "/repos/#{repo_id}/projects/#{code}"
  end

  private def repo_id
    Digest::MD5.hexdigest(git_repo_url)
  end
end
