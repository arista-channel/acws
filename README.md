# TOLA Campus Workshop

This is the home of the Campus ATD Workshop lab guides and AVD repository.

## Getting Started

1. Create a python virtual environment and install requirements

    ```bash
    python3 -m venv venv && source venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt
    ```

2. Launch the Mkdocs server

    ```bash
    mkdocs serve -a 127.0.0.1:8001
    ```

3. Navigate to [http://127.0.0.1:8001](http://127.0.0.1:8001)

## Contributing

Contributing to the guides is welcome, you can follow the steps below to contribute

1. Clone the repository, it's recommended to [setup GitHub SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

    ```yaml
    git clone git@github.com:kpbush30/campus-workshop.git
    ```

2. Create a branch, try naming the branch after the docs you are modifying.

    ```yaml
    git branch -c your-branch
    ```

3. Install pre-commit

    ```yaml
    pre-commit install
    ```

4. Make your changes and push to your branch

5. Finally, open a PR on GitHub and notify the maintainers

## Maintainers

- Kyle Bush ([kbush@arista.com](mailto:kbush@arista.com))
- Larry Gomez ([larry@arista.com](mailto:larry@arista.com))
