{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "opkssh";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "openpubkey";
    repo = "opkssh";
    rev = "6c844ed86e4f0611f90c5022a1ddd400fb296613";
    hash = "sha256-DnnkgXkwCnNxznbkF4srgrGV76oZDkHvc09+B7gVf1I=";
  };

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  vendorHash = "sha256-bkTQqtlZhZ2/WnQNRdZzfblkGKjaAS22RFl6I1O3/yA=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/openpubkey/opkssh";
    description = "Enables SSH to be used with OpenID Connect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      johnrichardrinehart
      sarcasticadmin
    ];
    mainProgram = "opkssh";
  };
})
