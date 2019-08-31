FROM ubuntu:18.04

LABEL version="19.08.02"
LABEL description="Make username fixed"
LABEL meintainer="east9698@gmail.com"

ENV USERNAME=toyolab
ENV PASSWORD=password
ENV ELIXIR_VERSION=1.9.1-1
ENV ERLANG_VERSION=1:22.0.7-1
ENV NODEJS_VERSION=12.8.1-1nodesource1
ENV GNUPG_VERSION=2.2.4-1ubuntu1.2

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y vim emacs
RUN apt-get install -y curl
RUN apt-get install -y sudo


# Add general user to the system
RUN useradd -m ${USERNAME}

# Set sudo priviledge to new user
RUN gpasswd -a ${USERNAME} sudo

# Set password for general user
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd

# Create nomal user
#RUN adduser ${USERNAME}
#RUN adduser ${USERNAME} sudo
#RUN adduser ${USERNAME} adm

RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch user and change directory
USER ${USERNAME}
WORKDIR /home/${USERNAME}


# install Elixir Runtime
RUN sudo apt install -y gnupg=${GNUPG_VERSION}
RUN curl -LO https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN sudo dpkg -i erlang-solutions_1.0_all.deb
RUN sudo apt update
RUN sudo apt install -y esl-erlang=${ERLANG_VERSION}
RUN sudo apt install -y elixir=${ELIXIR_VERSION}


# Install Phoenix Framework
RUN mix local.hex
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# Install Node.js

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN sudo apt-get install -y nodejs