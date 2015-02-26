require 'spec_helper'
require 'rake'

describe LocationsController do
  let(:locations){Location.all}
  let(:current_location) {Location.find_by_location_code("avery")}
  before :all do
    Location.clear_and_load_fixtures!
    Rake.application.rake_require 'tasks/solr_ingest'
    Rake.application.rake_require 'tasks/sync_hours'
    Rake::Task.define_task(:environment)
    Rake.application.invoke_task 'hours:sync'
  end
  describe "build_markers" do
    it "should query the Library API" do
      controller.instance_variable_set(:@locations, Location.all)
      controller.instance_variable_set(:@location, Location.find_by_location_code("avery"))
      api_query = "http://api.library.columbia.edu/query.json", {:params=>{:qt=>"location", :locationID=>"alllocations"}}
      expect(RestClient).to receive(:get).with(api_query[0], api_query[1]).and_call_original
      controller.build_markers
    end

    it "assigns current marker" do
      controller.instance_variable_set(:@locations, Location.all)
      controller.instance_variable_set(:@location, Location.find_by_location_code("avery"))
      controller.build_markers
      expect(assigns(:current_marker_index)).to eq(0)
    end

    it 'should not have a marker for chrdr' do
      controller.instance_variable_set(:@locations, Location.all)
      controller.instance_variable_set(:@location, Location.find_by_location_code("avery"))
      markers = controller.build_markers
      expect(markers).not_to match(/chrdr/)
    end

    it "has location codes for butler-24 and barnard-archives" do
      pending
    end

    it "should return json for each location with a location id" do
      controller.instance_variable_set(:@locations, Location.all)
      controller.instance_variable_set(:@location, Location.find_by_location_code("avery"))
      markers = controller.build_markers
      cliolocs = Location.all.select{|loc| loc['library_code']}.map{|loc| loc['library_code']}.uniq
      cliolocs.each do |loc|
        unless((loc == "barnard-archives") || (loc == "butler-24") || (loc == "lehman-suite"))
          expect(markers).to match(loc)
        end
      end
    end
  end
end
