# 🚀 Lampy

> Ambiente LAMP completo em segundos, com interface amigável e suporte a múltiplos sites.

![GitHub stars](https://img.shields.io/github/stars/augsec/lampy?style=social)
![License](https://img.shields.io/github/license/augsec/lampy)
![Last commit](https://img.shields.io/github/last-commit/augsec/lampy)

<p align="center">
  <img src="docs/images/demo.gif" alt="Lampy Demo" width="600">
</p>

## ✨ Por que Lampy?

- 🎯 **Simples**: Um comando para instalar tudo
- 👀 **Visual**: Interface amigável com feedback em tempo real
- 🛡️ **Seguro**: Código aberto e transparente
- 🎨 **Flexível**: Suporte a múltiplos sites e portas
- 🔧 **Completo**: Apache, MySQL, PHP e phpMyAdmin configurados

## 🚀 Instalação em Um Comando

```bash
curl -fsSL https://raw.githubusercontent.com/augsec/lampy/main/src/lampy.sh | sudo bash
```

## 🛠 Importante: Problemas ao executar o script?
Se estiver usando zsh, fish ou outro shell, o script pode não funcionar corretamente. Para evitar problemas, execute diretamente com Bash:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/augsec/lampy/main/src/lampy.sh)"
```

## 🛠️ Remoção Completa do Lampy
Se desejar remover completamente o Lampy e todos os seus componentes, utilize:
```bash
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/augsec/lampy/main/src/lampy.sh)" -- --remove
```

Isso removerá Apache, MySQL, PHP, phpMyAdmin e todas as configurações criadas pelo Lampy.


## 📦 O que você recebe?

- ⚡ Apache2 otimizado
- 🐘 PHP 8.x com extensões essenciais
- 🗄️ MySQL Server
- 🎛️ phpMyAdmin pré-configurado
- 🌐 3 sites de exemplo prontos para usar
- 🔒 Configurações seguras por padrão

## 🎯 Requisitos

- Sistema Ubuntu/Debian
- Acesso root/sudo
- ~500MB de espaço livre
- Conexão com internet


## 📜 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

## ⭐ Apoie o Projeto

Se o Lampy te ajudou, considere:

- Dar uma estrela no GitHub
- Compartilhar com amigos
- [Contribuir com código](https://github.com/augsec/lampy/contribute)

## 📞 Suporte

- [Issues](https://github.com/augsec/lampy/issues)
- [Discussions](https://github.com/augsec/lampy/discussions)
- [Discord](https://discord.gg/seu-servidor)

---

<p align="center">
Feito com ❤️ por github.com/augsec
</p>
