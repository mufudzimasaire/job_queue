=begin
	Author: Mufudzi Masaire
	Dependency Validating Service - checks for circular dependencies
=end

require './lib/require'

module Job
	class DependencyValidator
		class << self

			def self_dependent?(parsed_jobs)
				self_dep?(parsed_jobs)
			end

			def circular_dependency?(similar_job)
				 circular?(similar_job)
			end

			private

				def self_dep?(parsed_jobs)
					# Abstracted code
					# This method receives an array of arrays and
					# checks if there are self dependent jobs eg. ["c" => "c"]
					screened_jobs_list = Array.new
					parsed_jobs.each do |job_array|
						unless job_array.count.eql?(1)
							Job::ExceptionHandler.call("self") if job_array[0] == job_array[1]
						end
						screened_jobs_list << job_array
					end
					return screened_jobs_list
				end

				def circular?(similar_job)
					#Abstracted code
					unless similar_job.count.eql?(1)
						# if similar_job is greater than 1,
						# this indicates circular dependency
						Job::ExceptionHandler.call("circular")
					end
				end

		end
	end
end