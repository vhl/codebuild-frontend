require './app/models/dynamo_record'
require './app/models/build_info'

class Project < DynamoRecord
  include BuildInfo

  def sources
    dynamo_client.query(
      expression_attribute_values: { ':source_id' => code },
      key_condition_expression: 'source_id = :source_id',
      table_name: dynamo_table
    ).items.map do |item|
      Source.new(item)
    end.sort_by(&:timestamp).reverse
  end
end
