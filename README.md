# docker_ee

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with docker_ee](#setup)
    * [What docker_ee affects](#what-docker_ee-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with docker_ee](#beginning-with-docker_ee)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Docker Enterprise Edition is a large piece of vendor software. This module simplifies
the installation on RedHat. The only input needed is the Docker URL assigned to you
by the vendor.

This module installs Docker Enterprise Edition. Use it instead of a manual install.

## Setup

### Setup Requirements

This module requires that, at a minimum, the Docker EE URL be passed in as a parameter.

### Beginning with docker_ee

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most
basic use of the module.

## Usage

```puppet
class { '::docker_ee':
  docker_ee_url  => 'https://storebits.docker.com/ee/abc123',
}
```

## Reference

### Classes

#### Public classes

* docker_ee: Main class, includes all other classes.

#### Private classes

* docker_ee::pre_install: Adds the YUM meta information necessary to configure the YUM repo.
* docker_ee::yum_memcache: Reset the YUM memchache to reflect the newly added repository.
* docker_ee::install: Installs the Docker Enterprise Edition package.

### Parameters

The following parameters are available in the `::docker_ee` class

#### `docker_ee_url`

Required.

Data type: Stdlib::Httpurl

The Docker EE URL you will be assigned by the vendor.

#### `docker_os_version`

Optional.

Data Type: Numeric

The version of the RedHat OS you are using.

## Limitations

This currently only works for RedHat.

## Development

Any contributions are welcomed!
