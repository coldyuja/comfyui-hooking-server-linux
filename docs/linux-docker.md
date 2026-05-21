# Linux / Docker 실행 가이드

이 브랜치는 Windows 전용 `run.bat` 대신 Linux와 Docker에서 실행할 수 있는 진입점을 추가합니다.

## 로컬 Linux 실행

```bash
sudo apt update
sudo apt install -y python3 python3-venv python3-pip libgl1 libglib2.0-0 libgomp1

chmod +x run.sh
NO_BROWSER=1 REAL_COMFY_HOST=127.0.0.1 REAL_COMFY_PORT=8188 ./run.sh
```

서버는 `0.0.0.0:8189`에서 실행됩니다.

## Docker Compose 실행

ComfyUI가 호스트 머신에서 `8188` 포트로 실행 중이면 기본 설정 그대로 사용할 수 있습니다.

```bash
mkdir -p workflow current_work workflow_backup workflow_backup_static logs \
  mode_workflow current_mode_workflow asset_data asset auto_complete \
  pose_data chain_presets key customprompt

# config.json이 없으면 컨테이너 시작 시 기본값으로 생성됩니다.
docker compose up --build
```

접속:

```text
http://127.0.0.1:8189/
```

ComfyUI가 다른 호스트에 있으면 다음처럼 지정합니다.

```bash
REAL_COMFY_HOST=192.168.0.10 REAL_COMFY_PORT=8188 docker compose up --build
```

## 주요 변경점

- `run.sh` 추가: Linux용 venv 생성, 의존성 설치, 서버 실행
- `Dockerfile` 추가: Python 3.11 slim 기반 컨테이너 빌드
- `docker-compose.yml` 추가: 데이터 디렉토리를 호스트 볼륨으로 유지
- `sitecustomize.py` 추가: `NO_BROWSER=1`일 때 headless 환경에서 브라우저 자동 실행 방지
- `opencv-python`을 `opencv-python-headless`로 변경

## 주의 사항

`config.json`을 Windows 환경에서 가져온 경우 `C:\...` 형태의 절대 경로는 Linux/Docker에서 유효하지 않습니다. 다음 항목들은 Linux 경로 또는 컨테이너 내부 경로(`/app/...`)로 다시 지정해야 합니다.

- `comfy_workflow_source_path`
- `outfit_workflow_source_path`
- `asset_workflow_source_path`
- `backup_base_dir`
- `dwpose_det_model`
- `dwpose_pose_model`
- `dwpose_model_cache_dir`

GPU에서 DWPose ONNX를 사용하려면 `requirements.txt`의 `onnxruntime`을 환경에 맞게 `onnxruntime-gpu`로 바꿔 빌드하세요.
