=begin
	Author: Mufudzi Masaire
	The Job::Parser Service is responsible for normalising
	the input string (jobs) and returning an array of arrays. It also
	checks for self dependent jobs only eg. ["c" => "c"]
=end

require './lib/require'

module Job
	class Parser
		class << self

			def process(jobs)
				parsed_jobs = parse(jobs)
			end

			private

				def parse(jobs)
					# This method receives jobs in the form of a string
					jobs_split_by_line_breaks = jobs.split(/\n/).map!(&:strip)
					parsed_jobs = remove_rockets(jobs_split_by_line_breaks)
					parsed_jobs
				end

				def remove_rockets(jobs_array)
					# This utility method removes hash rockets & whitespace
					jobs_without_rockets = Array.new
					jobs_array.map do  |j|
						#turning array into string and removing whitespace
						temp = j.split(/\=>/).join.squeeze.strip
						jobs_without_rockets << temp
					end
					jobs = nested_arrays(jobs_without_rockets)
					jobs
				end

				def nested_arrays(jobs)
					# returns an array of array
					jobs_array = Array.new
					jobs.map do |element|
						if element.length.eql?(1)
							jobs_array << element.split
						else
							jobs_array << element.split(/ /)
						end
					end
					jobs_array
				end

		end
	end
end