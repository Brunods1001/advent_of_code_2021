### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 570e0f29-1f8f-494d-bed6-f6e0ff2bce42
using Test

# ╔═╡ 4fd39268-60bd-11ec-27c5-c19f1af62910
data = """0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"""

# ╔═╡ 84133a1e-e099-4c3c-afc8-522acfb68c4f
md"""
Consider only horizontal and vertical lines where x1 = x2 or y1 = y2
"""

# ╔═╡ 7fec022e-804d-4026-96fe-ae0fbd145bf0
md"""
## Prepare data
"""

# ╔═╡ 0d8b5f3b-1727-4504-9da2-3fb748a46349
split_data(data) = strip.(split(data, "\n"))

# ╔═╡ b97e7da1-f007-454e-9382-061f7e558f76
@test split_data(data) |> length == 10

# ╔═╡ bc88f764-569a-41ad-8bb3-bd36f3b6777e
md"""
## Create Point type
"""

# ╔═╡ 6dd8ddae-d007-47b3-88d8-3a81c25a9bdb
parse(Int, "4")

# ╔═╡ ca31d9ea-717b-47a4-8dea-6a1ec3ac90a3
struct Point
	x
	y
	Point(txt) = new(parse.(Int, split(txt, ","))...)
end

# ╔═╡ 7ff2b7f2-5345-441e-8b42-ec5e302ccebb
revert(p::Point) = "$(p.x),$(p.y)"

# ╔═╡ 44411ad7-8d46-43fa-9301-45b81b408b27
md"""
## Create Line type
"""

# ╔═╡ c145be9e-cb13-4d6b-8107-6aa4cd9e4a03
struct Line
	p1
	p2
	Line(txt) = new(Point.(split(txt, " -> "))...)
end

# ╔═╡ 79a4d750-ea23-4013-b8d3-16e85926f75b
revert(l::Line) = "$(revert(l.p1)) -> $(revert(l.p2))"

# ╔═╡ 4504cfc7-42da-46e0-a89e-8c3c9a9394e1
@testset "point struct" begin
	point = Point("1,2")
	@test point.x == 1
	@test point.y == 2
	@test revert(point) == "1,2"
end

# ╔═╡ eafea370-3cfd-4332-80e5-6f6d85d78469
@testset "line struct" begin
	line = Line("5,5 -> 8,2")
	@test line.p1 == Point("5,5")
	@test line.p2 == Point("8,2")
	@test revert(line) == "5,5 -> 8,2"
end

# ╔═╡ 53f689db-6aa5-4a5e-8e1c-aa3465d65293
Line("5,5 -> 8,2")

# ╔═╡ 26cb2de8-8711-4ba0-8911-6136dce00025
md"""
## Add or subtract points
"""

# ╔═╡ 1522c61d-4aae-4b51-b516-08c20d5257f5
begin
	import Base:+
	import Base.-
end

# ╔═╡ 1b76ade7-6d0b-4862-ac96-cfc273126752
create_point(x, y) = Point("$(x),$(y)")

# ╔═╡ b010bbbc-e813-48e3-84f3-d9734303925e
begin
	Base.:-(p1::Point, p2::Point) = create_point(p1.x - p2.x, p1.y - p2.y)
	Base.:+(p1::Point, p2::Point) = create_point(p1.x + p2.x, p1.y + p2.y)
end

# ╔═╡ 93f32a9b-288f-4656-b254-d5035f21fc08
Point("5,5") - Point("1,10")

# ╔═╡ d7cc587c-327b-420d-a529-a61e157069cc
@testset "add and subtract" begin
	p1 = Point("5,5")
	p2 = Point("8,2")
	@test p1 + p2 == Point("13,7")
	@test p1 - p2 == Point("-3,3")
end

# ╔═╡ b7b39c69-8085-47f7-843c-c7e34f2ff8a6
md"""
## Test point coverage
"""

# ╔═╡ 631c8c93-b605-4cd0-837b-302a1e43117d
collect(9:-1:3)

# ╔═╡ bae71f9d-9ac8-4084-ab88-cdb6c984f0c7
function coverage(p1::Point, p2::Point; all=false)	
	if p1.x < p2.x
		inc_x = 1
	else
		inc_x = -1
	end
	if p1.y < p2.y
		inc_y = 1
	else
		inc_y = -1
	end
	if all
		list_x = p1.x:inc_x:p2.x
		list_y = p1.y:inc_y:p2.y
		
	elseif p1.x == p2.x
		list_y = p1.y:inc_y:p2.y
		numrep = length(list_y)
		list_x = repeat([p1.x], numrep)
	elseif p1.y == p2.y
		list_x = p1.x:inc_x:p2.x
		numrep = length(list_x)
		list_y = repeat([p1.y], numrep)
	else
		list_x = []
		list_y = []
	end
	[create_point(i, j) for (i,j) in zip(list_x, list_y)]	
end

# ╔═╡ ecc9a402-586c-442b-a772-a17515b8b72a
coverage(line::Line; all=false) = coverage(line.p1, line.p2; all)

# ╔═╡ a70e2dcb-884a-4186-860b-f1fd5b29232c
begin
	p1 = Point("10,5")
	p2 = Point("8,5")
	coverage(p1, p2; all=false)
end

# ╔═╡ ef2dc34b-7eb8-4061-9164-7e626f2017a8
@testset "coverage" begin
	l1 = "1,1 -> 1,3"
	l2 = "9,7 -> 7,7"
	line1 = Line(l1)
	line2 = Line(l2)
	@test coverage(line1) == [Point("1,1"), Point("1,2"), Point("1,3")]
	@test coverage(line2) == [Point("9,7"), Point("8,7"), Point("7,7")]
end

# ╔═╡ 955adad4-e098-49ce-84b8-af55d39e389c
revert.(coverage(Line("1,1 -> 1,3")))

# ╔═╡ 869ee00a-9859-4161-b49e-81524243c079
md"""
## Parse line into point
"""

# ╔═╡ d7280b28-39a8-44e6-9ef0-a1ccbae8709b
parse_line(line) = Line(line)#collect(Point(split(i, ",")) for i in split(line, " -> "))

# ╔═╡ 9a0dd991-104f-4a29-a3c3-12e80eb9fe98
line = first(split_data(data))

# ╔═╡ fbfc0808-e96d-4be4-a88d-6b6e83e5df6a
list_lines = parse_line.(split_data(data))

# ╔═╡ 81af8fa1-6561-4876-b08e-9579edacbf06
coverage.(list_lines; all=true)

# ╔═╡ cfb4027a-209c-4445-a564-33976fe7d767
@test split_data(data) == revert.(parse_line.(split_data(data)))

# ╔═╡ d764307b-e33b-4c10-94bf-42e19fda48fa
md"""
## How many points do at least two lines overlap?
"""

# ╔═╡ 24b79bca-a38d-498a-913c-02491a9fea67
import StatsBase

# ╔═╡ d174a2aa-b0d9-4e4f-818e-9f0a86aa87d8
"Finds number of duplicate points"
function calc_overlap1(data)
	lines = parse_line.(split_data(data))
	points = vcat(coverage.(lines)...)
	count_points = StatsBase.countmap(points)
	length(filter((v) -> v[2] > 1, count_points))
end

# ╔═╡ 2b87de30-36bf-4b06-8138-796cf2a30245
@testset "overlap" begin
	@test calc_overlap1(data) == 5
end

# ╔═╡ 66de0c0d-a2b4-426d-b154-0288cc29ae19
md"""
## Part 1
"""

# ╔═╡ 31538a56-f9a4-4950-b14a-6314b14c5d5b
puzzle = read("./data.txt", String) |> strip

# ╔═╡ 3f32edd3-fd99-48bb-b512-f79917525e5b
calc_overlap1(puzzle)

# ╔═╡ a156ec1a-7359-46b5-8f7b-e98024240949
md"""
## Part 2
"""

# ╔═╡ 181f62ac-83c6-48dd-8120-255cc5a27814
function calc_overlap2(data)
	lines = parse_line.(split_data(data))
	points = vcat(coverage.(lines; all=true)...)
	count_points = StatsBase.countmap(points)
	length(filter((v) -> v[2] > 1, count_points))
end

# ╔═╡ 85ef7142-e492-41a4-92e7-e01bbffd9782
calc_overlap2(data)

# ╔═╡ 83206611-990e-4678-b6ed-089bcebd907e
@testset "overlap 2" begin
	@test calc_overlap2(data; all=true) == 12
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
StatsBase = "~0.33.13"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4c26b4e9e91ca528ea212927326ece5918a04b47"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.2"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "e5718a00af0ab9756305a0392832c8952c7426c1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.6"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
git-tree-sha1 = "0f2aa8e32d511f758a2ce49208181f7733a0936a"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.1.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2bb0cb32026a66037360606510fca5984ccc6b75"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.13"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═4fd39268-60bd-11ec-27c5-c19f1af62910
# ╟─84133a1e-e099-4c3c-afc8-522acfb68c4f
# ╟─7fec022e-804d-4026-96fe-ae0fbd145bf0
# ╠═570e0f29-1f8f-494d-bed6-f6e0ff2bce42
# ╠═0d8b5f3b-1727-4504-9da2-3fb748a46349
# ╠═b97e7da1-f007-454e-9382-061f7e558f76
# ╟─bc88f764-569a-41ad-8bb3-bd36f3b6777e
# ╠═6dd8ddae-d007-47b3-88d8-3a81c25a9bdb
# ╠═ca31d9ea-717b-47a4-8dea-6a1ec3ac90a3
# ╠═7ff2b7f2-5345-441e-8b42-ec5e302ccebb
# ╠═4504cfc7-42da-46e0-a89e-8c3c9a9394e1
# ╟─44411ad7-8d46-43fa-9301-45b81b408b27
# ╠═c145be9e-cb13-4d6b-8107-6aa4cd9e4a03
# ╠═79a4d750-ea23-4013-b8d3-16e85926f75b
# ╠═eafea370-3cfd-4332-80e5-6f6d85d78469
# ╠═53f689db-6aa5-4a5e-8e1c-aa3465d65293
# ╟─26cb2de8-8711-4ba0-8911-6136dce00025
# ╠═1522c61d-4aae-4b51-b516-08c20d5257f5
# ╠═1b76ade7-6d0b-4862-ac96-cfc273126752
# ╠═b010bbbc-e813-48e3-84f3-d9734303925e
# ╠═93f32a9b-288f-4656-b254-d5035f21fc08
# ╠═d7cc587c-327b-420d-a529-a61e157069cc
# ╟─b7b39c69-8085-47f7-843c-c7e34f2ff8a6
# ╠═631c8c93-b605-4cd0-837b-302a1e43117d
# ╠═bae71f9d-9ac8-4084-ab88-cdb6c984f0c7
# ╠═a70e2dcb-884a-4186-860b-f1fd5b29232c
# ╠═ecc9a402-586c-442b-a772-a17515b8b72a
# ╠═ef2dc34b-7eb8-4061-9164-7e626f2017a8
# ╠═955adad4-e098-49ce-84b8-af55d39e389c
# ╟─869ee00a-9859-4161-b49e-81524243c079
# ╠═d7280b28-39a8-44e6-9ef0-a1ccbae8709b
# ╠═9a0dd991-104f-4a29-a3c3-12e80eb9fe98
# ╠═fbfc0808-e96d-4be4-a88d-6b6e83e5df6a
# ╠═81af8fa1-6561-4876-b08e-9579edacbf06
# ╠═cfb4027a-209c-4445-a564-33976fe7d767
# ╟─d764307b-e33b-4c10-94bf-42e19fda48fa
# ╠═24b79bca-a38d-498a-913c-02491a9fea67
# ╠═d174a2aa-b0d9-4e4f-818e-9f0a86aa87d8
# ╠═2b87de30-36bf-4b06-8138-796cf2a30245
# ╟─66de0c0d-a2b4-426d-b154-0288cc29ae19
# ╠═31538a56-f9a4-4950-b14a-6314b14c5d5b
# ╠═3f32edd3-fd99-48bb-b512-f79917525e5b
# ╟─a156ec1a-7359-46b5-8f7b-e98024240949
# ╠═181f62ac-83c6-48dd-8120-255cc5a27814
# ╠═85ef7142-e492-41a4-92e7-e01bbffd9782
# ╠═83206611-990e-4678-b6ed-089bcebd907e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
