=begin
	Author: Mufudzi Masaire
	Job::Order Service spec tests
=end

require './spec/spec_helper'

describe Job::Order do

	let (:parser) { Job::Parser }
	let (:order) { Job::Order }

	describe '.process' do
		context "when passed valid parsed jobs" do
			it "returns correctly ordered jobs" do
				jobs = "a =>\n b =>\nc =>"
				expected_output = ["a", "b", "c"]
				parsed_jobs = parser.process(jobs)
				ordered_jobs = order.process(parsed_jobs)
				expect(ordered_jobs).to eq(expected_output)
			end
		end

		context "when passed parsed self dependent jobs" do
			it 'raises an exception' do
				jobs = "a =>\n b =>\nc => c"
				parsed_jobs = parser.process(jobs)
				expect { order.process(parsed_jobs) }.to raise_error(ArgumentError)
			end
		end

		context "when passed parsed circular dependent jobs " do
			it 'raises an exception' do
				jobs = "a =>\n b => c\nc => f\n d => a\n e =>\n f => b"
				parsed_jobs = parser.process(jobs)
				expect { order.process(parsed_jobs) }.to raise_error(ArgumentError)
			end
		end
	end

end