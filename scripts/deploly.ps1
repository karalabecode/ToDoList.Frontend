param(
  [Parameter(Mandatory=$true)]
  [String]$ws
)

& ./generate.ps1;

if (!$?) { return; }

cd ../infrastructure;
tf init && tf workspace select $ws && tf plan -out plan.tfplan;

if ($?) {
  $answer = Read-Host "Looks ok? [y/N]"

  if ($answer -eq "y" -or $answer -eq "yes") {
    tf apply plan.tfplan;
  }
}

cd ../scripts;
