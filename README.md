# docker-jenkins-pyenv

因为官方内置的 python 版本过低，同时项目需要各种版本的测试，所以基于官方的镜像，新添 pyenv 支持。

- 默认支持安装 `3.6.11`， `3.7.8`，`3.8.5` 等等版本，可以根据 pyenv 支持的版本，修改 `python-versions.txt` 进行构建。
- 默认安装 nox（https://nox.thea.codes/en/stable/）

## 注意事项

因 pyenv 是使用 root 用户进行安装的，所以 jenkins 镜像默认的用户 jenkins 在使用时，需要修改 PATH

```shell
export PATH=/opt/pyenv/shims:/opt/pyenv/bin:$PATH
```

或者使用绝对路径进行使用 `pyenv`
