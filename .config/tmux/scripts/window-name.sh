#!/bin/bash
# 获取当前 pane 的 pid
pane_pid="$1"

if [ -z "$pane_pid" ]; then
    echo ""
    exit 0
fi

# 递归查找进程树中的 docker exec 命令
find_docker_container() {
    local pid=$1
    local max_depth=10
    local depth=0

    while [ "$pid" != "1" ] && [ "$pid" != "" ] && [ $depth -lt $max_depth ]; do
        # 获取进程命令行
        local cmdline=$(cat /proc/$pid/cmdline 2>/dev/null | tr '\0' ' ')

        # 检查是否是 docker exec 命令
        if echo "$cmdline" | grep -q "docker exec"; then
            # 提取容器名称或ID
            # docker exec 的格式通常是: docker exec [options] container command
            local container=$(echo "$cmdline" | sed -E 's/.*docker exec[^a-zA-Z0-9_-]*([a-zA-Z0-9_-]+).*/\1/' | awk '{print $1}')
            if [ -n "$container" ] && [ "$container" != "docker" ]; then
                # 尝试获取容器的实际名称
                local name=$(docker inspect --format '{{.Name}}' "$container" 2>/dev/null | sed 's/^\///')
                if [ -n "$name" ]; then
                    echo "$name"
                else
                    echo "$container"
                fi
                return 0
            fi
        fi

        # 获取父进程 PID
        pid=$(cat /proc/$pid/stat 2>/dev/null | awk '{print $4}')
        ((depth++))
    done

    return 1
}

# 检查 pane 进程树
container_name=$(find_docker_container "$pane_pid")

if [ -n "$container_name" ]; then
    echo " $container_name"
else
    echo ""
fi
