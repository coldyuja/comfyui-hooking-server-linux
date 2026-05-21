FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    NO_BROWSER=1 \
    REAL_COMFY_HOST=host.docker.internal \
    REAL_COMFY_PORT=8188

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    libglib2.0-0 \
    libgl1 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x /app/run.sh \
    && mkdir -p \
      workflow \
      current_work \
      workflow_backup \
      frontend \
      logs \
      mode_workflow \
      current_mode_workflow \
      asset_data \
      asset \
      auto_complete \
      pose_data \
      chain_presets \
      key \
      customprompt

EXPOSE 8189

CMD ["python", "server.py"]
