# Design Document: VM-based System with Cloud-Hypervisor API Driven by Act

## initial motivation

documents are named after the directory which defines them
the path in url, static/, doc/, and src/ are all the same hierarchy, doc being the master.

code ectracted from doc lands in src/
index.md builds with output into static/
srv

Imagine an LSP which can allow moving cells through trees, like code filename
structure, md doc trees, with context sensitive generative text

- later cool styles
- later partial refresh
- later rst and asciidoc

pid0 launches 
## the incetption

do buildroot, add act, no gcc, mount disk image, run act

goal is to launch root vm and curl to it's libvirt api
write a gihub action. it has the following jobs, 
if there is not a /tmp/udos/buildroot
if /.actrc exists cd / and ./act
ln
run act
if not we are manager api, connect socket for api server
- base os can run act
cloud-hypervisor initramfs with disk, no busybox, using buildroot. i need a github action which checks for /.actrc and runs act in / if it's there

so i really am designing a linux distribution which is natively virtualized.
virtual disks on bittorent are the method of distribution. can run from any
restic hash restoration point. start vm, run act in initrd there is a single
host process which provides 2 interfaces. one to libbirt to start stop and
manage other vms on the same host, and nother docker api so that docker like
tools can launch vms with a familiar api which then uses libvirt.

1 - bootloader, vm, starts libvirt and restic api, attempts to find storage api
to docker image store or loads the one indicated as initrd process and tries
again

3 - optional imaged
TODO: MAKE THE BOOT IMAGE
does disk come 
restic restore disk image
chv kernel restore point, resources

2 - network - ssh -X waypipe or vm curl access to libvirt api


1- storage manager launched with ssh. mounts usb qcows or nfs mounts

3 - repo mounted at nfs-v-root - anything needed to re
3 - repo mounted at nfs-v-root - anything needed to re




## 1. Overview

This system is a VM-based execution environment designed to manage and run workflow steps in isolated micro VMs using Cloud-Hypervisor. Each workflow step runs in its own VM, and the results from one step are used as inputs for the next. The orchestration of these workflows is driven by GitHub Actions, executed using Act. Disk layers, which function similarly to Docker's layered file systems, are managed by snapshots using Restic or Borg, and Cloud-Hypervisor handles the VM execution.

The system integrates Userdoc, enabling the creation of testable documentation that can be run inside the VMs. Each VM step outputs layers that are later consumed as inputs for subsequent steps, maintaining a clean and isolated execution environment.

## 2. Key Components

- **Micro VMs (Cloud-Hypervisor-based)**: Each micro VM is responsible for executing a single workflow step. The VMs use a minimal Linux microkernel built with Buildroot. The kernel is stored in the repository, and each VM boots, runs the step, and then exits.
- **Snapshots (Cloud-Hypervisor and Restic/Borg)**:
  - Cloud-Hypervisor snapshots capture the state of the VM at the end of each step, including disk state.
  - Restic/Borg snapshots manage the layered disk structure, capturing the filesystem state at various points in the workflow.
- **Layered Disks**: Disks are organized into layers. At the start of each step, an input disk is mounted from a previous snapshot, and a new output layer is created for any changes or results. This output layer becomes the input for the next step.
- **Buildroot and Kernel Configuration**: The system uses Buildroot to build a minimal Linux kernel and initrd for the VMs. The kernel configuration is stored in the repository and is used to consistently build the kernel for the Cloud-Hypervisor environment.
- **Act for Orchestration**: Act runs the workflow defined in GitHub Actions, orchestrating the VMs and managing the sequence of operations. Each step of the workflow corresponds to a VM execution, and workflows are broken down into reusable actions.
- **Userdoc**: Testable documents are executed inside the VMs, ensuring that documentation is up-to-date and can be verified during the VM-based workflow execution.

## 3. System Architecture

### Workflow Execution
- A workflow defined in GitHub Actions is broken down into discrete steps.
- Each step is run inside a micro VM managed by Cloud-Hypervisor.
- At the end of each step, the output (disk layer) is snapshotted and prepared as input for the next step.
- If a step is committed (tagged in Git), the disk layer is merged with the base layer.

### Disk Layer Management
- Disks are composed of a base input disk (snapshot) and an output layer.
- At the start of each step, the VM mounts a read-only input disk and a writable output disk.
- Once the step completes, the writable disk is snapshotted using Restic/Borg, and this snapshot becomes the input for the next step.
- Snapshots are managed efficiently, with strategies for merging, deduplication, and garbage collection to prevent unnecessary storage growth.

### Buildroot Kernel Configuration
- The Linux kernel used by the micro VMs is built using Buildroot.
- A kernel configuration file is stored in the repository to ensure consistent kernel builds.
- The kernel, along with an initrd (initial RAM disk), is used by Cloud-Hypervisor to boot the VMs. The initrd is configured to work with Act workflows.

### Cloud-Hypervisor Snapshot Management
- Cloud-Hypervisor supports snapshot and restore functionality, allowing the system to take a snapshot of the VM's disk at the end of each step.
- These snapshots are integrated with Restic/Borg to capture both the file system state and the block device changes efficiently.
- When a step is tagged in Git, the current disk layer is merged with the base layer, ensuring a clean base image for future steps.

### Userdoc Integration
- Userdocs are Markdown documents containing executable code snippets.
- These documents are run inside the VMs, ensuring they are testable and verified during the VM-based workflow execution.
- As the VM steps progress, the system captures the output of Userdoc snippets to ensure correctness.

## 4. Epics and Developer Work Breakdown

### Epic 1: Cloud-Hypervisor VM Orchestration and Snapshot Management
**Owner**: Developer Team A

**Objective**: Build the core system responsible for orchestrating the micro VMs using Cloud-Hypervisor and managing Cloud-Hypervisor-based snapshots.

**Key Features**:
- Implement the Cloud-Hypervisor-based VM launcher that can execute a step inside a micro VM and capture snapshots (disk state).
- Design the interface between VM execution and the Act-driven orchestration.
- Implement snapshot management using Cloud-Hypervisor's snapshot system.
- Integrate with Act to trigger VM launches at the appropriate points in the workflow.

**User Stories**:
- As a developer, I want to define a VM execution step in a GitHub Actions workflow and have it run seamlessly in a Cloud-Hypervisor-based micro VM.
- As a developer, I want to capture the state of a micro VM at the end of each step for later retrieval.
- As a system architect, I want to ensure that multiple VMs can run in parallel without conflicts.

### Epic 2: Disk Layer Management with Restic/Borg
**Owner**: Developer Team B

**Objective**: Create the layered disk management system that ensures efficient and consistent input/output between VM steps and uses Restic/Borg for snapshotting.

**Key Features**:
- Develop the logic to mount an input disk (read-only) and create a writable output layer for each VM.
- Integrate Restic/Borg snapshots for file system layer management, including deduplication and retention policies.
- Implement a strategy for merging disk layers to avoid unnecessary growth, especially when a Git tag is created.
- Create APIs to manage layer state between steps and VMs.

**User Stories**:
- As a developer, I want to mount an input disk from a snapshot and use it as the base for the VM’s operations.
- As a developer, I want to snapshot the writable output layer at the end of a step and prepare it for use in the next VM.
- As a system architect, I want to ensure the system can efficiently merge and deduplicate disk layers to optimize storage usage.

### Epic 3: Buildroot Kernel and Initrd Configuration
**Owner**: Developer Team C

**Objective**: Build the minimal Linux kernel and initrd used for the micro VMs, ensuring that it integrates seamlessly with Cloud-Hypervisor and Act.

**Key Features**:
- Store the kernel configuration in the repository to ensure consistent builds.
- Use Buildroot to create the kernel and initrd for the VMs.
- Ensure the initrd can execute Act workflows within the VM environment.
- Provide a mechanism for rebuilding the kernel and initrd based on repository changes.

**User Stories**:
- As a system architect, I want to use a consistent Linux kernel configuration for all VM steps.
- As a developer, I want to ensure the initrd can run the required Act workflows inside the VM.
- As a developer, I want to rebuild the kernel and initrd automatically when configuration changes are committed to the repository.

### Epic 4: Act Workflow Integration
**Owner**: Developer Team D

**Objective**: Build the integration with Act to automate the workflow defined in GitHub Actions and ensure seamless orchestration of the VMs and layers.

**Key Features**:
- Extend Act to trigger the launch of micro VMs as part of workflow steps.
- Break down the workflow into reusable actions, each responsible for a specific task.
- Manage the lifecycle of VMs, including start, stop, and snapshot.
- Implement retries and error handling to ensure robust workflow execution.

**User Stories**:
- As a developer, I want to define reusable actions for VM execution in GitHub Actions.
- As a system architect, I want Act to manage VM lifecycle automatically during workflow execution.
- As a developer, I want to pass the output of one step’s VM execution to the next step as input.

### Epic 5: Userdoc Integration
**Owner**: Developer Team E

**Objective**: Enable Userdocs to be executed inside the VM steps and capture their output as part of the workflow.

**Key Features**:
- Implement support for Userdocs (Markdown-based testable documentation) to be run inside each micro VM.
- Capture and report the results of the Userdoc execution, ensuring that all code snippets are correct.
- Provide a feedback loop for developers to update and maintain Userdocs based on their execution results.

**User Stories**:
- As a developer, I want to include Userdocs in the workflow and have them automatically executed in the VMs.
- As a system architect, I want to capture the output of Userdoc executions to verify their correctness.
- As a developer, I want to update the Userdocs and have them re-tested automatically in the next workflow run.

## 5. Conclusion

This system provides a modular and testable environment for executing complex workflows inside micro VMs using Cloud-Hypervisor. By leveraging Act for orchestration and integrating Restic/Borg for efficient disk layer management, the system is both flexible and scalable. The addition of Buildroot for kernel configuration ensures that the VMs are lightweight and performant. By breaking down the work into epics, multiple developer teams can contribute to different parts of the project, ensuring that the system can be developed and maintained efficiently.