/*
	This is a fix for fixing lua run with hammer. At times lua run will mess up due to commanas in the code, as it is used to seperate things in the bsp file format.


	This code below allows you to construct arguments, and tables without using any commans at all.
	By doing what is called "function" chaining.
	Dictonaries will expect a key, then a value, then a key, then a value, and so on.
*/


function HammerArgFixer()

	local funcStuff = {
		func = function(self, arg)
			self.args[#self.args + 1] = arg
		end,
		Table = function(self)
			return unpack(self.args)
		end,
		Dictonary = function(self)
			local dic = {}
			for i = 1, #self.args, 2 do
				dic[self.args[i]] = self.args[i + 1]
			end
			return dic
		end
	}

	local func = setmetatable({ args = {}}, {
		__index = funcStuff,
		__call = function(self, arg)
			self:func(arg)
			return self
		end
	})
	return func
end


/*
HammerArgFixer()(1)(2)(3)(4)(5):Table() -- {1, 2, 3, 4, 5}
HammerArgFixer()("Hello")("World")("Thing")(2):Dictonary() -- {Hello = "World", Thing = 2}
HammerArgFixer()(HammerArgFixer()("Name")("Garry"):Dictonary())(HammerArgFixer()("Name")("Star"):Dictonary()):Table() -- { {Name = "Garry"}, {Name = "Star"} }
*/