#!/bin/bash

source util.sh

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose is not installed. Please install docker-compose."
    exit 1
fi


echo "###############################################"
echo "##################Service######################"
echo "###############################################"

# 서비스 목록
expected_service_name=("system" "application")

# 예상한 파라미터 값인지 확인하는 함수
param_is_expected() {
    local param="$1"
    for expected_param in "${expected_service_name[@]}"; do
        if [ "$param" == "$expected_param" ]; then
            return 0  # 예상한 파라미터가 발견됨
        fi
    done
    return 1  # 예상한 파라미터가 발견되지 않음
}

# 서비스 명 조회 (system | application)
service_name=$1

echo "service_name : $service_name"

# 파라미터가 비어 있는지 확인
if [ -z "$service_name" ]; then
    echo "사용법: $0 [서비스 명]"
    exit 1
fi

# 파라미터가 예상한 문자열 리스트에 있는지 확인
if ! param_is_expected "$service_name"; then
    echo "예상한 파라미터 값이 아닙니다."
    exit 1
fi

compose_file="docker-compose.$service_name.yml"

echo "compose_file : $compose_file"

# yml 파일이 존재하지 않으면 종료
if [ $(is_file_exists "$compose_file") = "false" ]; then
    echo "File not found: $compose_file"
    exit 1
fi


# 80,443 포트 사용을 위한 권한 설정 (테스트용)
#sudo sh -c "echo 0 > /proc/sys/net/ipv4/ip_unprivileged_port_start"

echo "###############################################"
echo "##################Profile######################"
echo "###############################################"

echo "UID : $UID | USER : $USER"

# linger 설정, 사용자 로그인 없이 서비스가 실행되도록 설정
loginctl enable-linger "$UID"

echo "###############################################"
echo "##################DIR & ENV####################"
echo "###############################################"

# 현재 경로 및 .secret 파일 조회
script_file_path=$(readlink -f "$0")
script_dir_path=$(dirname "$script_file_path")
env_file_name=".env"
env_file_path=$(join_paths "$script_dir_path" "$env_file_name")

echo "script_file_path : $script_file_path | script_dir_path : $script_dir_path"
echo "env_file_name : $env_file_name | env_file_path : $env_file_path"

# .env 파일이 존재하지 않으면 종료
if [ $(is_file_exists "$env_file_path") = "false" ]; then
    echo "File not found: $env_file_path"
    exit 1
fi

# .env 파일의 key-value를  출력
key_list=$(get_keys "$env_file_path")
echo $key_list
for key in $key_list; do
    value=$(get_value "$env_file_path" "$key")
    echo "KEY: $key"
    echo " ┗ $value"
done

echo "###############################################"
echo "##################CONTAINER###################"
echo "###############################################"

echo "Stopping containers..."
docker-compose -f "$compose_file" down
echo "Containers stopped."

echo "Starting containers..."
docker-compose -f "$compose_file" up --force-recreate -d
echo "Containers started."
echo "###############################################"

docker ps -a | grep timber

echo "###############################################"

exit 0
