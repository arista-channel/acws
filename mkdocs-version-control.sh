# Deploy version 2025.2.NAS
mike deploy --push --update-aliases --ignore-remote-status 2025.2.NAS latest

# Deploy additional versions
mike deploy --push --update-aliases --ignore-remote-status 2025.1.ORL

# Set default version
mike set-default --push latest

# List all versions
mike list
