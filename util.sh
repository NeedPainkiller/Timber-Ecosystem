#!/bin/bash

# 경로를 합치는 함수
join_paths() {
    local path1=$1
    local path2=$2

    # 슬래시 추가 및 중복 제거
    echo "$path1/$path2" | sed 's#/\+#/#g'
}

# 파일 존재여부 확인
is_file_exists() {
    local file_path=$1

    if [ -f "$file_path" ]; then
        echo "true"
    else
        echo "false"
    fi
}

# 파일 내용에서 원하는 "키"에 해당하는 "값" 추출
get_value() {
    local file_path=$1
    local key=$2

    value=$(grep "^$key=" "$file_path" | cut -d= -f2)
    echo "$value"
}

# 파일 내용에서 원하는 "키" 리스트 추출
get_keys() {
    local file_path=$1

    keys=$(grep -o "^[^=]\+=" "$file_path" | sed 's/=$//')
    echo "$keys"
}


# 컨테이너 시작
podman_compose_start(){
  # Check if podman-compose is installed
  if ! command -v podman-compose &> /dev/null; then
      echo "Error: podman-compose is not installed. Please install podman-compose."
      exit 1
  fi

  if [ $(is_file_exists "docker-compose.yml") = "false" ]; then
      echo "File not found: docker-compose.yml"
      exit 1
  fi

  # Start the containers
  echo "Starting containers..."
  podman-compose -f docker-compose.yml up --force-recreate -d
  echo "Containers started."
}


# 실행 중인 컨테이너를 확인하고 중단
podman_compose_stop(){
  # Check if podman-compose is installed
  if ! command -v podman-compose &> /dev/null; then
      echo "Error: podman-compose is not installed. Please install podman-compose."
      exit 1
  fi

  if [ $(is_file_exists "docker-compose.yml") = "false" ]; then
      echo "File not found: docker-compose.yml"
      exit 1
  fi

  # Check if there is a running container
  if podman-compose ps -q &> /dev/null; then
      echo "Containers are running."
  else
      echo "No containers are running."
  fi

  # Stop the running containers
  echo "Stopping containers..."
  podman-compose down
  echo "Containers stopped."
}


# podman secret 일괄 삭제
podman_secret_remove(){
  # Check if podman-compose is installed
  if ! command -v podman &> /dev/null; then
      echo "Error: podman is not installed. Please install podman."
      exit 1
  fi

  podman secret rm --all
}