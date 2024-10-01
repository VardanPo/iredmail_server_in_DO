# iRedMail Setup with Ansible on Digitalocean

This repository automates creating project and droplet on a DigitalOcean, configure and setup an iRedMail server on this droplet running Ubuntu 24.x using Ansible.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Introduction

iRedMail is a powerful open-source mail server solution that supports a variety of features like mail filtering, antivirus, and webmail. This Ansible playbook simplifies the installation and configuration of iRedMail on an Ubuntu 24.x server hosted on DigitalOcean.

## Prerequisites

1. **DigitalOcean Account**:

   - Create an account on DigitalOcean.
2. **Domain**:

   - Ensure you have a domain or subdomain pointed to the DigitalOcean Droplet's IP.
3. **Tocken**:

   - Create API token for connecting to your account.

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/VardanPo/iredmail_server_in_DO.git
cd iredmail-ansible
```

### 2. Configure Variables

Add on github required variables:

    DO_API_TOKEN: Your API token

    ANSIBLE_USER_PASS: Password for set to ansible user on droplet

    ANSIBLE_PRIVATE_KEY: Linux ssh private key

    ANSIBLE_PUBLIC_KEY: Linux ssh public key

    iRedMail_HOST: Server host you can set empty variables because it is updated on process

**Fill config file template.**

### 3. Update the DNS

Before running the playbook, make sure your domain’s MX, A, and SPF records are updated.

- **A Record**: Point your domain/subdomain to the droplet’s IP.
- **MX Record**: Add an MX record pointing to your domain/subdomain.
- **SPF Record**: Add an SPF record to indicate the droplet as an authorized mail server.

### 4. Run

Run the action "Create new project".

### Usage

Once the installation completes, you can:

- Access the iRedMail admin panel at `https://mail.yourdomain.com/iredadmin`.
- Access webmail using `https://mail.yourdomain.com/mail`.
- Manage email accounts, aliases, and configurations through the iRedMail interface.
