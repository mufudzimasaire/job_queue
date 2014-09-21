=begin
	Author: Mufudzi Masaire
	Exception Handling Service
=end

module Job
	class ExceptionHandler
		class << self

			def call(type)
				exceptions = error(type)
			end

			private

				def error(type)
					# raises a new ArgumentError
					message = exception_message(type)
					raise ArgumentError.new(message)
				end

				def exception_message(type)
					# returns the message based on the received type
					type = type.downcase
					case type
						when "blank"
							"Jobs can't be blank"
						when "self"
							"Jobs can’t depend on themselves."
						when "circular"
							"Jobs can’t have circular dependencies."
						else
							return
						end
				end

		end
	end
end