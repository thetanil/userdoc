# userdoc

Literate Programming Experiment

```sh
curl -L -O https://github.com/thetanil/userdoc/releases/latest/download/carl.vm && sh carl.vm
```

## delivery

go app with embed fs unpacked

- cache kernel
- upinevm
- hugo
- act
- pandoc
- prebuilt carl-exit
- bins for rootfs

### no

i want to launch hugo to present page about how it works and things you can do with it
i want to be able to add things to do with it from within it
it just needs
upinevm built 1 times and then it takes input and output
it needs act and hugo and no go so prebuilt
you can just use the thing without building more vms, that is an installed module since it's targetted at devs

it needs pandoc
and git?
how do i edit and save files - in host
act inside

### next

remove upina
download zip

```sh
curl -L -o repo.zip https://github.com/diatribes/upinevm/archive/refs/heads/main.zip

```
