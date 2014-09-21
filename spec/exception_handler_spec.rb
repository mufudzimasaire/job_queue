=begin
	Author: Mufudzi Masaire
	Job::ExceptionHandler Service spec tests
=end


require './spec/spec_helper'

describe Job::ExceptionHandler do

	let (:handler) { Job::ExceptionHandler }

	describe ".call" do
		context "when passed exception type - 'blank'" do
			it "raises an error " do
				expect { handler.call("blank") }.to raise_error(ArgumentError, "Jobs can't be blank")
			end
		end

		context "when passed exception type - 'self'" do
			it "raises an error " do
				expect { handler.call("self") }.to raise_error(ArgumentError, "Jobs can’t depend on themselves.")
			end
		end

		context "when passed exception type - 'circular'" do
			it "raises an error " do
				expect { handler.call("circular") }.to raise_error(ArgumentError, "Jobs can’t have circular dependencies.")
			end
		end
	end

end