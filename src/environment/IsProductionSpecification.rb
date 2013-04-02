module Environment
	class IsProductionSpecification
		def satisified?
			ENV["RACK_ENV"] == "production"
		end
	end
end