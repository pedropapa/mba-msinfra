# MS - Infraestrutura

Hospeda todas os serviços necessários para a execução dos aplicativos desenvolvidos para o Ministério da Saúde.

# Topologia

- Versão Community do Docker.
- Repositório das imagens: https://hub.docker.com/r/mbamobi
- Docker Swarm
	- Manager com Traefik para balanceamento de carga / servidor de proxy.
	- Worker para isolar serviços que exigem mais recursos.
- Jenkins para integração contínua.
- Sonar para avaliar qualidade do código (TODO).

# Gerenciamento
- Jenkins: https://ci.mseventos.mbamobi.com.br
- Traefik dashboard: https://lb.mseventos.mbamobi.com.br

# Serviços
- Referente aos aplicativos desenvolvidos para o Ministério da Saúde.
    # Mural de notificações
    - Dashboard: https://mural.ms.mbamobi.com.br/
    - API: https://mural-api.ms.mbamobi.com.br/
    
    # Eventos
    - API: https://api.mseventos.mbamobi.com.br/
        ## Gestor
        - Repositório: https://github.com/mbamobi/ms_eventos_gestor
        - Versão WEB: https://gestor.mseventos.mbamobi.com.br/
    
        ## Participante
        - Repositório: https://github.com/mbamobi/ms_eventos_participante
        - Versão WEB: https://participante.mseventos.mbamobi.com.br/
    
    # Parse Server
    - _TODO_

# Banco de dados
- Oracle: ms.mbamobi.com.br:1521
- MySQL: ms.mbamobi.com.br:3306

# Contribuindo
- Solicitar acesso às máquinas via chave rsa para a equipe do MS.
- Solicitar permissão para push neste repositório.
- Solicitar permissão para push de imagens no Docker Hub.
