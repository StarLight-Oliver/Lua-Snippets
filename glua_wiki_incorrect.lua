
// Here are snippets that can prove the gmod wiki is/was wrong

do
	// Someone forgot to sub -8 from the max size of a net packet as null chars at the end of the string.
	if SERVER then

		util.AddNetworkString("net_string_max")
	concommand.Add("test_net_string_max", function(ply)

		local str = ""

		for i=1,65532 do
			str = str .. "a"
		end

		print(#str)
		net.Start("net_string_max")
			net.WriteString(str)
		net.Send(ply)

	end)
	else
		net.Receive("net_string_max", function()
			print(net.ReadString())
		end)
	end
end