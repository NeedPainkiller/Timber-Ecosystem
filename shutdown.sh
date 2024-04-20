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

echo "###############################################"
echo "##################CONTAINER###################"
echo "###############################################"

echo "Stopping containers..."
docker-compose -f "$compose_file" down
echo "Containers stopped."
echo "###############################################"

docker ps -a

echo "###############################################"

exit 0
