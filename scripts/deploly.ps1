param(
  [Parameter(Mandatory=$true)]
  [ValidateSet('dev')]
  [String]$workspace
)

& ./generate.ps1;

if (!$?) { return; }

cd ../infrastructure;

$Env:AWS_PROFILE="tdl-${workspace}"

aws sts get-caller-identity;

if (-not $?) {
  aws sso login --profile $Env:AWS_PROFILE
}

$Env:AWS_PROFILE="tdl-${workspace}-dep"

tf init && tf workspace select $workspace && tf plan -out plan.tfplan;

if ($?) {
  $answer = Read-Host "Looks ok? [y/N]"

  if ($answer -eq "y" -or $answer -eq "yes") {
    tf apply plan.tfplan;
  }
}

cd ../scripts;
