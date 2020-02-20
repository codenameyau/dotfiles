# vscode

## Extensions

Copying the extensions you have installed.
```
code --list-extensions | pbcopy
```

Compare and get unique exensions.
```
pbpaste | sort | uniq | pbcopy
```

Installing extensions from clipboard.
```bash
cat | xargs -L 1 code --install-extension
```

These are my current extensions.
```
ChakrounAnas.turbo-console-log
CoenraadS.bracket-pair-colorizer
alefragnani.project-manager
christian-kohler.npm-intellisense
dbaeumer.vscode-eslint
dsznajder.es7-react-js-snippets
eamodio.gitlens
eg2.vscode-npm-script
esbenp.prettier-vscode
fabiospampinato.vscode-diff
jpoissonnier.vscode-styled-components
mauve.terraform
mikestead.dotenv
ms-azuretools.vscode-docker
ms-python.python
ms-vscode.atom-keybindings
ms-vsliveshare.vsliveshare
olback.es6-css-minify
pflannery.vscode-versionlens
redhat.vscode-yaml
scala-lang.scala
silvenon.mdx
timonwong.shellcheck
torn4dom4n.latex-support
waderyan.gitblame
```
