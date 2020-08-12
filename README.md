# p4c-lite-docker
Lightweight container images for the [p4lang/p4c](https://github.com/p4lang/p4c)
compiler.

The official [p4lang/p4c](https://hub.docker.com/r/p4lang/p4c/) image is quite
large: 1.2+GB (500MB compressed).

This repository maintains alternative images for the latest version of p4c
(images updated daily). These images only include the p4test and bmv2 backends
of p4c (the p4c driver is included).

| Image name             | Base Distribution | Image Size | Image Size Compressed | Build Status |
| ---------------------- | ----------------- | ---------- | --------------------- | ------------ |
| [antoninbas/p4c-lite]  | Ubuntu 20.04      | 300MB      | 80MB                  | ![Ubuntu 20.04](https://github.com/antoninbas/p4c-lite-docker/workflows/Ubuntu%2020.04/badge.svg?branch=master&event=schedule) |

*If you want to contribute images for new distributions or if you know ways of
 reducing the image sizes further, any help is appreciated!.*

## Usage

If you need to use the image to compile a P4 program, the easiest way to get
started is to use the [p4c-lite.sh](p4c-lite.sh) script:
```bash
wget https://raw.githubusercontent.com/antoninbas/p4c-lite-docker/master/p4c-lite.sh
chmod +x p4c-lite.sh
./p4c-lite.sh <path to P4 program>
```

You can also use `docker run` to run a container directly, but be aware
that you will need to mount the P4 source code into the container, as
well as the output directory for compilation artifacts.

[antoninbas/p4c-lite]: https://hub.docker.com/r/antoninbas/p4c-lite
