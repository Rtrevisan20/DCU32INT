# DCU32INT

**Parse de arquivos `.dcu`/`.dcp` do Delphi e Kylix e conversão para uma forma próxima ao Pascal.**

- **Autor original:** Alexei Hmelnov
- **Versão:** 1.20.1 (VerInfo 1.20.1.96)
- **Contato:** alex@icc.ru
- **Home page:** http://hmelnov.icc.ru/DCU/
- **Licença:** "as-is", sem garantias — ver [Licença](#licença)

---

## O que é

O `DCU32INT` (DCU32 **INT**erface) é um utilitário **de linha de comando** (console) que analisa arquivos `.dcu` (e `.dcp`) das seguintes versões e converte as informações neles contidas para uma forma **próxima ao Pascal**:

| Plataforma | Versões do Delphi |
|---|---|
| Delphi | 2.0–8.0, 2005–2006 (.NET e WIN32), 2007–2010 (WIN32), XE (WIN32), XE2–XE3 (WIN32, WIN64, OSX32), XE4–XE5 (WIN32, WIN64, OSX32, iOS simulator, iOS device — sem código, Android — sem código) |
| Kylix | 1.0–3.0 |

O programa **não** reconstrói o código-fonte Pascal completo — mas a interface da unit extraída é quase correta (veja a seção [Limitações](#limitações)).

O `DCU32INT` nasceu como um subproduto do projeto [FlexT](http://hmelnov.icc.ru/FlexT/).

> Esse repositório é um **fork dual-IDE**: o mesmo código-fonte compila e roda **identicamente no Delphi e no Lazarus (FPC)** — ver [Build (Dual IDE)](#build-dual-ide-delphi--lazarusfpc) e [Mudanças desta branch](#mudanças-desta-branch).

---

## Uso

```
DCU32INT <Arquivo fonte> <Flags> [<Arquivo destino>]
```

- O arquivo destino pode conter `*` para ser substituído pelo nome da unit (ou nome+extensão).
  - Se `*` for o último caractere, é substituído por `<Nome da unit>.int`; caso contrário, por `<Nome da unit>`.
  - Destino `-` escreve na saída padrão (stdout).
- Chame com `-?` ou `-h` para a ajuda rápida.

### Duas formas principais de uso

1. **Sem** o flag `-S`: produz a saída mais próxima do Pascal original, sem detalhes supérfluos (o uso recomendado para inspeção).
2. **Com** o flag `-S`: mostra uma grande quantidade de informação adicional que reflete a estrutura interna do arquivo DCU (valores de campos de propósito desconhecido, VMT de classes, RTTI de tipos, tabela de endereços etc.). Também é possível selecionar um subconjunto com `-S<flags>`.

### Flags

#### `-S<show flag>` — mostrar informações

Default: `(+)` = ligado, `(-)` = desligado. `-S` sozinho = mostra tudo.

| Flag | Descrição |
|---|---|
| `A(-)` | Mostra a tabela de endereços (Address table) |
| `C(-)` | Não resolve valores constantes |
| `D(-)` | Mostra o bloco de dados (Data block) |
| `d(-)` | Mostra tipos de pontos (dot types) |
| `F(-)` | Mostra fixups |
| `H(+)` | Mostra strings heurísticas |
| `I(+)` | Mostra nomes importados |
| `L(-)` | Mostra tabela de variáveis locais |
| `M(-)` | Não resolve métodos de classes |
| `O(-)` | Mostra offsets do arquivo |
| `S(-)` | Mostra o argumento `Self` de métodos e a 2ª call flag de construtores/destrutores |
| `T(-)` | Mostra a tabela de tipos |
| `U(-)` | Mostra units dos nomes importados |
| `V(-)` | Mostra valores auxiliares |
| `v(-)` | Mostra VMT |

#### `-O<option>` — opções de geração de código

| Opção | Descrição |
|---|---|
| `V(-)` | Constantes tipadas como variáveis |

#### Outras flags

| Flag | Descrição |
|---|---|
| `-I` | Somente parte de interface |
| `-U<paths>` | Diretórios de units; `*` significa autodetecção pela versão da unit |
| `-P<paths>` | Diretórios de fontes Pascal (apenas `-P` = "procura por `*.pas` no diretório da unit"). Sem este parâmetro, as linhas de `src` não são reportadas |
| `-R<Alias>=<unit>[;<Alias>=<unit>]*` | Define aliases de units |
| `-F<FMT>` | Formato de saída: `T` (texto, default), `H` (HTML) |
| `-N<Prefix>` | Sem prefixo de nome (`%` = caractere de escopo) |
| `-D<Prefix>` | Prefixo de nome por ponto (`%` = caractere de escopo) |
| `-Q<flag>` | Consultar informações adicionais: `F(-)` campos de classe, `V(-)` métodos virtuais de classe |
| `-A<Mode>` | Modo do disassembler: `S(+)` sequencial simples (toda memória é uma sequência de ops), `C(-)` control flow |

- O caractere de escopo é substituído no nome por `T` (tipos), `C` (constantes) etc. (ver fonte para detalhes).
- Exemplos de execução em cascata sobre o `LIB`: arquivos `alllib<N>.bat`.

---

## Validade

O `DCU32INT` passou com sucesso no teste "parse all `.\LIB`" para todas as versões de Delphi e Kylix suportadas — ou seja, analisou todas as units do diretório `<DELPHI LOCATION>\LIB` sem erros. Veja os arquivos `alllib<N>.bat` para exemplos de como rodar o `DCU32INT` sobre todo o `LIB`.

Esse sucesso não significa, porém, que a especificação do formato DCU esteja absolutamente correta. Bug reports são bem-vindos (veja a seção [Home page](#home-page)).

---

## Limitações

Há dois tipos de limitação do `DCU32INT`:

1. As causadas por deficiências da implementação, que podem ser superadas depois;
2. As causadas por **perda de informação** no DCU após a compilação do Pascal, que são inevitáveis.

Ao converter o Pascal para DCU, o compilador extrai e armazena apenas as informações necessárias para gerar o executável (e, se pedido, as informações de debug). Durante esse processo, o compilador aplica simplificações que causam perda de informação. Exemplos:

1. **Identificadores descartados** — identificadores perdidos em `implementation` e sub-rotinas quando o "debug info" não está marcado.
2. **Avaliação de expressões** — expressões constantes são substituídas por seus valores (ex.: `CDM_FIRST = WM_USER+100` vira `$0464`).
3. **Resolução de tipos renomeados** — tipos como `THandle = integer` são substituídos pelo tipo de referência (`System.Integer`).
4. **Merge de campos em records com variantes** — a informação sobre os *case labels* se perde completamente.

Essas limitações podem ser demonstradas pelo navegador e pelo avaliador do Delphi (que também as têm).

> O código Pascal extraído pode causar problemas se usado em uma versão do Delphi diferente da que gerou o DCU.

---

## Templates de código e codificação inline

Delphi 2009+ suportam procedimentos `inline` e *code templates*. A informação necessária para chamar um procedimento inline (inserindo seu código no local da chamada) é codificada nos records `drConstAddInfo`. Até agora, tudo o que se sabe sobre essa codificação é como **pular seus dados com segurança**.

O encoding inline pode ser ignorado facilmente porque o compilador pode decidir chamar um procedimento inline como um procedimento comum — logo, os procedimentos inline também têm código regular, que é o que o `DCU32INT` usa para mostrar o algoritmo.

Já os algoritmos dos **templates** são armazenados somente com o encoding inline. Os arquivos `Generics.Collections.dcu` e `Generics.Defaults.dcu` contêm exemplos desse caso; por isso os algoritmos de template não podem ser exibidos pela versão atual. Ficaria muito agradecido se alguém fizesse essa análise.

> Além dos templates, o DCU contém todas as **instanciações** dos templates após a substituição dos tipos de dados utilizados no arquivo. Os tipos com parâmetros substituídos são denotados por nomes com \` e dígitos no lugar dos parâmetros `<>`. Idealmente eles seriam escondidos (para ficar mais próximo do código original), mas a versão atual os exibe — por serem interessantes e ajudarem a entender como os templates funcionam.

---

## Build (Dual IDE: Delphi + Lazarus/FPC)

> **Lição importante (`-Mdelphi` sempre):** no FPC, `{$MODE DELPHI}` no `.dpr` **NÃO propaga** para as units — cada unit é compilada no próprio mode. Por isso o `-Mdelphi` é **obrigatório** em qualquer build FPC (via `CustomOptions` no `.lpi` ou pela linha de comando).

### Requisitos

- **Delphi:** Delphi 11/12 (Win32) — testado com o **Delphi 11 Architect** (`Studio\22.0`) e o Delphi 12 Community. **Não usar Delphi 13 para buildar** (dá `E1030`/problemas de `WRITEABLECONST`).
- **Lazarus/FPC:** FPC 4.8 (Win32/Win64) — testado com o **Lazarus 4.8**.
- **Nenhuma GUI/VCL** é usada — o utilitário é 100% console, sem componentes de terceiros.

### Build no Delphi

Via IDE: abra `Packages\Delphi\dcu32int.dproj` e compile (F9/Ctrl+F9).

Via MSBuild (o `.dproj` já define `I64`):

```bat
msbuild Packages\Delphi\dcu32int.dproj /t:Build /p:Config=Debug /p:Platform=Win32
```

Equivalente direto com `dcc32` (de `Packages\Delphi`):

```bat
dcc32 -dI64 -NSsystem;winapi -U"..\..\src" dcu32int.dpr
```

### Build no Lazarus/FPC

Via IDE: abra `Packages\Lazarus\dcu32int.lpi` e compile (Ctrl+F9). O `.lpi` já traz `-Mdelphi -dI64` e o caminho de busca para `..\..\src`.

Via `lazbuild`:

```bat
lazbuild Packages\Lazarus\dcu32int.lpi
```

Via `fpc` direto (da raiz do repositório):

```bat
fpc -Mdelphi -dI64 -Fu"src" Packages\Delphi\dcu32int.dpr
```

Ou use o script pronto:

```bat
Scripts\build_lazarus.bat
```

### Saída idêntica

Os arquivos `.int` (e `.htm`) são **byte-idênticos** entre os binários gerados pelo Delphi e pelo FPC (para os mesmos DCUs), incluindo o rodapé `Decompiled by DCU32INT Version: 1.20` — o build FPC embute o mesmo recurso de versão (`Packages\Delphi\dcu32int_fpc.res`).

### Validação (builds testados)

| Compilador | Versão | Resultado |
|---|---|---|
| Delphi | 11 Architect (`Studio\22.0`) | ✅ build do `.dproj` limpo |
| Lazarus/FPC | 4.8 | ✅ build do `.lpi` limpo |
| Paridade de output | — | ✅ `.int` **idêntico** nos 5 DCUs de teste reais do Delphi 11 |

### Avisos na saída do parse

| Aviso | O que é | É problema? | Como sumir |
|---|---|---|---|
| `Warning at 0x…: Skipped embedded lists N..M` | Desde o XE, tipos locais de procedures são gravados **fora** da lista da procedure (`RegisterEmbeddedTypes`, `DCU32.pas`). O parser prevê listas embutidas e, ao terminar, se a profundidade atual < máxima registrada, sobram listas não drenadas → `Skipped embedded lists N..M`. O endereço `0x…` **varia conforme o DCU** de entrada. | **Não** — heurística benigna do formato pós-XE; aparece igualmente no build Release. | Não há como nem porquê |
| `Warning: used unit "SysInit" not found or incorrect - all imported names will be shown with unit names` | Validação dos imports: para cada unit em `uses`, o parser procura a `TUnit` carregada; o `System.dcu` usa `SysInit` (init do RTL) e ela não foi carregada → aviso + nomes importados exibidos como `SysInit.Nome`. | **Só cosmético** — o `.int` sai completo. | Rodar com `-U` apontando o lib do Delphi (ex.: `-U"C:\Program Files (x86)\Embarcadero\Studio\22.0\lib\win32\release"`). O `SysInit.dcu` **existe** no disco; sem path configurado a busca `GetDCUByName` não o encontra. |

> **Nota:** DCUs de Delphi **13 (Studio 37)** ainda **não** são suportados — o magic do 13 (`0x2500034D`) foi identificado, mas as tags novas do formato (ex.: `Unexpected Tag=0x17` em `TConstAddInfoRec`) ainda não foram decodificadas.

---

## Mudanças desta branch

Este repositório é um fork com **compilação dual-IDE (Delphi + Lazarus/FPC)** usando o **mesmo código-fonte** — sem fork separado. Todos os ajustes de port são guardados por `{$IFDEF FPC}` (ou diretivas neutras para os dois compiladores) e **não alteram o comportamento do Delphi**.

### O que foi feito

1. **Análise de dependências** — verificado que o código é ~100% RTL puro (apenas `SysUtils`, `Classes` e o bloco de registro do Windows em `DCUTbl.pas`), sem VCL/FMX/GUI, threads ou componentes de terceiros. Veredito: port de baixo esforço.

2. **Reorganização de pastas** — fonte movido para `src/`, ícones/recursos para `resources/`, scripts para `Scripts/`, e projetos nas pastas `Packages\Delphi\` / `Packages\Lazarus\`.

3. **Projeto Lazarus criado** — `Packages\Lazarus\dcu32int.lpi` (console, sem LCL/IDEIntf), com `-Mdelphi -dI64` e busca de units apontando para `src`.

4. **Fixes de port FPC** (compile-and-fix, guardados `{$IFDEF FPC}` ou neutros):
   - Aritmética de ponteiros em `DAsmUtil.pas` (typecasts não portáveis).
   - Sentinela `-1` em `DCU32.pas` via `PtrUInt`.
   - Set duplicado em `DCURecs.pas` (resultado idêntico).
   - `case SizeOf(...)` duplicados (`Extended`=`Real`=`Double=8` no FPC win64).
   - Typecast de tamanho diferente em `DCURecs.pas`.
   - `StrLEnd` e `SAR` em `DCU_In.pas` (assembler 32-bit → Pascal portável).
   - VersionInfo do rodapé via `dcu32int_fpc.res` (paridade de output).
   - `GetRegVarInfo` passou de `const` para `var` (compatível com o `{$WRITEABLECONST}` OFF do Delphi 12+).

5. **Limpeza de warnings/hints** — suprimidos em massa os lotes pré-existentes do upstream (comparações signed/unsigned, conversões implícitas de string, hints de variáveis não usadas etc.) por unit, com `{$WARNINGS OFF}`/`{$HINTS OFF}` (Delphi) e `{$WARNINGS OFF}`/`{$NOTES OFF}` (FPC). Alguns avisos reais foram **corrigidos de verdade** (ex.: `StrEnd` deprecado, `Cardinal<0` sempre falso, `CharInSet`).

### Status

- ✅ **Compila e roda nas duas IDEs** — Delphi 11/12 (Win32) e Lazarus/FPC 4.8 (Win32/Win64).
- ✅ **Output `.int`/`.htm` idêntico** entre os binários Delphi e FPC.
- ✅ Builds das IDEs validados pelo usuário (Delphi 11 Architect e Lazarus 4.8).
- ✅ Sem features descartadas — o utilitário é determinístico e console-puro.
- ⏳ Suporte a DCUs de Delphi 13 (Studio 37) — em análise.

---

## Histórico do upstream

### Versão 1.18.1
1. Suporte a units do Delphi XE5 (sem mudanças de formato desde o XE4 além dos magic numbers).
2. O código real de units Android (`.o` ELF) não é processado ainda.

### Versão 1.17.1
1. Suporte a units do Delphi XE4.
2. Código real de units iOS device (`.o` Mach-O) não é processado ainda.
3. Novo flag `-Q` — tabelas de campos de classe (com offsets) e métodos virtuais (com offsets de VMT).
4. Constantes `UnicodeString` exibidas corretamente.

### Versão 1.16.1
1. Suporte a units do Delphi XE3.
2. Fonte portado de D3 para XE2 (compila em versões Unicode do Delphi).
3. Processamento mais correto de listas embutidas (`drEmbeddedProcStart`/`drEmbeddedProcEnd`) — thanx a Crypto.
4. Referências a arquivos de origem decodificadas por busca de índice (não por números ordinais).

### Versão 1.15.1
1. Suporte a units do Delphi XE2.
2. Disassembler Intel 64 adicionado; suporte a WIN64 e OSX32.
3. `PName` trocado de `PShortString` para a estrutura `TNameRec` (strings longas, >255 bytes, possíveis desde D2009).
4. Detecção dos campos auxiliares de propriedades do tipo `property X: Integer read FP.X`.
5. Flag de autodetecção de biblioteca `-U*` (ligado por default; use `-U` ou `-U<path>` para desligar).

### Versão 1.14.1
1. Suporte a units do Delphi XE.
2. Tratamento do problema "orphaned types" do XE — implementado `TDCURec.EnumUsedTypes`.
3. Tipos órfãos não vinculados a seus procedimentos são colocados na lista de declarações globais.

### Versão 1.13.1
1. Suporte a units do Delphi 2009 e 2010.
2. Processamento corrigido de referências futuras de endereços ainda não definidos (tag `drProcAddInfo`).

### Versão 1.10.2
1. Saída HTML (flag `-FH`) com marcação de sintaxe e hiperlinks.
2. Diversas correções (créditos a Josef Grosch): visibilidade de membros de classe (v8+), modificadores `overload`/`inline` (v9+), `resourcestring`, marcadores de visibilidade, `DecimalSeparator = '.'`.

### Versão 1.10.1
1. Exibição de possíveis strings inline constantes (desligue com `-SH`).
2. Argumentos `Self` e 2ª call flags de construtores/destrutores ocultos (mostre com `-SS`).
3. Procedimentos auxiliares falsos de constantes string gigantes marcados como `JustData` (não são desassemblados).

### Versão 1.10.0
1. Units do Delphi 2006 (WIN32) analisadas com sucesso.

### Versão 1.9.0
1. Units do Delphi 2005 (WIN32, .NET) analisadas com sucesso.

### Versão 1.8.0
1. Disassembler genérico implementado — registre novos disassemblers com `SetDisassembler(ReadCommand, ShowCommand, CheckCommandRefs)`.
2. Disassembler MSIL (Microsoft Intermediate Language) para código .NET.
3. Units do Delphi 8.0 analisadas com sucesso.

### Versão 1.7.4
1. Análise de control flow para o disassembler (opção `-AC`).

### Versão 1.7.3
1. Units do Delphi 7.0 analisadas com sucesso.

### Versão 1.7.2
1. Units do Kylix 3.0 open analisadas com sucesso.

### Versão 1.7.1
1. Units do Kylix 3.0 analisadas com sucesso.

### Versão 1.7.0
1. Algumas units do Delphi 7.0 trial analisadas com sucesso.

### Versão 1.6.4
1. Corrigido problema com seções `resourcestring` dentro de procedimentos.

### Versão 1.6.3
1. Corrigido problema com certos campos de header do Kylix — confirmado apenas para os exemplos de DCUs Kylix disponíveis. Por favor, envie DCUs que ainda não sejam analisadas.

### Versão 1.6.2
1. Suporte a units do Kylix 2.0 (apenas mudança de assinatura de arquivo detectada).

### Versão 1.6.1
1. O fonte agora compila sob Kylix.
2. Units de usuário compiladas sob Kylix têm outra estrutura de header que as do LIB; o programa foi corrigido para levar isso em conta.

### Versão 1.6.0
1. Suporte a units do Delphi 6.0 e Kylix 1.0 (testado em `.\\LIB\\*.dcu`).
2. Tipos de alguns campos esclarecidos (bytes que são, na verdade, índices).
3. Processadas tabelas adicionais do final do DCU — números de linha no código desassemblado (quando presentes).

---

## Home page

A versão mais recente do programa e as novidades relacionadas estão em http://hmelnov.icc.ru/DCU/

Por favor, envie bug reports (incluindo as units que não foram analisadas corretamente) para **alex@icc.ru**, verificando antes:

1. que você tem a versão mais recente do `DCU32INT`;
2. que o bug ainda não foi reportado em http://hmelnov.icc.ru/DCU/FAQ.htm.

---

## Colaboração

Se você criar algo útil usando este programa, ou as informações contidas no seu fonte, ou melhorar substancialmente o programa, por favor, envie seus resultados. Todos os programas considerados úteis serão publicados no site do autor (com links para os respectivos sites, quando disponíveis).

Linhas de melhoria propostas pelo autor (que ele não pretende desenvolver no futuro próximo):

1. **DCU Browser** — um utilitário GUI para navegar nos DCUs.
2. **Disassembler mais sofisticado** — usando técnicas de análise de fluxo de dados.
3. **Restauração completa do Pascal** a partir do DCU (problema MUITO difícil); passos intermediários: produzir Pascal com procedimentos em ASSEMBLER.
4. **Arquivo de entrada adicional** com informação extra de adivinhação para o DCU analisado.
5. **Geração de saída no estilo C++ Builder** (sintaxe C++ + extensões Borland).
6. **Entender o encoding inline** para exibir o código de templates.

---

## Licença

Este software é fornecido **"as-is"**, sem garantia expressa ou implícita. Em nenhum caso o autor será responsabilizado por danos decorrentes do uso deste software.

É concedida permissão a qualquer pessoa para usar este software para qualquer finalidade, incluindo aplicações comerciais, e alterá-lo e redistribuí-lo livremente, sujeito às seguintes restrições:

1. A origem deste software não deve ser distorcida; você não deve afirmar que escreveu o software original.
2. Versões alteradas do fonte devem ser claramente marcadas como tais e não devem ser apresentadas como o software original.
3. Este aviso não pode ser removido ou alterado de qualquer distribuição do fonte.