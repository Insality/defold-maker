--- FSM actions let you control other FSM instances
-- @submodule Actions

local instances = require("adam.system.instances")
local helper = require("adam.system.helper")
local ActionInstance = require("adam.system.action_instance")

local M = {}


--- Send event to target Adam instance
-- @function actions.fsm.send_event
-- @tparam string|adam target The target instance for send event. If there are several instances with equal ID, event will be delivered to all of them.
-- @tparam string event_name The event to send
-- @tparam[opt] number delay Time delay in seconds
-- @tparam[opt] bool is_every_frame Repeat every frame
function M.send_event(target, event_name, delay, is_every_frame)
	local action = ActionInstance("fsm.send_event", function(self)
		self.context.timer_id = helper.delay(delay, function()
			for _, instance in ipairs(instances.get_all_instances_with_id(target)) do
				instance:event(event_name)
			end
			self:finished()
		end)
	end, function(self)
		if self.context.timer_id then
			timer.cancel(self.context.timer_id)
			self.context.timer_id = nil
		end
	end)

	action:set_deferred(true)
	return action
end


--- Broadcast event to all active FSM
-- @function actions.fsm.broadcast_event
-- @tparam string event_name The event to send
-- @tparam[opt] bool is_exclude_self Don't send the event to self
-- @tparam[opt] number delay Time delay in seconds
function M.broadcast_event(event_name, is_exclude_self, delay)
	local action = ActionInstance("fsm.broadcast_event", function(self)
		self.context.timer_id = helper.delay(delay, function()
			for _, instance in ipairs(instances.get_all_instances()) do
				if not is_exclude_self or instance ~= self:get_adam_instance() then
					instance:event(event_name)
				end
			end
			self:finished()
		end)
	end, function(self)
		if self.context.timer_id then
			timer.cancel(self.context.timer_id)
			self.context.timer_id = nil
		end
	end)

	action:set_deferred(true)
	return action
end


return M