FROM quay.io/jupyter/base-notebook:python-3.12

USER root
ENV DEBIAN_FRONTEND=noninteractive

# -------------------------------------------------------------------
# System packages (including podman from Debian repos)
# -------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    nano \
    net-tools \
    sudo \
    wget \
    graphviz \
    file \
    tree \
    nodejs \
    npm \
    podman \
    uidmap \
    slirp4netns \
    fuse-overlayfs \
  && rm -rf /var/lib/apt/lists/*

# For tools that try to invoke "docker" (e.g., some CWL setups)
RUN ln -sf /usr/bin/podman /usr/local/bin/docker

# -------------------------------------------------------------------
# Kubernetes / Dev tooling (pinned)
# -------------------------------------------------------------------
ARG KUBECTL_VERSION=v1.29.3
RUN curl -fsSL \
    "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

ARG TASK_VERSION=v3.41.0
RUN curl -fsSL \
    "https://github.com/go-task/task/releases/download/${TASK_VERSION}/task_linux_amd64.tar.gz" \
    | tar -xz -C /usr/local/bin task && chmod +x /usr/local/bin/task

ARG SKAFFOLD_VERSION=2.17.1
RUN curl -fsSL \
    "https://storage.googleapis.com/skaffold/releases/v${SKAFFOLD_VERSION}/skaffold-linux-amd64" \
    -o /usr/local/bin/skaffold && chmod +x /usr/local/bin/skaffold

ARG ORAS_VERSION=1.3.0
RUN curl -fsSL \
    "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_amd64.tar.gz" \
    | tar -xz -C /usr/local/bin oras && chmod +x /usr/local/bin/oras

# -------------------------------------------------------------------
# yq / jq
# -------------------------------------------------------------------
ARG YQ_VERSION=v4.45.1
RUN curl -fsSL \
    "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" \
    -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq

ARG JQ_VERSION=jq-1.8.1
RUN curl -fsSL \
    "https://github.com/jqlang/jq/releases/download/${JQ_VERSION}/jq-linux-amd64" \
    -o /usr/local/bin/jq && chmod +x /usr/local/bin/jq

# -------------------------------------------------------------------
# Python tooling
# -------------------------------------------------------------------
ARG CALRISSIAN_VERSION=0.18.1
RUN pip install --no-cache-dir \
    awscli \
    awscli-plugin-endpoint \
    "jhsingle-native-proxy>=0.0.9" \
    bash_kernel \
    tomlq \
    uv \
    cwltool \
    cwltest \
    "calrissian==${CALRISSIAN_VERSION}" \
 && python -m bash_kernel.install

# -------------------------------------------------------------------
# hatch
# -------------------------------------------------------------------
ARG HATCH_VERSION=1.16.2
RUN curl -fsSL \
    "https://github.com/pypa/hatch/releases/download/hatch-v${HATCH_VERSION}/hatch-x86_64-unknown-linux-gnu.tar.gz" \
    | tar -xz -C /usr/local/bin hatch && chmod +x /usr/local/bin/hatch

USER ${NB_USER}
