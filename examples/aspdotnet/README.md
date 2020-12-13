# .NET Core Demo

CodeServerIDE comes with pre-installed .NET SDK and runtime for versions:

- 2.1
- 3.1
- 5.0

The folder `myWebApp` was created using a .NET scaffold:

```bash
dotnet new webapp -o myWebApp --no-https
```

> 👉 It is important to add `--no-https` as we will let the reverse proxy to take
> care of SSL. It's a bad bad idea to have your app handling it directly!

## Before you run it

The app will run on port `5000` (.NET defaults) so we need to prepare a proxy towards
such port:

```bash
cs proxy up -p 5000
```

Once you run the app -- natively, Docker prod, Docker dev) -- it will be available at:

```bash
https://p5000.your.machine.com
```

## Run it Natively

Build and run the app:

```bash
dotnet run --project myWebApp/
```

Or start the app and automatically re-build it on every file change:

```bash
dotnet watch run --project myWebApp/
```

## Distribute it with Docker

.NET for Docker supports the runtime version 3.1 at the time of writing. 

Although it is not a problem to work with the SDK 5.0 and target runtime 3.1, 
you need to explicitly set it up in `myWebApp/myWebApp.csproj`:

```xml
<!-- Find: -->
<TargetFramework>net5.0</TargetFramework>

<!-- Change it with: -->
<TargetFramework>netcoreapp3.1</TargetFramework>
```

Now you can build your local container:

```bash
docker build -t my-web-app .
```

and test it through the proxy that we have set up:

```bash
docker run -p 5000:80 my-web-app
```

## Develop inside a Docker container

The ultimate way of work for the mitigation of the _**"it works on my machine"**_ issue, is to run your development process directly inside a Docker container. 

This is often achieved by running basic images (.NET, NodeJS, ...) and mapping your source folders into the running container.

Before you start the `docker-compose.yml` project, there is another modification that needs to be performed on the scaffolded project.

.NET bind the process to `localhost`, but that needs to be changed to `0.0.0.0` for Docker to correctly route traffic.

Open up `myWebApp/Properties/launchSettings.json` and fix the `profiles.myWebApp.applicationUrl` property to look like the following:

```json
"applicationUrl": "http://0.0.0.0:5000",
```

With this step done, you are ready to launch the Docker Compose project:

```bash
docker-compose up
```

And open your browser to:

```bash
https://aspdotnet.your.machine.com
```
