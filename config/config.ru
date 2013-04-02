require "Manager"

manager = Manager.new()
app = lambda do |env|
	manager.run( env )
end

run app
