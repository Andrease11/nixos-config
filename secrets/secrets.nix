let
  personalPc = "age1f6kxg79u9pegsv3vzp0hr3dfy6jq34kg5udycykfyup78ysh2paq5356yd";
  workWsl = "age19vsk2phxn3r0ss4hr5snt75rhyznaqq53mlktpkzdfzam6rku5gsy466dm";
in
{
  "secrets/personal-pc-github-hosts.yml.age".publicKeys = [ personalPc ];
  "secrets/work-wsl-github-hosts.yml.age".publicKeys = [ workWsl ];
}
