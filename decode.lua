for i = 1, #arg do
	local rf = assert(arg[i])
	local rfh = assert(io.open(rf, 'rb'))

	local wf = rf:gsub("%.[sS][pP][dD]$", ".txt", 1)
	assert(rf ~= wf)
	local wfh = assert(io.open(wf, 'w'))
	
	assert(rfh:seek("set", 1029))
	for pair in rfh:lines(16) do
		wl, A = string.unpack("<dd", pair)
		wfh:write(wl, "\t", A, "\n")
	end
end
