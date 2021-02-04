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

Ao executar o script (duplo clique, no Windows), ele lerá os dados no arquivo `museu.xml` e irá gerar as páginas, salvar na pasta `html-out` e abrir a página inicial. A pasta `html-static` e o arquivo `museu.xml` precisam estar no mesmo diretório que o arquivo de script.
