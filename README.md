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

<p align="center">
  <img src="docs/images/install.png" alt="Instalação Lampy" width="600">
</p>

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

## 📘 Guia Detalhado

### Instalação Manual

Prefere ver o que está instalando? Sem problema!

```bash
# Clone o repositório
git clone https://github.com/augsec/lampy.git

# Entre no diretório
cd lampy

# Torne o script executável
chmod +x src/lampy.sh

# Execute
sudo ./src/lampy.sh
```

### Após a Instalação

O Lampy configura automaticamente:

1. **Sites de Exemplo**

   ```
   http://site1.local
   http://site2.local:8080
   http://site3.local:8081
   ```

2. **phpMyAdmin**

   ```
   http://localhost/phpmyadmin
   ```

3. **Hosts**
   ```bash
   # Adicione ao /etc/hosts:
   127.0.0.1 site1.local
   127.0.0.1 site2.local
   127.0.0.1 site3.local
   ```

## 🛠️ Comandos Úteis

```bash
# Reiniciar Apache
sudo systemctl restart apache2

# Ver logs do Apache
tail -f /var/log/apache2/error.log

# Acessar MySQL
sudo mysql
```

## 🗂️ Estrutura de Diretórios

```
/var/www/
├── html/           # Site principal
│   └── phpmyadmin/ # Interface MySQL
└── sites/          # Sites adicionais
    ├── site1.local/
    ├── site2.local/
    └── site3.local/
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Veja como:

1. Fork o projeto
2. Crie sua branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add: nova funcionalidade'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 💡 Roadmap

- [ ] Suporte a mais distribuições Linux
- [ ] Opções de configuração via argumentos
- [ ] Interface de administração web
- [ ] Integração com Docker
- [ ] Suporte a SSL automático

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

## 🔍 Segurança e Transparência

O Lampy é 100% open source - você pode auditar cada linha de código. Valorizamos:

- 🔒 Segurança por padrão
- 📖 Código aberto e documentado
- 🤝 Feedback da comunidade
- 🚀 Atualizações frequentes

---

<p align="center">
Feito com ❤️ por github.com/augsec
</p>
