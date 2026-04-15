{ pkgs, lib, config, inputs, ... }:

{
  languages.python.enable = true;
  languages.python.package = pkgs.python312;

  packages = (with pkgs.python312Packages; [
    transformers
    datasets
    tokenizers
    sentencepiece
    accelerate
    pytorch
  ]) ++ (with pkgs; [
    pyright
  ]);
}
