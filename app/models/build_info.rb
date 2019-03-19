module BuildInfo
  def build_url
    'https://console.aws.amazon.com/codesuite/codebuild/projects/' \
      "#{code}/build/#{build_id}/log?region=#{region}"
  end

  def icon
    if status == 'SUCCEEDED'
      'glyphicon-ok-circle'
    else
      'glyphicon-remove-circle'
    end
  end

  def text_status_classes
    if status == 'SUCCEEDED'
      'build-status  build-success'
    else
      'build-status  build-failure'
    end
  end

  def start_time
    (self[:start_time] || timestamp).to_i
  end
end
