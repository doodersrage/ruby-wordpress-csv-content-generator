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
		@default_author = 'David Jones'
		@default_post_status = 'publish'
		@default_page_template = 'default'
		@default_menu_order = 0
		@post_file_cnt = 0
		@per_doc_limit = 200
		@wp_ping_status = 'open'
		@wp_comment_status = 'open'
		@cf__wp_page_template = 'template-services.php'

		# store date and time
		time = Time.new
		@date_string = "#{time.month}/#{time.day}/#{time.year} #{time.hour}:#{time.min}"

		# set CSV headers
		@csv_headers = ['wp_ID','wp_post_type','wp_post_title','wp_post_name','cf__aioseop_title','cf__aioseop_description','cf__aioseop_keywords','wp_post_content','wp_post_parent','wp_post_author','wp_post_date','wp_post_status','wp_page_template','wp_menu_order','wp_ping_status','wp_comment_status','cf__wp_page_template']
		@replace_results.push(@csv_headers)

		# set default lists
		gather_cites
		gather_def_content

		# process list
		generate_content

	end

	def gather_cites
		@cities_list = CSV.open(@cities_list, :encoding => 'windows-1251:utf-8').to_a
	end

	def gather_def_content
		@default_content = CSV.open(@default_content, :encoding => 'windows-1251:utf-8').to_a
	end

	def generate_content

		curCnt = 0

		# loop through available cities
		@cities_list.each { |city|
			# reset current arrow row
			@replace_row = []

			# add default blank id for new page
			@replace_row.push('')

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

			# assign default ping status
			@replace_row.push(@wp_ping_status)

			# assign default comment status
			@replace_row.push(@wp_comment_status)

			# assign default page template
			@replace_row.push(@cf__wp_page_template)

			# save results
			@replace_results.push(@replace_row)
		# write results at 1000 line count
			if curCnt > @per_doc_limit
				curCnt = 0
				save_results
				@replace_results = []
				# set CSV headers
				@csv_headers = ['wp_ID','wp_post_type','wp_post_title','wp_post_name','cf__aioseop_title','cf__aioseop_description','cf__aioseop_keywords','wp_post_content','wp_post_parent','wp_post_author','wp_post_date','wp_post_status','wp_page_template','wp_menu_order','wp_ping_status','wp_comment_status','cf__wp_page_template']
				@replace_results.push(@csv_headers)
			else 
				curCnt += 1
			end
		}

		# save results remainder
		save_results
	end

	def save_results

		@post_file_cnt += 1

		CSV.open("results#{@post_file_cnt}.csv", "wb") {|csv| 
			@replace_results.each {|key| 
				csv << key
			}
		}
	end

end

convert_list = ProcCSV.new