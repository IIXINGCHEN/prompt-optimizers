<#
.SYNOPSIS
    同步上游 prompt-optimizer 仓库最新版本并推送到本仓库主分支
.DESCRIPTION
    1. 自动配置/更新 upstream 远程源
    2. 拉取 upstream 最新提交和 tags
    3. 同步最新上游分支到当前本地 main 分支
    4. 推送分支与 tags 到 origin
#>

[CmdletBinding()]
param(
    [string]$UpstreamUrl = "https://github.com/linshenkx/prompt-optimizer.git",
    [string]$UpstreamBranch = "develop",
    [string]$TargetBranch = "main",
    [switch]$ForcePush = $true
)

$ErrorActionPreference = "Stop"

Write-Host "=== 检查并配置 upstream 远程源 ===" -ForegroundColor Cyan
$remotes = git remote
if ($remotes -notcontains "upstream") {
    Write-Host "添加 upstream: $UpstreamUrl" -ForegroundColor Green
    git remote add upstream $UpstreamUrl
} else {
    git remote set-url upstream $UpstreamUrl
}

Write-Host "`n=== 获取 upstream 最新提交与 Tags ===" -ForegroundColor Cyan
git fetch upstream --tags --prune

Write-Host "`n=== 切换到 $TargetBranch 分支并同步 ===" -ForegroundColor Cyan
git checkout $TargetBranch

Write-Host "对齐到 upstream/$UpstreamBranch..." -ForegroundColor Yellow
git reset --hard "upstream/$UpstreamBranch"

Write-Host "`n=== 推送到 origin ===" -ForegroundColor Cyan
if ($ForcePush) {
    git push origin "$TargetBranch" --force
} else {
    git push origin "$TargetBranch"
}

Write-Host "推送所有 tags 到 origin..." -ForegroundColor Yellow
git push origin --tags

Write-Host "`n✔ 同步完成！当前 main 分支已成功对齐上游最新版本并推送至 origin。" -ForegroundColor Green
