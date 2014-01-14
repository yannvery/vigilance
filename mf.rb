require 'sinatra'
require 'json'
require 'nokogiri'

get '/' do
  vigilance.to_json
end

def vigilance
	doc = Nokogiri::XML(open(File.join "departements.xml"))
	departements = doc.root.xpath("departement")
	departements_hash = Hash.new
	departements.each do |p|
		departements_hash[p.at_xpath("code").text] = { "name" => p.at_xpath("name_departement").text, "region_id" => p.at_xpath("id_region").text}
	end

	doc = Nokogiri::XML(open(File.join "regions.xml"))
	regions = doc.root.xpath("region")
	regions_hash = Hash.new
	regions.each do |p|
		regions_hash[p.at_xpath("id_region").text] = { "name" => p.at_xpath("name_region").text }
	end


	page = `phantomjs mf.js`
	doc = Nokogiri::HTML(page)
	areas = doc.css("area")
	vigilance_hash = {}
	areas.each do |area|
		content = area["title"]
		region_info, vigilance = content.split(/:/)
		department, department_name = content.split(/ /)
		if (department =~ /\d{2}/)
			department_name.gsub!(/:/,'')
			region_name = regions_hash[departements_hash[department]["region_id"]]["name"]
			#vigilance_array.push({:region => region_name, :department => department_name, :vigilance => vigilance }) if department =~ /\d{2}/
			vigilance_hash[department_name] = {:region_name => region_name, :vigilance => vigilance}
		end
	end
	vigilance_hash
end
