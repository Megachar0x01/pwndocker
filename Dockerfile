FROM phusion/baseimage:jammy-1.0.4
LABEL maintainer="MegaChar0x01"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    ipython3 \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    elfutils \
    gawk \
    file \
    python3-distutils \
    bison \
    rpm2cpio cpio \
    zstd \
    zsh \
    tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    version=$(curl -s https://api.github.com/repos/radareorg/radare2/releases/latest | grep -P '"tag_name": "(.*)"' -o| awk '{print $2}' | awk -F"\"" '{print $2}') && \
    wget https://github.com/radareorg/radare2/releases/download/${version}/radare2_${version}_amd64.deb && \
    dpkg -i radare2_${version}_amd64.deb && \
    rm radare2_${version}_amd64.deb

RUN python3 -m pip config set global.index-url http://pypi.tuna.tsinghua.edu.cn/simple && \
    python3 -m pip config set global.trusted-host pypi.tuna.tsinghua.edu.cn && \
    python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    ropgadget \
    z3-solver \
    smmap2 \
    apscheduler \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr \
    pebble \
    r2pipe \
    pwntools

RUN gem install elftools one_gadget seccomp-tools && \
    rm -rf /var/lib/gems/*/cache/*

RUN curl --proto '=https' --tlsv1.2 -LsSf 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb && \
    rm -rf /tmp/*

RUN git clone --depth 1 https://github.com/scwuaptx/Pwngdb.git ~/Pwngdb && \
    cd ~/Pwngdb && \
    mv .gdbinit .gdbinit-pwngdb && \
    sed -i "s?source ~/peda/peda.py?# source ~/peda/peda.py?g" .gdbinit-pwngdb && \
    echo "source ~/Pwngdb/.gdbinit-pwngdb" >> ~/.gdbinit && \
    rm -rf ~/Pwngdb/.git

RUN wget -O ~/.gdbinit-gef.py -q http://gef.blah.cat/py

RUN git clone --depth 1 https://github.com/niklasb/libc-database.git /var/lib/libc-database && \
    pwn libcdb fetch -u ubuntu debian && \
    rm -rf /tmp/* /var/lib/libc-database/.git


WORKDIR /tools

RUN git clone https://github.com/ohmyzsh/ohmyzsh.git &&  cd ohmyzsh &&  cd tools &&  chmod +x install.sh && ./install.sh

RUN wget "https://github.com/io12/pwninit/releases/download/3.3.1/pwninit" -o /bin/pwninit

RUN mv pwninit /bin/pwninit

RUN chmod +x /bin/pwninit

RUN chsh -s /usr/bin/zsh

RUN  echo "FLAG{*** REDACTED ***}" > /flag.txt
RUN  echo "FLAG{*** REDACTED ***}" > /flag
RUN  echo "setw -g mouse on" > ~/.tmux.conf

WORKDIR /data


