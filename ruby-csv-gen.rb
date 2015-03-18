#!/usr/bin/env ruby
require 'csv'

class ProcCSV

	def initialize

		# set default values
		@cities_list = 'US-States-Cities.csv'
		@default_content = 'defaultcontent.csv'
		@replace_results = []
		# default values
		@default_post_type = 'page'
		@default_parent = 0
		@default_author = 1
		@default_post_status = 'publish'
		@default_page_template = 'default'
		@default_menu_order = 0

		# store date and time
		time = Time.new
		@date_string = "#{time.month}/#{time.day}/#{time.year} #{time.hour}:#{time.min}"

		# set CSV headers
		@csv_headers = ['post_type','post_title','post_slug','_aioseop_title','_aioseop_description','_aioseop_keywords','post_content','post_parent','post_author','post_date','post_status','wp_page_template','menu_order']
		@replace_results.push(@csv_headers)

		# set default lists
		gather_cites
		gather_def_content

		# process list
		generate_content

		# save results
		save_results

	end

	def gather_cites
		@cities_list = CSV.open(@cities_list, :encoding => 'windows-1251:utf-8').to_a
	end

	def gather_def_content
		@default_content = CSV.open(@default_content, :encoding => 'windows-1251:utf-8').to_a
	end

	def generate_content

		# loop through available cities
		@cities_list.each { |city|
			# reset current arrow row
			@replace_row = []

			# add default post type
			@replace_row.push(@default_post_type)

			# check for empty city
				if !city.nil? 
				#loop though default content
				@default_content.each { |content|
					# walk through csv columns
					content.each_with_index { |item, index|
						# make sure not empty
						if !item.nil? 
							# add results to replace row
							if index == 1
								content = item.gsub( /(Illinois)/i, city[1].to_s.strip).gsub( /(Chicago)/i, city[0].to_s.strip).downcase
							else
								content = item.gsub( /(Illinois)/i, city[1].to_s.strip).gsub( /(Chicago)/i, city[0].to_s.strip)
							end
							
							@replace_row.push(content)
							#@replace_row.push(item.gsub( /(Illinois)/i, city[1].to_s))
							puts index;
							puts city[1].to_s;
						end
					}
				}
			end

			# add default parent post
			@replace_row.push(@default_parent)

			# add default author
			@replace_row.push(@default_author)

			# assign post date
			@replace_row.push(@date_string)

			# assign post status
			@replace_row.push(@default_post_status)

			# assign post template
			@replace_row.push(@default_page_template)

			# assign default menu order
			@replace_row.push(@default_menu_order)

			# save results
			@replace_results.push(@replace_row)
		}
	end

	def save_results
		CSV.open("results.csv", "wb") {|csv| 
			@replace_results.each {|key| 
				csv << key
			}
		}
	end

end

convert_list = ProcCSV.new