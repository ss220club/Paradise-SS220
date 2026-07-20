## Copyright (c) 2020 Aleksej Komarov
## SPDX-License-Identifier: MIT

## Initial set-up
## --------------------------------------------------------

## Enable strict mode and stop of first cmdlet error
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

## Validates exit code of external commands
function Throw-On-Native-Failure {
  if (-not $?) {
    exit 1
  }
}

## Normalize current directory
$basedir = Split-Path $MyInvocation.MyCommand.Path
$basedir = Resolve-Path "$($basedir)\.."
Set-Location $basedir
[Environment]::CurrentDirectory = $basedir


## Functions
## --------------------------------------------------------

function yarn {
  $YarnRelease = Get-ChildItem -Filter ".yarn\releases\yarn-*.cjs" | Select-Object -First 1
  node ".yarn\releases\$YarnRelease" @Args
  Throw-On-Native-Failure
}

function Remove-Quiet {
  Remove-Item -ErrorAction SilentlyContinue @Args
}

function task-install {
  yarn install
}

## Minifies tgui/html assets
function task-setup {
  yarn run build:helpers
  Write-Output "tgui: html helpers minified"
  yarn run build:style
  Write-Output "tgui: html styles minified"
}

## Runs rspack
function task-rspack {
  yarn run rspack @Args
}

## Runs a development server
function task-dev-server {
  yarn node --experimental-modules "packages/tgui-dev-server/index.js" @Args
}

## Run a linter through all packages
function task-lint {
  yarn run tsc
  Write-Output "tgui: type check passed"
  yarn run eslint packages @Args
  Write-Output "tgui: eslint check passed"
}

function task-test {
  yarn run jest
}

function task-prettier {
  npx prettier --check packages @Args
}

## Mr. Proper
function task-clean {
  ## Build artifacts
  Write-Output "tgui: cleaning build artifacts"
  Remove-Quiet -Recurse -Force "public\.tmp"
  Remove-Quiet -Force "public\*.map"
  Remove-Quiet -Force "public\*.hot-update.*"
  Write-Output "tgui: cleaning Yarn artifacts"
  ## Yarn artifacts
  Remove-Quiet -Recurse -Force ".yarn\cache"
  Remove-Quiet -Recurse -Force ".yarn\unplugged"
  Remove-Quiet -Recurse -Force ".yarn\rspack"
  Remove-Quiet -Force ".yarn\build-state.yml"
  Remove-Quiet -Force ".yarn\install-state.gz"
  Remove-Quiet -Force ".yarn\install-target"
  Remove-Quiet -Force ".pnp.*"
  Write-Output "tgui: cleaning NPM artifacts"
  ## NPM artifacts
  Get-ChildItem -Path "." -Include "node_modules" -Recurse -File:$false | Remove-Item -Recurse -Force
  Remove-Quiet -Force "package-lock.json"
  Write-Output "tgui: All artifacts cleaned"
}

function Test-TguiDirty {
  $gitRoot = Join-Path $basedir ".."

  & git -C $gitRoot diff --quiet -- tgui
  if ($LASTEXITCODE -ne 0) {
    return $true
  }
  & git -C $gitRoot diff --cached --quiet -- tgui
  if ($LASTEXITCODE -ne 0) {
    return $true
  }
  $untracked = & git -C $gitRoot ls-files --others --exclude-standard -- tgui
  return [bool]$untracked
}

function Get-TguiTreeHash {
  $gitRoot = Join-Path $basedir ".."
  $tguiTreeHash = (& git -C $gitRoot rev-parse HEAD:tgui).Trim()
  Throw-On-Native-Failure
  return $tguiTreeHash
}

function Get-TguiBundleTreeHash {
  $marker = "public\.tgui-bundle.json"
  if (!(Test-Path $marker)) {
    return $null
  }
  try {
    return (Get-Content -Raw $marker | ConvertFrom-Json).tguiTreeHash
  } catch {
    return $null
  }
}

function Write-TguiBundleMarker {
  if (Test-TguiDirty) {
    Remove-Quiet -Force "public\.tgui-bundle.json"
    return
  }
  @{ tguiTreeHash = Get-TguiTreeHash } | ConvertTo-Json | Set-Content -Encoding utf8 "public\.tgui-bundle.json"
}

function task-build-production {
  task-install
  task-lint --fix
  task-setup
  task-rspack --mode=production
  Write-TguiBundleMarker
}

function task-ensure-bundle {
  $releaseUrl = "https://github.com/ss220club/Paradise-SS220/releases/download/tgui-bundles"

  if (Test-TguiDirty) {
    Write-Output "tgui: source changes detected; building TGUI locally"
    task-build-production
    return
  }

  $tguiTreeHash = Get-TguiTreeHash
  if ((Get-TguiBundleTreeHash) -eq $tguiTreeHash -and (Test-Path "public\tgui.bundle.js")) {
    Write-Output "tgui: using local bundle"
    return
  }

  $temporaryDirectory = "public\.tmp"
  $manifestPath = Join-Path $temporaryDirectory "tgui-manifest.json"
  $archivePath = Join-Path $temporaryDirectory "tgui-public.zip"
  New-Item -ItemType Directory -Force $temporaryDirectory | Out-Null
  try {
    Invoke-WebRequest -Uri "$releaseUrl/tgui-manifest.json" -OutFile $manifestPath
    $manifest = Get-Content -Raw $manifestPath | ConvertFrom-Json
    if ($manifest.tguiTreeHash -eq $tguiTreeHash -and $manifest.archiveName -eq "tgui-public.zip") {
      Invoke-WebRequest -Uri "$releaseUrl/$($manifest.archiveName)" -OutFile $archivePath
      $actualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
      if ($actualHash -eq $manifest.archiveSha256.ToLowerInvariant()) {
        Expand-Archive -Path $archivePath -DestinationPath $basedir -Force
        if ((Get-TguiBundleTreeHash) -eq $tguiTreeHash) {
          Write-Output "tgui: downloaded bundle"
          return
        }
      }
    }
  } catch {
    Write-Output "tgui: published bundle is unavailable or invalid"
  }

  Write-Output "tgui: no compatible published bundle; building TGUI locally"
  task-build-production
}

function task-editor-sdk () {
  yarn dlx @yarnpkg/sdks vscode
}

## Main
## --------------------------------------------------------

if ($Args.Length -gt 0) {
  if ($Args[0] -eq "--ensure") {
    task-ensure-bundle
    exit 0
  }

  if ($Args[0] -eq "--clean") {
    task-clean
    exit 0
  }

  if ($Args[0] -eq "--dev") {
    $Rest = $Args | Select-Object -Skip 1
    task-install
    task-dev-server @Rest
    exit 0
  }

  if ($Args[0] -eq "--lint") {
    $Rest = $Args | Select-Object -Skip 1
    task-install
    task-lint @Rest
    exit 0
  }

  if ($Args[0] -eq "--fix") {
    $Rest = $Args | Select-Object -Skip 1
    task-install
    task-lint --fix @Rest
    exit 0
  }

  ## Analyze the bundle
  if ($Args[0] -eq "--analyze") {
    task-install
    task-rspack --mode=production --analyze
    exit 0
  }

  ## Jest test
  if ($Args[0] -eq "--test") {
    $Rest = $Args | Select-Object -Skip 1
    task-install
    task-test @Rest
    exit 0
  }

  ## Continuous integration scenario
  if ($Args[0] -eq "--ci") {
    $Rest = $Args | Select-Object -Skip 1
    task-clean
    task-install
    task-prettier
    task-test @Rest
    task-lint
    task-setup
    task-rspack --mode=production
    Write-TguiBundleMarker
    exit 0
  }

  ## Run prettier
  if ($Args[0] -eq "--prettier") {
    $Rest = $Args | Select-Object -Skip 1
    npx prettier @Rest
    exit 0
  }

  if ($Args[0] -eq "--sdks") {
    task-editor-sdk
    exit 0
  }
}

## Make a production rspack build
if ($Args.Length -eq 0) {
  task-build-production
  exit 0
}

## Run rspack with custom flags
task-install
task-setup
task-rspack @Args
