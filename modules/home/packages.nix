{ pkgs, du-packages, ... }:
let
  duPkgs = du-packages.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    bfg-repo-cleaner
    dive
    docker-client
    docker-compose
    dust
    fd
    fnm
    p7zip
    pre-commit
    rsync
    shellcheck
    viddy
    yamllint
    yq-go

    awscli2
    azure-cli
    buf
    cosign
    crane
    golangci-lint
    goreleaser
    granted
    grpcurl
    helm-docs
    istioctl
    k3d
    krew
    kubecolor
    kubectx
    kubectl
    kubernetes-helm
    opentofu
    oras
    scorecard
    skopeo
    stern
    terraform-docs
    tflint

    duPkgs.uds-cli
    duPkgs.zarf
  ];
}
