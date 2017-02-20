using TensorFlow
using Images

data_set_folder = "/raided/datasets/sketches_png/png/"
files_in_folder = readdir(data_set_folder)
labels = filter(x->isdir(data_set_folder * x) == true, files_in_folder)

function sketch_input(path, sketch_name)
    x = zeros(Float32, 1, 77841)
    y = zeros(Float32, 1, 250)
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
    W = get_variable("weights", [77841, 250], Float32)
    b = get_variable("bias", [250], Float32)

    y = nn.softmax(x*W + b)
    cross_entropy = reduce_mean(-reduce_sum(y_ .* log(y), reduction_indices=[2]))
    train_step = train.minimize(train.GradientDescentOptimizer(.00001), cross_entropy)

    saver = train.Saver()
    gpu_options = TensorFlow.tensorflow.GPUOptions(allow_growth=true, per_process_gpu_memory_fraction=0.4)
    config = TensorFlow.tensorflow.ConfigProto(gpu_options=gpu_options)
    sess = Session(config=config)
    
    train.restore(saver, sess, "models/4percAcc-allCats")

    test_img, test_label = sketch_input(sketch_path, sketch_label)
    labels[run(sess, indmax(y,2), Dict(x=>test_img, y_=>test_label))[1] + 1]
end

print(classify_sketch(ARGS[1], ARGS[2]))
