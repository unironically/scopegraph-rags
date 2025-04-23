FROM archlinux:base-devel
ENV LANG=C.UTF-8

# create, load contents into, and cd into submission/
RUN mkdir -p submission
COPY load submission
WORKDIR submission

# Install OCaml
RUN pacman -Syu --noconfirm \
  ocaml \
  ocamlbuild;

RUN pacman -Syu --noconfirm gcc glibc ncurses

RUN pacman -Syu --noconfirm vim

RUN pacman -Syu --noconfirm ant

RUN pacman -Syu --noconfirm make

RUN pacman -Syu --noconfirm curl
RUN curl -sSL https://get.haskellstack.org/ | sh
RUN cd ministatix.hs && stack build --copy-bins && cd .. && \ 
    rm -rf ministatix.hs && \ 
    rm -rf /var/cache/* && \ 
    rm -rf ~/.stack