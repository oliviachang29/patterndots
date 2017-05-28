local GGCredit = {}
local GGCredit_mt = { __index = GGCredit }

local json = require( "json" )

local time = os.time
local date = os.date
local sort = table.sort

--- Initiates a new GGCredit object.
-- @return The new object.
function GGCredit:new()
    
    local self = {}
    
    setmetatable( self, GGCredit_mt )

	self.balance = 0

	self:load()

    return self
    
end

--- Adds some credits to the current balance.
-- @param amount The amount of credits to earn.
function GGCredit:earn( amount )
	self.balance = self.balance + amount
	self:save()
end

--- Removes some credits to the current balance.
-- @param spends The amount of credits to spend.
function GGCredit:spend( amount )
	if self:canAfford( amount ) then
		self.balance = self.balance - amount
	end
	self:save()
end

--- Gets the current balance.
-- @return The credit balance.
function GGCredit:currentBalance()
	return self.balance
end

--- Checks if the player has enough credits to spend.
-- @return True if the player can afford it, false otherwise.
function GGCredit:canAfford( amount )
	return self:currentBalance() - amount >= 0
end

--- Saves the current balance to disk.
function GGCredit:save()

	local path = system.pathForFile( "credit.dat", system.DocumentsDirectory )
	local file = io.open( path, "w" )

	if not file then
		return
	end	

	local data = { balance = self:currentBalance() }
	file:write( json.encode( data ) )
	io.close( file )
	file = nil

end

--- Loads the current balance from disk.
function GGCredit:load()

	local path = system.pathForFile( "credit.dat", system.DocumentsDirectory )
	local file = io.open( path, "r" )

	if not file then
		return
	end

	local data = json.decode( file:read( "*a" ) )

	self.balance = data.balance

	io.close( file )

	return self

end

--- Resets this GGCredit object.
function GGCredit:reset()
	self.balance = 0
	os.remove( system.pathForFile( "credit.dat", system.DocumentsDirectory ) )
end

--- Destroys this GGCredit object.
function GGCredit:destroy()
	self.balance = nil
end

return GGCredit

