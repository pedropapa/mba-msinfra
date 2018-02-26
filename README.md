# MS - Infraestrutura

Hospeda todas os serviços necessários para a execução dos aplicativos desenvolvidos para o Ministério da Saúde.

# Topologia

- Versão Community do Docker.
- Repositório das imagens: https://hub.docker.com/r/mbamobi
- Docker Swarm
	- Manager com Traefik para balanceamento de carga / servidor de proxy.
	- Worker para isolar serviços que exigem mais recursos. 

# Eventos - Gestor

Repositório: https://github.com/mbamobi/ms_eventos_gestor
API: https://api.mseventos.mbamobi.com.br/
Versão WEB: https://gestor.mseventos.mbamobi.com.br/

# Contribuindo

- Solicitar acesso às máquinas via chave rsa para a equipe do MS.
- Solicitar permissão para push neste repositório.
- Solicitar permissão para push de imagens no Docker Hub.
