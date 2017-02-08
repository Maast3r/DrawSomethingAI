using Images
using DataFrames
using FileIO

println("Loading picture..")
img = load("/raided/datasets/sketches_png/png/airplane/1.png")
img2 = load("/raided/datasets/sketches_png/png/airplane/2.png")
println("Done loading picture. Now extracting pixel values...\n")

println("Converting image to array of strings...")
# img = map(x -> x.val, img)
img = map(x-> x.val, img)
img2 = map(x-> x.val, img2)
println("img is now an array of strings\n")

println("Reshape img to 1d array...")
transpose = reshape(img, (1234321, 1))
transpose2 = reshape(img2, (1234321, 1))
println(transpose[1])
println(ndims(transpose))
data = ["airplane"]
data2 = ["airplane"]
println(data[1])
println(ndims(data))
println("Done reshaping\n")

println("Appending tranpose of image to data")
data = vcat(data, transpose)
data2 = vcat(data2, transpose2)
println(data[1])
println(sizeof(data))
println(sizeof(data2))
println(typeof(data))
println("Done appending to data\n")

data3 = hcat(data, data2)
# something = reshape(data3, (2, 1234321))
println(ndims(data3))
println(typeof(data3))

println("Converting to dataframe...")
df = DataFrame(Any, 0, 1234322)
push!(df, data)
# push!(df, data2)

# println(head(df))
# df2 = convert(DataFrame, data3)
# println(head(df2))
println("Done converting to dataframe\n")

println("Writing out to csv...")
writetable("asdf.csv", df)
println("Done writing\n")

println("Reading in csv...")
p = readtable("asdf.csv")

# println(head(p'))

