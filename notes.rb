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

# Catch self-dependent jobs eg. c => c
d = Array.new
c.each do |element|
	if element.count.eql?(2)
		raise ArgumentError.new("Jobs can’t have circular dependencies.") if element[0] == element[1]
	end
	d << element
end
=> [["a"], ["b", "c"], ["c", "f"], ["d", "a"], ["e", "b"], ["f"]]


# ordering dependencies
jobs = Array.new
temp = []
d.map { |element| element.count > 1 ? jobs << (temp[0], temp[1] = element[1], element[0]) : jobs << element }
=> [["a"], ["c", "b"], ["f", "c"], ["a", "d"], ["b", "e"], ["f"]]



#ORDER JOBS
#jobs = [["a"], ["c", "b"], ["f", "c"], ["a", "d"], ["b", "e"], ["f"]]
#expected result = f before c, c before b, b before e and a before d

ordered_jobs = []
jobs.map do |job|
	# Indentify similar jobs
	similar_job = ordered_jobs & job
	if ordered_jobs.empty? || similar_job.empty?
		ordered_jobs << job
	else
		unless similar_job.count.eql?(1)
			# if similar_job is greater than 1,
			# this indicates circular dependency
			raise ArgumentError.new("Jobs can’t have circular dependencies.")
		end
		position = ordered_jobs.index(similar_job.join).to_i
		ordered_jobs[position] = job
	end
	ordered_jobs.flatten!
end

=> ["a", "d", "f", "c", "b", "e"]
# Matches expected result



# TESTING JOBS WITH CIRCULAR DEPENDENCIES USING ABOVE CODE
#jobs = [["a"], ["c", "b"], ["f", "c"], ["a", "d"], ["e"], ["b", "f"]]
#expected result = "Jobs can’t have circular dependencies."
=> ArgumentError: Jobs cant have circular dependencies.
# Matches expected result



