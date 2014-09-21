=begin
	Author: Mufudzi Masaire
	Job::Parser Service spec tests
=end

require './spec/spec_helper'

describe Job::Parser do

	let (:parser) { Job::Parser }

	describe '.process' do
		context "when passed single job" do
			it "returns an array of arrays" do
				jobs = "a =>"
				expected_output = [["a"]]
				parsed_jobs = parser.process(jobs)
				expect(parsed_jobs).to eq(expected_output)
			end
		end

		context "when passed a collection" do
			it "returns an array of arrays" do
				jobs = "a =>\n b => c\n c => f\n d => a\n e => b\n f =>"
				expected_output = [["a"], ["b", "c"], ["c", "f"], ["d", "a"], ["e", "b"], ["f"]]
				parsed_jobs = parser.process(jobs)
				expect(parsed_jobs).to eq(expected_output)
			end
		end
	end

end