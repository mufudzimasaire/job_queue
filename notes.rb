=begin
	Investigating the problem using irb.
	This approach generally enables me to get my head around /or better understand the nature of the problem.
	As a result I am able to come up with possible ideas on how to best solve the problem.
=end


string = "a =>\n b => c\n c => f\n d => a\n e => b\n f =>"

# PARSE STRING
# splitting by new line
a = string.split(/\n/).map!(&:strip)
=> ["a =>", "b => c", "c => f", "d => a", "e => b", "f =>"]

# removing hash rockets & whitespace
b = Array.new
a.map { |element| b << element.split(/\=>/).join.squeeze.strip }
=> ["a", "b c", "c f", "d a", "e b", "f"]

# creating an array of arrays [dependent jobs grouoed together]
c = Array.new
b.map { |element| element.length.eql?(1) ? c << element.split : c << element.split(/ /) }
=> [["a"], ["b", "c"], ["c", "f"], ["d", "a"], ["e", "b"], ["f"]]

# ordering dependencies
jobs = Array.new
temp = []
c.map { |element| element.count > 1 ? jobs << (temp[0], temp[1] = element[1], element[0]) : jobs << element }
=> [["a"], ["c", "b"], ["f", "c"], ["a", "d"], ["b", "e"], ["f"]]



#ORDER JOBS
#jobs = [["a"], ["c", "b"], ["f", "c"], ["a", "d"], ["b", "e"], ["f"]]
#expected result = f before c, c before b, b before e and a before d

ordered_jobs = []
jobs.map do |job|
	if ordered_jobs.empty? || ( ordered_jobs & job ).empty?
		#Compare 2 arrays for matches
		ordered_jobs << job
		ordered_jobs.flatten!
	else
		similar_job = ordered_jobs & job
		# Identify circular dependency
		# if similar_job is greater than 1,
		# this indicates circular dependency
		if similar_job.count.eql?(1)
			position = ordered_jobs.index(similar_job.join).to_i
			ordered_jobs[position] = job
			ordered_jobs.flatten!
		else
			raise ArgumentError.new("Jobs can’t have circular dependencies.")
		end
	end
	ordered_jobs
end

=> ["a", "d", "f", "c", "b", "e"]
# Matches expected result



