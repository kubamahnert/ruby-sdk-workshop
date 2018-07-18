
# edit .gooddata file and `cp .gooddata ~/`
require 'gooddata'
client = GoodData.connect
# test the connection
client.projects

# have fun with faker
# https://github.com/stympy/faker
require 'faker'
project_name = Faker::Company.name

blueprint = GoodData::Model::ProjectBlueprint.build(project_name) do |p|
  p.add_date_dimension('committed_on')
  p.add_dataset('devs') do |d|
    d.add_anchor('attr.dev')
    d.add_label('label.dev_id', :reference => 'attr.dev')
    d.add_label('label.dev_email', :reference => 'attr.dev')
  end
  p.add_dataset('commits') do |d|
    d.add_anchor('attr.commits_id')
    d.add_fact('fact.lines_changed')
    d.add_fact('fact.coffee_cups')
    d.add_date('committed_on')
    d.add_reference('devs')
  end
end

# "forget" name of method #create_blueprint_method here
# time to demo introspection
GoodData::Project.methods
GoodData::Project.methods.grep /blueprint/

# create project
project = GoodData::Project.create_from_blueprint(blueprint, auth_token: 'secret', client: client)

client.projects.map(&:title)
# check it out: https://ruby-workshop.na.intgdc.com/

# copy from http://sdk.gooddata.com/gooddata-ruby-examples/#_renaming_project
project.title = Faker::Company.name
project.save

# load data (copy from data slide)
commits_data = [
  ['fact.lines_changed', 'fact.coffee_cups' ,'committed_on', 'devs'],
  [1, 3, '01/01/2014', 1],
  [3, 2, '01/02/2014', 2],
  [5, 1, '05/02/2014', 3]
]
project.upload(commits_data, blueprint, 'commits')

devs_data = [
  ['label.dev_id', 'label.dev_email'],
  [1, 'tomas@gooddata.com'],
  [2, 'petr@gooddata.com'],
  [3, 'jirka@gooddata.com']
]
project.upload(devs_data, blueprint, 'devs')

# explain how each works and create metrics
['fact.lines_changed', 'fact.coffee_cups'].each do |f|
  metric = project.facts(f).create_metric title: f
  metric.save
end

# check out the metrics
project.metrics.map(&:title)

# create dashboard
dashboard_name = Faker::Company.industry
dashboard = project.create_dashboard(:title => dashboard_name, client: client)
tab_name = Faker::Company.buzzword
tab = dashboard.create_tab(:title => tab_name)
dashboard.save

# load helpers
require_relative 'code/helpers'
# add report
report_data = {
  what: 'fact.lines_changed',
  how: 'label.dev_email',
  title: 'Who worked the hardest?'
}
dashboard = project.dashboards.first # try #reload!
tab = dashboard.tabs.first # try #reload!
report = RubyWorkshop.add_report(project, report_data)
report.save
# check it out
project.reports.map(&:title)
report_item = { report: report }.merge RubyWorkshop.top_left_position
tab.add_report_item(report_item)
dashboard.save

# reopening classes
class GoodData::Dashboard
  def save
    puts "Do you really want to delete #{title}?"
    input = gets.chomp
    super if input == 'yes'
  end
end
dashboard.save
