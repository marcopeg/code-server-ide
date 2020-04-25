# NGiNX With Custom Password

This demo runs an NGiNX project protected by a _custom password_.

```
user: test
pass: test
```

## Create a Custom Password

1. `htpasswd -n username`
2. replace `$` with `$$` to escape it in the YAML file
