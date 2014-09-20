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
d = Array.new
temp = []
c.map { |element| element.count > 1 ? d << (temp[0], temp[1] = element[1], element[0]) : d << element }
=> [["a"], ["c", "b"], ["f", "c"], ["a", "d"], ["b", "e"], ["f"]]