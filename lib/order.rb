=begin
	Author: Mufudzi Masaire
	The Job::Order Service is responsible for ordering the
	parsed jobs array and returning an array of ordered jobs
=end

require './lib/require'

module Job
	class Order
		class << self

			def process(parsed_jobs)
				parsed_jobs = Job::DependencyValidator.self_dependent?(parsed_jobs)
				ordered_job_deps = order_dependencies(parsed_jobs)
				ordered_jobs = order_jobs(ordered_job_deps)
			end

			private

				def order_jobs(ordered_job_deps)
					ordered_jobs = Array.new
					ordered_job_deps.map do |job|
						# Indentify similar jobs
						similar_job = ordered_jobs & job
						if ordered_jobs.empty? || similar_job.empty?
							ordered_jobs << job
						else
							Job::DependencyValidator.circular_dependency?(similar_job)
							position = ordered_jobs.index(similar_job.join).to_i
							ordered_jobs[position] = job
						end
						ordered_jobs.flatten!
					end
					ordered_jobs
				end

				def order_dependencies(parsed_jobs)
					# This method orders dependencies
					ordered_deps = Array.new
					temp = Array.new
					parsed_jobs.map do |element|
						if element.count > 1
							#reversing order
							ordered_deps << (temp[0], temp[1] = element[1], element[0])
						else
							ordered_deps << element
						end
					end
					ordered_deps
				end

		end
	end
end