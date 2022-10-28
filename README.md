# CA1: Dockerfile Composition - Cloud Based Web Application.
 
Name: Rosana Cardoso Batista Torres ID: 2022000 - CCT College Dublin

Based on the BusyBox httpd static file server, this Docker image (154KB) can run any static webpage.

## Download
To begin, download the repository.

## Usage
Build the image:

```sh
docker build -t my-static-website .
```
Run the image on port 8080:

```sh
docker run -it --rm -p 8080:8080 my-static-website
```
Browse to http://localhost:8080.

## After the container is executed, it runs busybox, httpd, and continues.

```
CMD ["/busybox", "httpd", "-f", "-v", "-p", "8080", "-c", "httpd.conf"]
```

NOTE: .dockerignore and .gitignore files are added in order no to add some files to the container when runing and to the git repository respectively.

## Change httpd.conf if necessary to allow or deny container ID/rules.

Add to httpd.conf file and use the P directive:

P:/some/old/path:[http://]hostname[:port]/some/new/path

If you want to overide the default error page -> Add to the httpd.conf file and use the E404 directive:

```
E404:e404.html
```

where e404.html is your custom 404 page.

Note: that the error page directive is only processed for your main httpd.conf file. It will raise an error if you use it in httpd.conf files added to subdirectories.

## Implement basic security measures in your image.

Add to httpd.conf file and use the A and D directives:

```
A:172.20.        # Allow address from 172.20.0.0/16
A:10.0.0.0/25    # Allow any address from 10.0.0.0-10.0.0.127
A:127.0.0.1      # Allow local loopback connections
D:*              # Deny from other IP connections
```

You can also allow all requests with some exceptions:

```
D:1.2.3.4
D:5.6.7.8
A:* # This line is optional
```
# use basic auth for some of my paths?

Add a httpd.conf file, listing the paths that should be protected and the corresponding credentials:

/admin:my-user:my-password # Require user my-user with password my-password whenever calling /admin

## References List
a)	https://github.com/lipanski/docker-static-website#readme

b)	https://lipanski.com/posts/smallest-docker-image-static-website

c)	https://medium.com/@selvarajk/deploy-a-static-website-with-docker-597365d04523

d)	https://www.youtube.com/watch?v=4pRo6Ud1JI8

e)	https://www.youtube.com/watch?v=UXAoZg1W3Q4

f)  https://docs.docker.com/develop/develop-images/baseimages/
