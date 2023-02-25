#使用 python:3.7-slim 做基础镜像减少大小。其中tensorflow再用另外的镜像跑数据。

# 之前使用的是python:3.6-slim
# 可以更新 3.7-slim-stretch slim-stretch

# https://hub.docker.com/_/python?tab=tags&page=1&name=3.7-slim-stretch
# 用这个做为基础镜像，防止每次都进行构建。

FROM docker.io/python:3.7-slim-stretch

# https://opsx.alibaba.com/mirror
# 使用阿里云镜像地址。修改debian apt 更新地址，pip 地址，设置时区。
echo  "[global]\n\
trusted-host=mirrors.aliyun.com\n\
index-url=http://mirrors.aliyun.com/pypi/simple" > /etc/pip.conf && \
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

RUN echo "rebuild docker @2022-01-12"
RUN mkdir -p /data/stock && mkdir -p /data/log && mkdir -p /data/stat
#增加语言utf-8
ENV LANG=zh_CN.UTF-8
ENV LC_CTYPE=zh_CN.UTF-8
ENV LC_ALL=C
ENV PYTHONPATH=/data/stock



# 设置 vim 的语言配置
RUN mkdir -p /etc/vim/ && \
    echo "set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936" >> /etc/vim/vimrc && \
    echo "set termencoding=utf-8" >> /etc/vim/vimrc && \
    echo "set encoding=utf-8" >> /etc/vim/vimrc


RUN apt-get update && apt-get install -y  gcc make python3-dev cron  && \
    pip3 install numpy==1.21.6  && \
    pip3 install pandas==1.3.5 && \
    pip3 install akshare==1.8.96 && \
	pip3 install stockstats==0.5.2 && \
    apt-get --purge remove -y gcc make python3-dev

# /usr/local/lib/python3.7/site-packages/pandas/
# 1.解决 pandas 数据插入问题。直接修改数据库驱动 sqlalchemy
# 修改：statement.replace("INSERT INTO","INSERT IGNORE INTO")
# /usr/local/lib/python3.7/site-packages/sqlalchemy/dialects/mysql/mysqldb.py
# 增加了一个 IGNORE 参数。
# 2.解决torndb在python3下面的问题：
# http://blog.csdn.net/littlethunder/article/details/8917378
# 3. 解决 type 问题，使用sed 进行替换。
#  File "/usr/local/lib/python3.7/site-packages/torndb.py", line 260, in <module>
#    CONVERSIONS[field_type] = [(FLAG.BINARY, str)] + CONVERSIONS[field_type]
#  TypeError: can only concatenate list (not "type") to list




