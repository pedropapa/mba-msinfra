#Dockerfile para servidor web Flask para aplicações Python

FROM python:3.6.5-slim
MAINTAINER pedro.papadopolis@mbamobi.com.br

#Create vim alias
RUN echo "alias vi=vim" >> /root/.bashrc

RUN apt-get update

# Pacotes padrão
RUN pip install Flask -q \
    && pip install opencv-python -q \
    && pip install opencv-contrib-python -q \
    && pip install -U flask-cors -q \
    && apt-get install cmake -y \
    && apt-get install -y build-essential \
    && pip install face_recognition -q \
    && apt-get install curl -y \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install nodejs -y \
    && npm i forever -g

# Diretórios
RUN mkdir -p /var/source

#Ajust timezone
RUN rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#Container's start script
COPY scripts/start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
