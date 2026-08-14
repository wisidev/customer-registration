# Customer Registration

Aplicação desktop para cadastro e gerenciamento de clientes desenvolvida em Object Pascal utilizando a IDE Lazarus.

O projeto foi desenvolvido como parte de um desafio prático com o objetivo de aplicar conceitos de desenvolvimento desktop, manipulação de datasets, componentes visuais, eventos e organização de código utilizando boas práticas de desenvolvimento e versionamento.

## Funcionalidades

A aplicação permite:

- cadastrar novos clientes;
- visualizar clientes cadastrados em uma grade;
- editar clientes existentes;
- excluir clientes mediante confirmação;
- pesquisar clientes em tempo real;
- validar os campos obrigatórios;
- controlar dinamicamente os estados da interface;
- manipular os registros utilizando um dataset em memória.

Cada cliente possui os seguintes dados:

- ID;
- nome;
- CPF/CNPJ;
- telefone;
- e-mail;
- endereço.

## Tecnologias utilizadas

- Lazarus IDE
- Free Pascal / Object Pascal
- LCL (Lazarus Component Library)
- TBufDataset
- TDataSource
- TDBGrid
- Git
- GitHub

## Arquitetura e organização

Apesar de ser uma aplicação de pequeno porte, foi adotada uma separação de responsabilidades para evitar concentrar toda a lógica em um único formulário.

A aplicação foi organizada principalmente entre o formulário principal e um Data Module.

### TMainForm

O `TMainForm` é responsável pela interação com o usuário.

Entre suas responsabilidades estão:

- receber os dados informados nos campos;
- responder aos eventos dos botões;
- controlar o estado dos componentes da interface;
- carregar os dados do cliente selecionado;
- iniciar operações de inclusão, edição e exclusão;
- apresentar mensagens ao usuário;
- encaminhar a pesquisa ao Data Module.

### TdmCustomers

O `TdmCustomers` concentra os componentes e comportamentos relacionados aos dados.

Entre suas responsabilidades estão:

- criação do dataset;
- armazenamento temporário dos clientes;
- disponibilização dos dados por meio do `TDataSource`;
- aplicação do filtro de pesquisa;
- validação antes da confirmação de registros;
- tratamento de eventos do dataset;
- notificação da interface quando os dados são alterados.

Essa separação evita que o formulário seja responsável simultaneamente pela interface e por toda a infraestrutura de dados.

## Fluxo dos dados

A estrutura principal utilizada pela aplicação pode ser representada da seguinte maneira:

```text
TMainForm
    |
    v
TdmCustomers
    |
    v
TBufDataset
    |
    v
TDataSource
    |
    v
TDBGrid
```

O `TBufDataset` mantém os registros em memória.

O `TDataSource` atua como intermediário entre o dataset e os controles visuais orientados a dados.

O `TDBGrid` utiliza essa conexão para apresentar os registros ao usuário.

## Dataset em memória

Foi utilizado `TBufDataset` para representar a coleção de clientes.

Essa decisão atende ao escopo do desafio sem introduzir uma dependência desnecessária de um sistema gerenciador de banco de dados.

Como consequência, os dados existem apenas durante a execução da aplicação. Ao encerrar o programa, os registros armazenados em memória são perdidos.

Para uma aplicação real que exigisse persistência, o Data Module poderia posteriormente ser adaptado para utilizar um banco de dados sem exigir que toda a interface fosse reescrita.

## Operações CRUD

### Create

Ao selecionar a opção de novo cliente, o formulário:

1. limpa os campos;
2. entra no estado de inclusão;
3. habilita os campos necessários;
4. valida os dados informados;
5. cria um novo registro utilizando `Append`;
6. atribui os valores ao dataset;
7. confirma a operação utilizando `Post`.

O ID é gerado pela aplicação a partir do maior identificador existente no dataset.

### Read

Os registros armazenados no `TBufDataset` são disponibilizados ao `TDBGrid` através do `TDataSource`.

Dessa forma, alterações confirmadas no dataset são refletidas na grade sem a necessidade de preencher manualmente cada linha.

### Update

A aplicação diferencia inclusão e edição através do estado interno do formulário.

Ao selecionar um cliente e utilizar a opção de edição:

1. o registro corrente do dataset é identificado;
2. seus valores são carregados nos campos;
3. o formulário entra no modo de edição;
4. o dataset utiliza `Edit`;
5. os novos valores são atribuídos;
6. `Post` confirma a alteração.

O ID original é preservado durante a edição.

### Delete

A exclusão utiliza o registro corrente selecionado no `TDBGrid`.

Antes da remoção, a aplicação apresenta uma caixa de confirmação contendo o nome do cliente.

Somente após a confirmação é executado `Delete`.

Essa decisão reduz o risco de exclusões acidentais.

## Controle de estado da interface

A interface possui estados diferentes para evitar operações incompatíveis.

Quando não existe uma operação de inclusão ou edição em andamento, os campos de cadastro permanecem desabilitados.

Durante uma inclusão ou edição:

- os campos são habilitados;
- `Save` e `Cancel` ficam disponíveis;
- `New`, `Edit` e `Delete` são bloqueados conforme o estado da operação.

Além disso, `Edit` e `Delete` permanecem desabilitados quando não existem registros disponíveis.

Esse comportamento foi centralizado em métodos específicos para evitar repetição de regras de interface em vários eventos.

## Validação

Os campos obrigatórios são verificados antes da gravação.

A aplicação valida:

- nome;
- CPF/CNPJ;
- telefone;
- e-mail;
- endereço.

Também foi utilizada uma validação no evento `BeforePost` do dataset.

Essa abordagem cria uma segunda camada de proteção: mesmo que outro fluxo tente confirmar um registro diretamente no dataset, os campos obrigatórios ainda são verificados antes do `Post` ser concluído.

As validações implementadas correspondem ao escopo do desafio e verificam principalmente a presença dos valores. Validações semânticas completas de CPF, CNPJ, telefone e e-mail poderiam ser adicionadas em uma evolução do projeto.

## Pesquisa de clientes

A pesquisa é realizada em tempo real a partir do campo de busca.

O texto informado é encaminhado ao Data Module, que utiliza o mecanismo de filtragem do dataset.

A pesquisa considera:

- nome;
- CPF/CNPJ;
- telefone;
- e-mail;
- endereço.

A comparação utiliza busca parcial e não diferencia letras maiúsculas e minúsculas.

Quando o campo de pesquisa é limpo, o filtro é desativado e todos os registros voltam a ser exibidos.

A filtragem apenas controla quais registros são apresentados, sem excluir dados do dataset.

## Eventos do DataSet

Foram utilizados eventos do dataset para manter regras relacionadas aos dados próximas da estrutura responsável por armazená-los.

### BeforePost

Executado antes da confirmação de um registro.

É utilizado como uma camada adicional de validação dos campos obrigatórios.

### AfterPost

Executado depois que uma inclusão ou alteração é confirmada.

O evento notifica a interface sobre a mudança nos dados.

### AfterDelete

Executado depois da exclusão de um registro.

Também notifica a interface para que seus controles sejam atualizados.

### OnFilterRecord

Utilizado para decidir quais registros devem permanecer visíveis quando existe uma pesquisa ativa.

Cada registro é analisado e aceito quando algum dos campos pesquisáveis contém o texto informado.

## Comunicação entre Data Module e formulário

Para evitar que o Data Module dependa diretamente do formulário, foi utilizada uma notificação através de evento.

O Data Module disponibiliza `OnCustomerDataChanged`.

Quando ocorre uma alteração relevante, ele dispara essa notificação.

O formulário registra um método para responder ao evento e atualizar seus controles.

O fluxo pode ser resumido como:

```text
Alteração no dataset
        |
        v
AfterPost / AfterDelete
        |
        v
NotifyCustomerDataChanged
        |
        v
OnCustomerDataChanged
        |
        v
TMainForm atualiza a interface
```

Essa abordagem reduz o acoplamento entre a camada responsável pelos dados e a interface.

## Geração de identificadores

Como o projeto utiliza armazenamento em memória e não existe um banco de dados responsável por gerar chaves automaticamente, o ID é controlado pela aplicação.

Para determinar o próximo identificador, os registros são percorridos e o maior ID existente é identificado.

O próximo valor corresponde ao maior ID acrescido de uma unidade.

Durante essa operação, `DisableControls` e `EnableControls` são utilizados para evitar atualizações visuais desnecessárias enquanto o dataset é percorrido.

Essa estratégia é adequada ao escopo didático e ao armazenamento temporário utilizado pelo projeto. Em uma aplicação com banco de dados, a geração de identificadores normalmente seria responsabilidade do próprio banco.

## Tratamento de operações

Durante a gravação, as alterações são executadas dentro de um bloco `try...except`.

Caso ocorra uma exceção antes da confirmação da operação, `Cancel` é utilizado para cancelar o estado de edição ou inserção antes de propagar novamente o erro.

Isso reduz o risco de deixar o dataset em um estado intermediário após uma falha.

## Boas práticas consideradas

Durante o desenvolvimento foram consideradas práticas como:

- separação entre interface e gerenciamento de dados;
- métodos pequenos e com responsabilidades específicas;
- redução de código duplicado;
- nomenclatura consistente dos componentes e métodos;
- encapsulamento de comportamentos reutilizáveis;
- validação antes da gravação;
- confirmação antes de operações destrutivas;
- controle explícito do estado da interface;
- tratamento de exceções durante alterações no dataset;
- utilização de eventos para reduzir acoplamento;
- versionamento incremental com Git;
- desenvolvimento dividido em branches por responsabilidade.

O objetivo não foi adicionar complexidade desnecessária, mas estruturar o projeto de forma que cada decisão pudesse ser compreendida e justificada.

## Decisões de arquitetura

Uma das principais decisões foi não colocar todas as responsabilidades diretamente no `TMainForm`.

Embora isso fosse possível em um projeto pequeno, concentrar interface, armazenamento, filtro e eventos em uma única classe aumentaria o acoplamento e dificultaria futuras alterações.

Por esse motivo:

- `TMainForm` concentra interação e estado visual;
- `TdmCustomers` concentra gerenciamento dos dados;
- `TBufDataset` representa o armazenamento temporário;
- `TDataSource` conecta os dados aos componentes visuais;
- `TDBGrid` apresenta os registros.

Também foram criados métodos auxiliares para responsabilidades recorrentes, como:

- limpar os campos;
- habilitar e desabilitar campos;
- alterar o estado do formulário;
- verificar a existência de clientes;
- carregar o cliente selecionado;
- transferir valores do formulário para o dataset;
- calcular o próximo ID;
- atualizar os botões de ação.

Essa divisão torna o fluxo principal dos eventos mais legível.

## Versionamento

O desenvolvimento foi realizado de maneira incremental utilizando Git.

As funcionalidades foram separadas em branches específicas para permitir que cada etapa fosse implementada, testada e integrada individualmente.

Entre as etapas desenvolvidas estão:

```text
feature/project-setup
feature/customer-creation
feature/customer-update
feature/customer-deletion
feature/customer-filter
feature/dataset-events
refactor/code-quality
docs/project-documentation
```

Os commits utilizam mensagens em inglês e procuram seguir uma estrutura semântica, utilizando prefixos como:

```text
feat:
refactor:
chore:
docs:
```

Essa estratégia facilita a leitura do histórico e a identificação do objetivo de cada alteração.

## Utilização de Inteligência Artificial

A Inteligência Artificial foi utilizada como ferramenta de apoio durante o desenvolvimento, principalmente para:

- discutir alternativas de organização do projeto;
- auxiliar na utilização de componentes do Lazarus;
- revisar trechos de Object Pascal;
- analisar mensagens de compilação;
- sugerir refatorações;
- estruturar o fluxo de versionamento;
- revisar decisões de implementação;
- auxiliar na documentação técnica.

As sugestões não foram tratadas como código automaticamente correto. Cada alteração foi aplicada de forma incremental, compilada e testada antes de ser mantida no projeto.

## Dificuldades encontradas com IA

Um dos pontos relevantes durante o desenvolvimento foi perceber que sugestões tecnicamente plausíveis ainda precisam ser avaliadas dentro do contexto real da IDE e do estado atual do projeto.

Algumas orientações fornecidas durante o processo exigiram correções manuais.

Entre os casos encontrados estiveram:

- inconsistência entre o nome de um parâmetro na declaração e na implementação de um método;
- ausência inicial da declaração de um método auxiliar na classe;
- necessidade de ajustar a ordem de criação do Data Module e do formulário principal;
- dificuldades relacionadas à configuração visual dos campos persistentes do `TBufDataset`;
- necessidade de adaptar orientações genéricas ao comportamento da versão utilizada do Lazarus;
- ajustes no gerenciamento dos estados dos botões após operações no dataset.

Um exemplo importante ocorreu na inicialização da aplicação. O formulário principal utilizava informações do Data Module durante seu evento de criação, mas inicialmente o formulário era criado antes do Data Module. Isso provocou uma violação de acesso.

A solução foi analisar o ciclo de inicialização e garantir que o `TdmCustomers` fosse instanciado antes do `TMainForm`.

Esse processo reforçou que a IA foi utilizada como ferramenta de suporte e não como substituta da compilação, depuração, testes e análise do desenvolvedor.

## Processo de validação das sugestões da IA

Foi adotado um processo incremental:

```text
Sugestão
   |
   v
Análise
   |
   v
Implementação
   |
   v
Compilação
   |
   v
Teste
   |
   v
Correção ou refatoração
   |
   v
Versionamento
```

Quando uma sugestão gerava erro de compilação ou comportamento inesperado, a mensagem produzida pelo compilador ou pela aplicação era analisada antes de prosseguir.

Esse processo foi importante principalmente por se tratar de uma tecnologia com a qual havia menor familiaridade prévia.

## Dificuldades técnicas durante o desenvolvimento

Além das questões relacionadas à IA, o desenvolvimento exigiu maior atenção em alguns pontos específicos do Lazarus.

A configuração dos campos persistentes do `TBufDataset` e sua representação no `TDBGrid` exigiram entendimento da relação entre dataset, campos e componentes visuais.

Também foi necessário compreender melhor:

- o funcionamento do Object Inspector;
- a criação de eventos pela IDE;
- a relação entre arquivos `.pas` e `.lfm`;
- o ciclo de criação de Forms e Data Modules;
- os estados `dsEdit` e `dsInsert`;
- a diferença entre `Append`, `Edit`, `Post`, `Cancel` e `Delete`;
- o comportamento dos eventos do dataset.

Essas dificuldades foram resolvidas de forma incremental, utilizando compilação e testes frequentes.

## Como executar

### Requisitos

- Lazarus IDE;
- Free Pascal Compiler compatível com a versão do projeto.

### Execução

1. Clone ou faça o download do repositório.
2. Abra o arquivo do projeto no Lazarus.
3. Compile o projeto.
4. Execute a aplicação.

Também é possível utilizar o comando de execução disponibilizado pela própria IDE.

Como o armazenamento é feito em memória, a aplicação sempre inicia sem os clientes cadastrados em execuções anteriores.

## Limitações

A implementação atual possui algumas limitações intencionais relacionadas ao escopo do desafio:

- não existe persistência em banco de dados;
- os registros são perdidos ao encerrar a aplicação;
- CPF/CNPJ não possui validação matemática;
- telefone não possui validação de formato;
- e-mail possui apenas a validação definida no escopo atual;
- não existe autenticação ou controle de usuários;
- a geração de IDs ocorre localmente em memória.

Esses pontos não impedem o funcionamento do CRUD proposto, mas seriam considerados em uma aplicação destinada a produção.

## Possíveis melhorias futuras

Como evolução do projeto, poderiam ser implementados:

- persistência em SQLite ou outro banco de dados;
- validação completa de CPF e CNPJ;
- validação mais rigorosa de e-mail;
- máscaras para CPF/CNPJ e telefone;
- testes automatizados;
- ordenação dos registros;
- tratamento centralizado de exceções;
- separação adicional entre regras de negócio e interface;
- configuração externa de parâmetros;
- melhorias de acessibilidade e experiência do usuário.

## Considerações finais

Embora o escopo funcional seja simples, o projeto foi desenvolvido buscando aplicar práticas que também são relevantes em aplicações maiores.

O principal objetivo não foi apenas implementar operações CRUD, mas compreender a relação entre interface, dataset, eventos e gerenciamento de estado dentro do Lazarus.

A utilização de um Data Module, métodos auxiliares, eventos do dataset, controle de estado da interface, tratamento das operações e versionamento incremental permitiu estruturar a solução de forma mais organizada e compreensível.

A utilização de Inteligência Artificial também fez parte do processo de aprendizagem, sempre acompanhada de análise, compilação e validação das sugestões antes de sua incorporação ao projeto.