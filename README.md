# ⚠️⚠️⚠️ this repo is archived / discontinued ⚠️⚠️⚠️

work continued [here](https://github.com/duke8585/modern-python-repo)


# a python project makefile

for setting un neat specific venvs in your repo projects.

uses pyenv for version mgmt, pip and venv for creating .venv folder and installing dependencies.

# extras

## auto activate

auto activating venv on cd-ing into a directory. if using oh-my-zsh, add `virtualenv-autodetect` ([ref](https://stackoverflow.com/a/75780125/8863259))

to your plugins in the `~/.zshrc`

```bash
plugins=(
    ...
    virtualenv-autodetect # ⬅️ this
    ...
    )
```
