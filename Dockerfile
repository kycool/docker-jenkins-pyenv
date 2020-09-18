FROM jenkins/jenkins:latest

USER root

# 设置环境变量
ENV LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PATH="/opt/pyenv/shims:/opt/pyenv/bin:$PATH" \
    PYENV_ROOT="/opt/pyenv" \
    PYENV_SHELL="bash" \
    TBPYTHON="https://npm.taobao.org/mirrors/python"

# 解决 source not found in docker 的问题
# 替换源，使用阿里源
RUN ln -sf  /bin/bash /bin/sh \
    && cp /etc/apt/sources.list /etc/apt/sources.list.old \
    && sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list \
    && sed -i "s/security.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list

# 安装各种依赖
RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    libbz2-dev \
    libffi-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl1.0-dev \
    liblzma-dev \
    llvm \
    make \
    netbase \
    pkg-config \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 拷贝 pyenv 版本文案和需要安装的 python 版本文件
COPY pyenv-version.txt python-versions.txt requirements.txt /
COPY pip.conf /etc

# clone pyenv，安装各种版本的 python
RUN git clone -b `cat /pyenv-version.txt` --single-branch --depth 1 https://github.com/pyenv/pyenv.git $PYENV_ROOT \
    && for v in `cat /python-versions.txt`; do wget $TBPYTHON/$v/Python-$v.tar.xz -P $PYENV_ROOT/cache/ && pyenv install $v; done \
    && pyenv global `cat /python-versions.txt` \
    && pip install -r /requirements.txt \
    && find $PYENV_ROOT/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rf '{}' + \
    && find $PYENV_ROOT/versions -type f '(' -name '*.pyo' -o -name '*.exe' ')' -exec rm -f '{}' + \
    && rm -rf /tmp/*
