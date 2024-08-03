# 使用官方的 slim 镜像作为基础
FROM python:3.11-slim

# 更新包列表
RUN apt-get update && apt-get upgrade -y

# 安装 Supervisor 和 cron
RUN apt-get install -y supervisor cron

# 设置工作目录
WORKDIR /app

# 复制应用代码到容器
COPY . /app

# 安装应用所需的 Python 包
RUN pip install --no-cache-dir -r requirements.txt

# 设置 Supervisor 配置文件
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# 设置定时任务配置文件
COPY crontab /etc/cron.d/crontab

# 设置环境变量
ENV CRON_TZ=UTC

# 启动 Supervisor 和 cron
CMD ["/usr/bin/supervisord", "-n"]

# 确保 Supervisor 和 cron 在容器启动时运行
ENTRYPOINT ["cron", "-f", "&", "/usr/bin/supervisord", "-n"]

# 允许外部访问
EXPOSE 8000
