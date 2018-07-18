module RubyWorkshop
  def self.add_report(project, opts = {})
    what = opts[:what]
    how = opts[:how]
    type = 'chart'
    title = opts[:title]

    metric = project.metric_by_title what
    label = project.labels how
    spec_part = type == 'chart' ? { chart_part: { value_uri: label.uri, type: 'bar'} } : { chart_part: { value_uri: label.uri, type: 'donut' } }
    params = { title: title, top: [metric], left: [how], format: type }.merge spec_part
    report = project.create_report params
    report.lock
    report
  end

  def self.top_left_position
    { :position_x => 10, :position_y => 20, size_y: 450, size_x: 400 }
  end

  def self.top_right_position
    { :position_x => 450, :position_y => 20, size_y: 450, size_x: 400 }
  end
end
