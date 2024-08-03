FROM condaforge/miniconda3

# 设置工作目录
WORKDIR /app

# 安装必要的系统包
RUN apt-get update && \
    apt-get install -y cron supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 创建一个目录来存放 Miniconda 环境
RUN mkdir -p /opt/miniconda && \
    chmod -R 777 /opt/miniconda

# 安装所需的 Python 包
COPY environment.yml .
RUN conda env create -f environment.yml

# 激活 conda 环境
ENV PATH="/opt/miniconda/envs/myenv/bin:$PATH"

# 复制应用代码到容器
COPY . .

# 创建 supervisord 配置文件
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# 创建定时任务配置文件
RUN echo "* * * * * /usr/bin/supervisorctl restart myapp" > /etc/cron.d/restart_myapp && \
    chmod 0644 /etc/cron.d/restart_myapp

# 确保 cron 服务可以在容器中运行
RUN mkdir -p /var/spool/cron/crontabs && \
    chmod 0700 /var/spool/cron/crontabs

# 启动 cron 服务和 supervisord
CMD ["cron", "-f"]
