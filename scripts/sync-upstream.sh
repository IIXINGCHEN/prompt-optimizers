#!/usr/bin/env bash
set -euo pipefail

# 同步上游 prompt-optimizer 仓库最新版本并推送到本仓库主分支
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/linshenkx/prompt-optimizer.git}"
UPSTREAM_BRANCH="${UPSTREAM_BRANCH:-develop}"
TARGET_BRANCH="${TARGET_BRANCH:-main}"

echo "=== 检查并配置 upstream 远程源 ==="
if ! git remote | grep -q "^upstream$"; then
    echo "添加 upstream: ${UPSTREAM_URL}"
    git remote add upstream "${UPSTREAM_URL}"
else
    git remote set-url upstream "${UPSTREAM_URL}"
fi

echo -e "\n=== 获取 upstream 最新提交与 Tags ==="
git fetch upstream --tags --prune

echo -e "\n=== 切换到 ${TARGET_BRANCH} 分支并同步 ==="
git checkout "${TARGET_BRANCH}"
echo "对齐到 upstream/${UPSTREAM_BRANCH}..."
git reset --hard "upstream/${UPSTREAM_BRANCH}"

echo -e "\n=== 推送到 origin ==="
git push origin "${TARGET_BRANCH}" --force
echo "推送所有 tags 到 origin..."
git push origin --tags

echo -e "\n✔ 同步完成！当前 ${TARGET_BRANCH} 分支已成功对齐上游最新版本并推送至 origin。"
