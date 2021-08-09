# Docker / Spring boot template

### Running with Docker
```sh
docker build -t demo-app .
docker run -p 8080:8080 -t demo-app .
```

### Running locally without Docker (so you can take advantage of live reload)
- Option 1: Run inside IntelliJ, run the main class
- Option 2: Run
```sh
mvn compile exec:java -Dexec.mainClass="com.example.demo.DemoApplication"
```

### Running with Jib
I've also added the Jib plugin in pom.xml, so you can optionally choose to run it with Jib. The benefit with Jib is that you can use it to quickly deploy it to GCloud and/or deploy the image to the GCloud repository, so you can `docker pull gcr.io/<image-name>` quickly on your server machine, say on Digital Ocean. This way you don't need to sync with git and do `git pull` and then `docker build`, you can directly `docker pull` and then `docker run`.
- To run with Jib, you should specify the gcr.io repository you want to push to. And to push, run
```sh
mvn compile jib:build
```
If you want to build a local image instead, run 
```sh
mvn jib:dockerBuild
```