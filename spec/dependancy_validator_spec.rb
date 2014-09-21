=begin
	Author: Mufudzi Masaire
	Job::DependencyValidator Service spec tests
=end

require './spec/spec_helper'

describe Job::DependencyValidator do

	let (:validator) { Job::DependencyValidator }

	describe ".self_dependent?" do
		context "when passed valid jobs" do
			it "does not raise an error" do
				parsed_jobs = [["a"], ["b", "c"], ["c"]]
				expected_output =
				checked = validator.self_dependent?(parsed_jobs)
				expect(checked).to eq(parsed_jobs)
			end
		end

		context "when passed self dependant jobs" do
			it "raises an error" do
				parsed_jobs = [["a"], ["b"], ["c", "c"]]
				expect { validator.self_dependent?(parsed_jobs) }.to raise_error(ArgumentError, "Jobs can’t depend on themselves.")
			end
		end
	end

	describe ".circular_dependency?" do
		context "when passed valid jobs" do
			it "does not raise an error" do
				parsed_jobs = [["a"], ["b", "c"], ["c", "f"], ["d", "a"], ["e", "b"], ["f"]]
				checked = validator.self_dependent?(parsed_jobs)
				expect(checked).to eq(parsed_jobs)
			end
		end

		context "when passed circular_dependent jobs" do
			it "raises an error" do
				parsed_jobs = [["a"], ["c", "b"], ["f", "c"], ["a", "d"], ["e"], ["b", "f"]]
				expect { validator.circular_dependency?(parsed_jobs) }.to raise_error(ArgumentError, "Jobs can’t have circular dependencies.")
			end
		end
	end

end