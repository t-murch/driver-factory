# Driver Factory

The purpose of this repository is to make binaries easily executable on top of stateful, Kubernetes-based containers. One might ask "why not layer the image with what you need?" The answer is that sometimes, you will be relying on enterprise images, and cannot or should not be patching these images.

As a special note, if you have control over your images, you most certainly **should not** be using this repo to add functionality to your containers. Instead, layer your images. 

**Disclaimer:** This repo has very specific use cases and in other use cases would be an anti-pattern. **Avoid anti-patterns.** 
