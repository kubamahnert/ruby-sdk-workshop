def pi_client
  GoodData.connect 'bear@gooddata.com', 'tajneheslo', verify_ssl: false, server: 'https://pgd-ruby-sdk-workshop.na.intgdc.com'
end

def release_brick(opts = {})
  config_path = opts[:config_path]
  result = GoodData::Bricks::Pipeline.release_brick_pipeline.call JSON.parse(File.read(config_path))
  master_ids = result[:results]['CreateSegmentMasters'].map { |r| r[:master_pid] }
  fetch_projects(master_ids)
end

def fetch_projects(pids)
  client = pi_client
  pids.map { |id| client.projects(id) }
end

def create_fixtures(opts = {})
  data_product = opts[:data_product]
  segments = ['workshop_segment_1', 'workshop_segment_2']
  client = pi_client

  domain = client.domain('default')
  data_product = domain.create_data_product id: data_product
  segments.each do |s|
    master_project = client.create_project(title: 'inconspicuous project', auth_token: 'pgroup2')
    data_product.create_segment(segment_id: s, master_project: master_project)
  end
end