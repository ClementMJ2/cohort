# docker buildx build --platform linux/amd64 --tag "devel" .
# docker buildx build --platform linux/amd64 --build-arg VARIANT=bullseye --build-arg USERNAME=<user> --build-arg R_VERSION=release .

# [Choice] Debian version: bullseye
# [Choice] Ubuntu version: jammy, 22-04
# Image from https://hub.docker.com/_/buildpack-deps
ARG VARIANT="jammy"
FROM buildpack-deps:${VARIANT}-curl

# Setup development environment
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/* /tmp/
RUN bash /tmp/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true"

# Ensure locales are properly set
ARG USER_LANG="en_US.UTF-8"
RUN bash /tmp/set_locale.sh "${USER_LANG}"

# Install Pandoc for Quarto and Rmarkdown
ARG PANDOC_VERSION="latest"
RUN bash /tmp/install_pandoc.sh "${PANDOC_VERSION}"

# Install Quarto for scientific and technical writing
ARG QUARTO_VERSION="latest"
RUN bash /tmp/install_quarto.sh "${QUARTO_VERSION}"

# Install R installation manager
ARG RIG_VERSION="latest"
RUN bash /tmp/install_rig.sh "${RIG_VERSION}"

# Add some system configuration for Git
RUN bash /tmp/setup_git.sh

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends \
#         <your-package-list-here> \
#     && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install R for the user and few packages to work with VSCode
USER "${USERNAME}"
COPY user-settings/* "/home/${USERNAME}/"
WORKDIR /home/"${USERNAME}"
ARG R_VERSION="release"
RUN rig add "${R_VERSION}"
ENV RENV_PATHS_CACHE=/renv_cache
RUN Rscript -e 'pak::pkg_install(c("renv", "httpgd", "languageserver", "cli", "prompt"))' -e 'pak::pak_cleanup(force = TRUE)'

# Cleanup temporary files and cache as root
USER root
RUN apt-get clean -y && apt-get autoremove -y && apt-get autoclean -y && rm -rf /var/lib/apt/lists/* /tmp/*
USER "${USERNAME}"

CMD ["/bin/bash"]
