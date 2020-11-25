--- Math actions perform different operations on FSM variables
-- @submodule Actions

local const = require("adam.const")
local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Add operator
-- @function actions.math.add
-- @tparam string source The variable name from Adam instance
-- @tparam number|variable value The number or Dmaker variable to add
-- @tparam[opt] boolean is_every_frame Check true, if action should be called every frame
-- @tparam[opt] boolean is_every_second Check true, if action should be called every second. Initial call is not skipped
function M.add(source, value, is_every_frame, is_every_second)
	local action = ActionInstance("math.add", function(self)
		local source_value = self:get_value(source) + self:get_param(value)
		self:set_value(source, source_value)
	end)

	if is_every_frame then
		action:set_every_frame(true)
	end

	if is_every_second then
		action:set_periodic(const.SECOND)
	end

	return action
end


function M.substract()

end


function M.multiply()

end


function M.divide()

end


function M.clamp()

end


function M.abs()

end


function M.random()

end


function M.random_boolean()

end


return M