# Museu das Migrações

Trabalho Final da disciplina de Linguagens de Marcação Extensíveis

Para gerar uma versão em HTML, utilize o comando

```powershell
(ConvertFrom-Markdown .\README.md).Html | Out-File .\README.html
```

## Powershell

O PowerShell é uma estrutura multiplataforma de gerenciamento de configuração e de automação de tarefas, que consiste em um shell de linha de comando e em uma linguagem de script. [Documentação](https://docs.microsoft.com/pt-br/powershell/scripting/overview)

### Instalação

>O Windows 10 já vem com o Powershell 5.1 instalado

[Download](https://github.com/PowerShell/PowerShell/releases/latest)

[Instruções de instalação](https://docs.microsoft.com/pt-br/powershell/scripting/install/installing-powershell)

### Habilitar execução de scripts

Por padrão, a execução de scripts vem desativada no Windows (`Restricted`) e requer confirmação (`Unrestricted`) em outros sistemas. Para ignorar essa verificação (somente Windows), utilize a opção `Bypass`.

Abra o Powershell como administrador e execute o comando

```powershell
Set-ExecutionPolicy -ExecutionPolicy <OPTION>
```

## Generate pages

Ao executar o script (`.\generate-pages`), ele lerá os dados no arquivo `museu.xml` e irá gerar as páginas e salvar na pasta `html-out`. A pasta `html-static` e o arquivo `museu.xml` precisam estar no mesmo diretório que o arquivo de script.

Para acessar a página, pode utilizar o comando `.\http-server` para iniciar um servidor HTTP e acessar os arquivos. A página inicial será aberta no navegador padrão. Se necessário, pode especificar a porta com o parâmetro `-Port <PORTA>`.

## Entrega

1. Tranformação do dump da base de dados em um formato compatível com `Museu.xsd`
   - `Museu.xsl`
   - `Museu.xml`
2. Geração das páginas web (arquivo ZIP)
   - `generate-pages.ps1` (script para geração das páginas)
   - `http-server.ps1` (servidor HTTP)
   - `html-static` (conteúdo estático)
       - `index.html` (página inicial/redirecionamento)
       - `page.xsl` (layout padrão)
       - `page.xsd` (esquema padrão)
       - `home.xml` (menu e informações do museu)
       - `styles.css` (folha de estilos)
       - Imagens do museu
         - `img1.jpg`
         - `img2.jpg`
         - `img3.jpg`
3. Questões de XSL/XQuery
   - `questoes.xsl`
   - `questoes.xml`
