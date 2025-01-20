# dotfiles

I manage the various configuration files in this repo using GNU Stow. This allows me to set up symlinks for all of my dotfiles using a single command:

```bash
stow --dir="files/" --target="$HOME" .
```

## License

dotfiles is released under the [MIT License](LICENSE).
