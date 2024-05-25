Remove-Item ../dist -Recurse
New-Item -ItemType Directory -Name ../dist | Out-Null
Copy-Item -Path ../src/* -Destination ../dist -Recurse
