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

3. Navigate to [http://127.0.0.1:8000](http://127.0.0.1:8000)

## Contributing

Contributing to the guides is welcome, you can follow the steps below to contribute

1. Clone the repository, it's recommended to [setup GitHub SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

    ```bash
    git clone git@github.com:kpbush30/campus-workshop.git
    ```

2. Create a branch, try naming the branch after the docs you are modifying.

    ```bash
    git branch -c your-branch
    git switch your-branch
    ```

3. Install pre-commit

    ```bash
    pre-commit install
    ```

4. Make your changes and push to your branch

    ```bash
    git add --all
    git commit -m "Ccommit message"
    git push
    ```

5. If pre-commit catches any errors, fix the errors to commit. Some formatting fixes are done for you and must be re-committed

    ```bash
    git commit -am "Ccommit message"
    git push
    ```

6. Finally, open a PR on GitHub and notify the maintainers

## Running Server

To run mkdocs behind an nginx server

1. [Install nginx](https://getnoc.com/blog/2023-hosting-a-mkdocs-generated-site-using-nginx/)
2. Build the mkdocs site
3. Navigate to the server IP

   !!! tip "Mac OS"

        If you are unable to navigate to the local IP address, you may to open `System Prefrences

### References

- https://www.pulleycloud.com/mkdocs-nginx-aws-ec2/part-2/
-

## Maintainers

- Kyle Bush ([kbush@arista.com](mailto:kbush@arista.com))
- Larry Gomez ([larry@arista.com](mailto:larry@arista.com))
