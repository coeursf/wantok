# rename-to-lowercase.ps1

# 确保在 Git 仓库根目录执行
Write-Host "正在转换文件名为小写..."

# 获取所有文件（排除 .git 目录）
Get-ChildItem -Recurse -File | Where-Object { $_.FullName -notmatch '\\\.git\\' } | ForEach-Object {
    $originalPath = $_.FullName
    $lowerPath = $originalPath.ToLower()

    if ($originalPath -ne $lowerPath) {
        $repoRoot = git rev-parse --show-toplevel
        $relativeOriginal = Resolve-Path -Relative -Path $originalPath
        $relativeLower = Resolve-Path -Relative -Path $lowerPath

        # 转换为相对于 Git 根目录的路径
        $gitPathOriginal = $originalPath.Substring($repoRoot.Length + 1)
        $gitPathLower = $lowerPath.Substring($repoRoot.Length + 1)

        # 创建目标路径的目录（防止路径不存在）
        $targetDir = Split-Path $lowerPath
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }

        # 使用 git mv 重命名
        Write-Host "🔄 $gitPathOriginal -> $gitPathLower"
        git mv "$gitPathOriginal" "$gitPathLower"
    }
}

Write-Host "updated"