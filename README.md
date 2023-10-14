# Deploying a Phoenix App with Kamal

## Resources

[Kamal Documentation](https://kamal-deploy.org/docs/installation)

[Deploy Phoenix with Kamal](https://mrdotb.com/posts/deploy-phoenix-with-kamal)

## Droplets

Create 2 droplets, record their names and IP addresses

Name:
IP:

Name:
IP:

## Load Balancer

Create a load balancer in Digital Ocean for the project, record its name and IP address

Name:
IP:

Upon creating the Load Balancer, you should also setup a health check so Kamal can check if the application is running on the droplets

## Database Cluster

Create a database cluster in Digital Ocean for the project, record its name

Name:

### PostgreSQL Instance

Record the connection URL for the PostgreSQL instance, replacing values as needed

```bash
postgresql://USER:PASSWORD@HOST:PORT/DATABASE
```

When connecting to Ecto, the URL should look like this

```bash
ecto://USER:PASSWORD:PORT/DATABASE
```

This URL will be used in the `DATABASE_URL` variable in `.env`

Also update the `runtime.exs` file

```elixir
config :my_app, MyApp.Repo,
    ssl: true,
    ssl_opts: [
      verify: :verify_none
    ],
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6
```

To allow the database cluster to be accessed from the droplets

## Digital Ocean API Key

Create an Digital Ocean API Key in order to use the Digital Ocean Container Registry

Name:
Key:

## Create Digital Ocean Container Registry

Update Kamal `deploy.yml`

```yaml
registry:
  server: registry.digitalocean.com/REGISTRY_NAME
  username:
    - DIGITAL_OCEAN_API_KEY
  password:
    - DIGITAL_OCEAN_API_KEY
```

## Kamal Setup

### Install Kamal

```bash
$ gem install kamal

$ kamal v
```

### Initialize Kamal in Project

Inside the the project directory, run

```bash
$ kamal init
```

### Phoenix `SECRET_KEY_BASE`

To deploy the Phoenix application in production, the `SECRET_KEY_BASE` variable must be set in `.env`

Generate the value for `SECRET_KEY_BASE`, run

```bash
$ mix phx.gen.secret
```

## DNS Setup

This project uses Cloudflare for DNS

First, create a DNS record for `myhostname.com` with the IP of the Load Balancer created in Digital Ocean

Choose the domain name to use for the project, record its name and update the `runtime.exs` file
  
```elixir
host = System.get_env("PHX_HOST") || "example.com"

config :my_app, MyAppWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
```

Also add this hostname in `.env` file

```bash
PHX_HOST=myhostname.com
```

## Deploy

To deploy your infrastructure and application, run

```bash
$ kamal deploy
```

If everything goes well, you should be able to access the application at `https://myhostname.com`

To check if the application is running on the droplets you can visit `https://myhostname.com/up`
