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
		if !content.nil?
			puts content
			region_info, vigilance = content.split(/\)/)
			department_name, department = content.split(/ /)
			if (department =~ /\d{2}/ || department =~ /\d{1}[a-zA-Z]{1}/)
				department.gsub!(/[\(\)r]/, '')
				department_name.gsub!(/:/,'')
				puts area.inspect
				puts "#{department} #{department_name}"
				region_name = regions_hash[departements_hash[department]["region_id"]]["name"]
				vigilance_hash[department_name] = {:region_name => region_name, :vigilance => vigilance}
			end
		end
	end
	vigilance_hash
end
