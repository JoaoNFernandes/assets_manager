Asset Tree View Application

    Descrição do Projeto
        Este projeto é uma aplicação de visualização em árvore que mostra os ativos das empresas. A árvore é composta por componentes, ativos e localizações, oferecendo uma representação visual da hierarquia dos ativos de uma empresa.

    Funcionalidades
        Página Inicial:
            Menu de navegação entre diferentes empresas e acesso aos seus ativos.
        Página de Ativos:
            - Visualização dinâmica da estrutura de árvore com componentes, ativos e localizações.
            - Filtros:
                - Pesquisa por Texto: Busca específica de componentes/ativos/localizações.
                - Sensores de Energia: Isola sensores de energia dentro da árvore.
                - Status Crítico dos Sensores: Identifica ativos com status crítico dos sensores.
    
    Tecnologias Utilizadas
        Linguagem: Dart
        FrameWork: Flutter
        Bibliotecas:
            - flutter_bloc: ^8.1.6
            - dio: ^5.5.0+1

    Instalação
        1 - Clone o repositório:
        CMD/bash ==============================================================
            > git clone https://github.com/JoaoNFernandes/assets_manager
            > cd [assets_manager path]

        2 - Instale as dependências:
        CMD/bash ==============================================================
            > flutter pug get

    Execução
        1 - Configure um emulador no Android Studio;
        2 - Com o emulador devidamente configurado, na pasta do projeto, execute:
        CMD/bash ==============================================================
            > flutter run
    
    Uso
        A aplicação consistem em uma visualização de ativos de empresas e está dividida em duas Páginas.

        HomePage: Mostra as Companhias cadastradas
        AssetsPage:

    Demonstração em Vídeo
        [Link para o vídeo de demonstração]

    Melhorias Futuras
        Para melhorar a performance do aplicativo, planejo implementar as seguintes otimizações:

        1 - Carregamento Dinâmico dos Dados na Página de Ativos
            Implementar paginação no carregamento dos ativos e localizações, de forma que os dados sejam carregados dinamicamente conforme o usuário faz scroll para baixo. Isso reduzirá a carga inicial e melhorará a velocidade de resposta da aplicação.

        2 - Otimização de Filtros
            Atualmente, as funções de filtro foram implementadas com foco na funcionalidade básica. Muitas partes do código seguem padrões repetidos em diferentes funções. Planejo refatorar essas funções, criando métodos reutilizáveis que possam ser aplicados em várias partes do código, diminuindo a quantidade de código repetido e aumentando a eficiência do aplicativo.

        Além disso, tabém serão adicionadas páginas para exibir informações detalhadas das companhias, localizações, ativos e componentes.