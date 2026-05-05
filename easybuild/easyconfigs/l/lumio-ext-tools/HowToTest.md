# How to test?

## rclone and s3cmd

-   Check if `/appl/local/training` can be synchronised with LUMI-O (uses `rclone`)

-   Go through the course exercises.


## Restic

This is the tricky one as we are not familiar with it...

Start with the instructions from the LUMI docs that are actually wrong:

``` bash
module load lumio-ext-tools/1.1.0
export AWS_ACCESS_KEY_ID=<MY_ACCESS_KEY>
export AWS_SECRET_ACCESS_KEY=<MY_SECRET_ACCESS_KEY>
export RESTIC_PASSWORD=<password>>
export RESTIC_REPOSITORY="s3:https://lumidata.eu/<bucket>"
restic init
```

Even though the restic manual claims that path-style addressing should be used, the project number
should not be part of the repository URL!

Looks like you may have to create the bucket first though with `s3cmd`.

The alternative for `RESTIC_REPOSITORY` is to always use the `-r` flag of the `restic` command,

``` bash
restic -r s3:https://lumidata.eu/<bucket> init
```

Optional settings:

``` bash
export AWS_DEFAULT_REGION="lumi-prod"
```

but it does not seem to be really needed. You may want to use it if you get error messages about
non-matching signatures.

