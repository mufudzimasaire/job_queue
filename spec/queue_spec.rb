=begin
	Author: Mufudzi Masaire
	Job::Queue class spec tests
=end

require './spec/spec_helper'

describe Job::Queue do

	let(:queue) { Job::Queue.new('Test Job Que') }

	describe 'name' do
		context "Getting a queue name" do
			it 'returns the queue name' do
				name = queue.name
				expect(name).to eq('Test Job Que')
			end
		end

		context 'Setting a queue name' do
			it 'assigns a new queue name' do
				queue.name = "Billing Job Queue"
				expect(queue.name).to eq("Billing Job Queue")
			end
		end
	end

	describe 'process' do
		context 'valid job string' do
			it 'returns a string when passed a single job' do
				jobs = "a =>"
				expected_collection = "a"
				ordered_queue = queue.process(jobs)
				expect(ordered_queue).to eq(expected_collection)
			end

			it 'returns a collection when passed multiple jobs' do
				jobs = "a =>\n b => c\n c => f\n d => a\n e => b\n f =>"
				expected_collection = ["a", "d", "f", "c", "b", "e"]
				ordered_queue = queue.process(jobs)
				expect(ordered_queue).to eq(expected_collection)
			end
		end

		context 'invalid job string' do
			it 'raises an exception when passed self dependent jobs' do
				jobs = "a =>\n b =>\nc => c"
				expect { queue.process(jobs) }.to raise_error(ArgumentError)
			end

			it 'raises an exception when passed circular dependencies' do
				jobs = "a =>\n b => c\nc => f\n d => a\n e =>\n f => b"
				expect { queue.process(jobs) }.to raise_error(ArgumentError)
			end
		end
	end

end