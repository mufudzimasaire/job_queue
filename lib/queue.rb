=begin
	Author: Mufudzi Masaire
	The Job::Queue class presents the main
	access point for the Job module
=end

require './lib/require'

module Job
	class Queue

		attr_accessor :name

		def initialize(name)
			@name = name
		end

		def process(jobs)
			# returns a collection of jobs or
			# a job as a string if its a single job
			Job::ExceptionHandler.call("blank") if jobs.empty?
			parsed_jobs = Job::Parser.process(jobs)
			@ordered_job_queue = Job::Order.process(parsed_jobs)
			@ordered_job_queue.count > 1 ? @ordered_job_queue : @ordered_job_queue.join
		end

	end
end