

**Basic Service Management**

We will be working with many other services apart from `ssh` and `docker`, so it might be useful to know some basic commands for managing various Linux services:

```bash
# Starting a service
sudo systemctl start [service]

# Stopping a service
sudo systemctl stop [service]

# Enabling a service so it always starts at bootup
sudo systemctl enable [service]

# Disabling a service so it doesn't start at bootup
sudo systemctl disable [service]

# Enable and start the service at the same time
sudo systemctl enable --now [service]

# Disable and stop the service at the same time
sudo systemctl disable --now [service]
```

