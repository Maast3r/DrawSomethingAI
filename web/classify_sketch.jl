using TensorFlow
using Images

function sketch_input(path, sketch_name)
    x = zeros(Float32, 1, 77841)
    y = zeros(Float32, 1, 10)
    img = load(path)
    img = restrict(restrict(img))
    flatten_img = reshape(img, 77841)
    x[1, :] = flatten_img
    
    label = find((x -> x == sketch_name), labels)[1]
    y[1, label] = 1.0
    
    x, y
end

function classify_sketch(sketch_path, sketch_label)
    x = TensorFlow.placeholder(Float32)
    y_ = TensorFlow.placeholder(Float32)
    W = get_variable("weights", [77841, 10], Float32)

    gpu_options = TensorFlow.tensorflow.GPUOptions(allow_growth=true, per_process_gpu_memory_fraction=0.4)
    config = TensorFlow.tensorflow.ConfigProto(gpu_options=gpu_options)
    sess = Session(config=config)
    #something something load

    sketch_path = "/raided/datasets/sketches_png/png/airplane/73.png"
    sketch_label = "airplane"

    test_img, test_label = sketch_input(sketch_path, sketch_label)
    what_it_thinks = labels[run(sess, indmax(y,2), Dict(x=>test_img, y_=>test_label))[1] + 1]
    println("Is it an " * what_it_thinks * "? Answer: ", (sketch_label == what_it_thinks), ".")
    what_it_thinks
end

classify_sketch(ARGS[0], ARGS[1])
