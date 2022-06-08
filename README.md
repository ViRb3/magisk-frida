# MagiskFrida

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/ViRb3/magisk-frida/CI)
![GitHub repo size](https://img.shields.io/github/repo-size/ViRb3/magisk-frida)

> [Frida](https://frida.re) is a dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers

> [MagiskFrida](README.md) lets you run frida-server on boot with [Magisk](https://github.com/topjohnwu/Magisk)

## Supported architectures

`arm64`, `arm`, `x86`, `x86_64`

## Instructions

Install `MagiskFrida.zip` from [the releases](https://github.com/ViRb3/magisk-frida/releases)

> :information_source: Do not use the Magisk repository, it is obsolete and no longer receives updates

## How fast are frida-server updates?

Instant! This module is hooked to the official Frida build process

## Issues?

Check out the [troubleshooting guide](TROUBLESHOOTING.md)

## Building yourself

```bash
poetry install
poetry run python main.py
```

- Release ZIP will be under `/build`
- frida-server downloads will be under `/downloads`
