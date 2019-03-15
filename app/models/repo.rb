require './app/models/project'

class Repo < DynamoRecord
  def self.all
    dynamo_client.query(
      expression_attribute_values: { ':source_id' => 'project_summary' },
      key_condition_expression: 'source_id = :source_id',
      table_name: dynamo_table
    ).items.map do |item|
      new(item)
    end.sort_by(&:timestamp).reverse
  end

  def self.find(id)
    item = dynamo_client.get_item(
      key: { source_id: 'project_summary', version_key: id },
      table_name: dynamo_table
    ).item
    item && new(item)
  end

  def id
    version_key
  end

  def name
    uri = URI.parse(git_repo_url)
    uri.path[1..-1]
  end

  def build_projects
    @build_projects ||= projects.map do |code, project|
      Project.new(project.to_h.merge(code: code))
    end
  end

  def project(code)
    build_projects.detect { |project| project.code == code }
  end
end
