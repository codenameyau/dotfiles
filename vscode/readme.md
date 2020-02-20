# vscode

## Extensions

Copying the extensions you have installed.
```
code --list-extensions | pbcopy
```

Installing extensions from clipboard.
```bash
pbpaste | xargs -L 1 echo code --install-extension
```

These are my current extensions.
```
alefragnani.project-manager
ChakrounAnas.turbo-console-log
christian-kohler.npm-intellisense
dbaeumer.vscode-eslint
eamodio.gitlens
esbenp.prettier-vscode
jpoissonnier.vscode-styled-components
mikestead.dotenv
ms-azuretools.vscode-docker
ms-python.python
ms-vscode.atom-keybindings
silvenon.mdx
timonwong.shellcheck
torn4dom4n.latex-support
waderyan.gitblame
```
