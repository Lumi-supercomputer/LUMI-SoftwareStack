# How to test?

## rclone and s3cmd

-   Check if `/appl/local/training` can be synchronised with LUMI-O (uses `rclone`)

-   Go through the course exercises.


## Restic

This is the tricky one as we are not familiar with it...

Start with the instructions from the LUMI docs that are actually wrong:

``` bash
export AWS_ACCESS_KEY_ID=<MY_ACCESS_KEY>
export AWS_SECRET_ACCESS_KEY=<MY_SECRET_ACCESS_KEY>
export AWS_DEFAULT_REGION='default'
export RESTIC_PASSWORD=Tiator404
export RESTIC_REPOSITORY="s3:https://<project_number>.lumidata.eu/<bucket>"
restic init
```

Looks like you may have to create the bucket first though with `s3cmd`.

The alternative for `RESTIC_REPOSITORY` is to always use the `-r` flag of the `restic` command,

``` bash
restic -r s3:https://<project_number>.lumidata.eu/<bucket> init
```

