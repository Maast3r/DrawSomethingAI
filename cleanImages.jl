using Images
using DataFrames
using FileIO

## THERE ARE 250 different sketches, with 80 sketches each

dataSetFolder = "/raided/datasets/sketches_png/png/"
df = DataFrame(Any, 0, 1234322)

listOfImgs = open(dataSetFolder * "filelist.txt")
imgPaths = readlines(listOfImgs)
close(listOfImgs)

writetable("/raided/datasets/sketches_png/allSketches.csv", df)

output = open("/raided/datasets/sketches_png/allSketches.csv", "a")

count = 0
for path in imgPaths
    path = path[1:end-1]
    sketchName = split(path, "/")[1]

    println("Loading picture " * dataSetFolder * path * "... ")
    img = load(dataSetFolder * path)
    println("Done loading picture. Now extracting pixel values...\n")

    println("Converting image to array of strings...")
    img = map(x-> round(Int64, x.val), img)
    println("img is now an array of strings\n")

    println("Reshape img to 1d array...")
    flatten = reshape(img, 1234321)
    println("Done reshaping\n")

    println("Appending tranpose of image to data and convert to (1,21234322) array...")
    data = vcat([sketchName], flatten)
    data = reshape(data, (1, 1234322))
    println("Done appending to data\n")

    println("Writing out to csv...")
    writecsv(output, data)
    println("Done writing\n")
    count += 1
    if count == 80
        break
    end
end

close(output)

println("********************************")
println("DONE")
println("********************************")

# 61 839 458