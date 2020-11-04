#### `What is Prometheus?`
    Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud.

### `Features`
Prometheus's main features are:

* a multi-dimensional data model with time series data identified by metric name and key/value pairs
* PromQL, a flexible query language to leverage this dimensionality
* no reliance on distributed storage; single server nodes are autonomous
* time series collection happens via a pull model over HTTP
* pushing time series is supported via an intermediary gateway
* targets are discovered via service discovery or static configuration
* multiple modes of graphing and dashboarding support


### `Prometheus In Docker`
``` docker
docker run -d \
    -p 9090:9090 \
    --name prometheus \
    -v ~/tmp/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus
```

### `Jenkins In Docker`

* `Jenkins – an open source automation server which enables developers around the world to reliably build, test, and deploy their software.`
  
##### run command
``` docker
docker run -d -p 8080:8080 -p 5000:5000 \
  --name jenkins \
  -v $(which docker):/usr/bin/docker\
  -v jenkins_home:/var/jenkins_home \
  --privileged=true \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:latest
```
###### The user jenkins needs to be added to the group docker
```shell
sudo usermod -aG docker jenkins
sudo chmod 777 /var/run/docker.sock
```
###### Then restart your jenkins server to refresh the group.
```shell
docker restart jenkins
```
##### or reboot your compter
```shell
sudo reboot
```

### `Granafa In Docker`
* `Grafana allows you to query, visualize, alert on and understand your metrics no matter where they are stored. Create, explore, and share dashboards with your team and foster a data driven culture:`

```docker
docker run -d -p 3001:3000 \
  --name granfana \
  grafana/grafana
```


### `Cadvisor In Docker`
* `cAdvisor (Container Advisor) provides container users an understanding of the resource usage and performance characteristics of their running containers. It is a running daemon that collects, aggregates, processes, and exports information about running containers. Specifically, for each container it keeps resource isolation parameters, historical resource usage, histograms of complete historical resource usage and network statistics. This data is exported by container and machine-wide.`
  
```docker
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8082:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  google/cadvisor:latest
```

### `Prometheus Exporter`

<font color=Green>Node Export</font>
```text
The node_exporter is designed to monitor the host system. 
It's not recommended to deploy it as a Docker container
```

[Node Exporter docs](https://github.com/prometheus/node_exporter)

* <font color=Green>Jenkins Prometheus metrics </font>
  
    `Expose Jenkins metrics in prometheus format`
    [Jenkins Prometheus metrics docs](https://plugins.jenkins.io/prometheus/)
