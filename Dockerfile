FROM debian:bookworm
WORKDIR /gosrc/siteserver

RUN apt update
RUN apt upgrade -y
RUN apt install curl python3 python3-pip -y

RUN python3 -m pip install --user mercurial --break-system-packages
ENV PATH="/root/.local/bin:$PATH"
RUN hg version

# prep the source
RUN curl https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py -O
RUN python3 bootstrap.py --no-interactive
RUN ls

# now build
WORKDIR /root/mozilla-unified
RUN hg up -C central
RUN ./mach build

# list the files so we can find the binaries later
RUN find .