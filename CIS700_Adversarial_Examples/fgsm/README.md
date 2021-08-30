# Overview 
This code repository demostrates how to generate adversarial examples in a simple neuron network of 3 layers and print out the Euclidean distance between the output of a clean image and a perturbed image at each layer. The method used to generate perturbated image is Fast Gradient Sign Method, the implementation (in PyTorch) of the method proposed in the paper: [Explaining and Harnessing Adversarial Examples](https://arxiv.org/pdf/1412.6572.pdf). The implementation is over the MNIST dataset.

## Run
```bash
./main.py
```

## Output Explanation
```
1 [10.411297798156738, 7.42767858505249, 10.027917861938477]
0 [11.877378463745117, 9.285502433776855, 12.691786766052246]
```

The first element (0 or 1) means the perturbed image is mis-classified by the model or not.
The values in the tuple shows the Euclidean distance of the output at each of the 3 layers.
