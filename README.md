# p4c-lite-docker
Lightweight container images for the [p4lang/p4c](https://github.com/p4lang/p4c)
compiler.

The official [p4lang/p4c](https://hub.docker.com/r/p4lang/p4c/) image is quite
large: 1.2+GB (500MB compressed).

This repository maintains alternative images for the latest version of p4c
(images updated daily). These images only include the p4test and bmv2 backends
of p4c (the p4c driver is included).

| Image name           | Base Distribution | Image Size | Image Size Compressed |
| -------------------- | ----------------- |
| antoninbas/p4c-lite  | Ubuntu 20.04      | 300MB      | 80MB                  |

*If you want to contribute images for new distributions or if you know ways of
 reducing the image sizes further, any help is appreciated!.*
