data = read("data.txt", String)
bits = split(data)
max_len = maximum(length.(bits))
positions = Dict([i => 0 for i in 1:max_len])

function get_n_letter(word, n)
	word[n]
end

"Gets most common bit from a binary string"
function get_mode(arr)
	return Int(sum(parse.(Int, arr)) / length(arr) >= 0.5)
end


function update_positions!(bits, positions)
	for i in keys(positions)
		mode = get_mode(get_n_letter.(bits, Ref(i)))
		positions[i] = mode
	end
end

# get modes in each position
update_positions!(bits, positions)

# filter by modes until one bit remains
# O2
bits_O2 = bits
for i in 1:max_len
	vals = parse.(Ref(Int), get_n_letter.(bits_O2, Ref(i)))
	mode = Int(sum(vals) / length(vals) >= 0.5)
	idx = vals .== mode
	bits_O2 = bits_O2[idx]
	if length(bits_O2) == 1
		bits_O2
		break
	end
end

# CO2
bits_CO2 = bits
for i in 1:max_len
	vals = parse.(Ref(Int), get_n_letter.(bits_CO2, Ref(i)))
	mode = Int(sum(vals) / length(vals) > 0.5)

	idx = vals .!= mode
	bits_CO2 = bits_CO2[idx]
	if length(bits_CO2) == 1
		bits_CO2
		break
	end
end

println("O2")
println(parse(Int, bits_O2[1]; base=2))
println("CO2")
println(parse(Int, bits_CO2[1]; base=2))


