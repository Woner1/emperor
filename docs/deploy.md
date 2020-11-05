# Deploy TO AWS ECS

#### USE AWS ECS Deploy Tool `UFO`

[<img src="/docs/img/ufo-logo-2.png" height="50px" width="50px" > ](https://ufoships.com/)    [ufo docs](https://ufoships.com/docs/)

Install with RubyGems
You can install ufo with RubyGems:

`gem install ufo`

The docker image tag that is generated contains a useful timestamp and the current HEAD git sha of the project that you are on.

```shell
ufo init --app ${APPLICATION_NAME} --image ${ALIYUN_REPOSITORY} --execution-role-arn ${ECS_TASK_EXECUTION_ROLE}

ufo docker build --push

ufo current --service emperor-web

ufo ship

ufo pss
```

#### connection aws rds
```shell
psql --host ${aws_rds_psqlgresql_host} --port 5432 --username 
${aws_rds_postgresql_username} -d ${aws_rds_psqlgresql_host_database_name}
```

