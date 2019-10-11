# MagiskFrida
[![Build Status](https://cloud.drone.io/api/badges/ViRb3/magisk-frida/status.svg)](https://cloud.drone.io/ViRb3/magisk-frida)
![GitHub repo size](https://img.shields.io/github/repo-size/ViRb3/magisk-frida)

> [Frida](https://frida.re) is a dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers

> [MagiskFrida](README.md) lets you run frida-server on boot with [Magisk](https://github.com/topjohnwu/Magisk)

## Supported architectures
- `arm64`, `arm`, `x86`, `x86_64`

## Instructions
- Install `MagiskFrida` from [Magisk Manager](https://github.com/topjohnwu/Magisk)

## How fast are frida-server updates?
In less than 24 hours! They're automatic, too

## Why pre-releases?
Due to incompatibility between the [release tool](https://github.com/release-it/release-it) and the versioning system

## Issues?
Check out the [troubleshooting guide](TROUBLESHOOTING.md)

## Building yourself

```bash
poetry install
poetry run python build.py
```

- Release ZIPs will be under `/releases`
- frida-server downloads will be under `/downloads`
